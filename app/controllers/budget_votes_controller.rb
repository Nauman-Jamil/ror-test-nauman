class BudgetVotesController < ApplicationController
  before_action :set_budget
  before_action :set_budget_phase
  before_action :set_budget_vote, only: [:show]
  before_action :ensure_phase_active, only: [:new, :create]

  def index
    @budget_votes = @budget_phase.budget_votes.includes(:vote_allocations => :budget_category).recent
    @total_allocated = @budget_votes.sum(&:total_amount)
    @average_per_vote = @budget_votes.count > 0 ? @total_allocated / @budget_votes.count : 0
    @category_summary = calculate_category_summary
    @category_limits = calculate_category_limits
    @voting_analytics = calculate_voting_analytics
  end

  def new
    @budget_vote = @budget_phase.budget_votes.build
    @budget_categories = @budget.budget_categories.includes(:budget_allocations)
    @category_limits = calculate_category_limits
    @remaining_budget = @budget.remaining_amount
    
    # Build vote allocations for each category
    @budget_categories.each do |category|
      @budget_vote.vote_allocations.build(budget_category: category)
    end
  end

  def create
    @budget_vote = @budget_phase.budget_votes.build(budget_vote_params)
    @budget_categories = @budget.budget_categories.includes(:budget_allocations)
    @category_limits = calculate_category_limits
    @remaining_budget = @budget.remaining_amount
    
    # Real-time validation before saving
    validation_errors = validate_vote_allocations
    
    if validation_errors.empty? && @budget_vote.save
      redirect_to budget_budget_phase_path(@budget, @budget_phase), notice: 'Your vote was successfully recorded.'
    else
      # Add validation errors to the vote object
      validation_errors.each { |error| @budget_vote.errors.add(:base, error) }
      
      # Rebuild vote allocations for the form
      @budget_categories.each do |category|
        @budget_vote.vote_allocations.build(budget_category: category) unless @budget_vote.vote_allocations.any? { |va| va.budget_category_id == category.id }
      end
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @vote_analytics = calculate_vote_analytics
    @category_comparison = calculate_category_comparison
  end

  private

  def set_budget
    @budget = Budget.find(params[:budget_id])
  end

  def set_budget_phase
    @budget_phase = @budget.budget_phases.find(params[:budget_phase_id])
  end

  def set_budget_vote
    @budget_vote = @budget_phase.budget_votes.find(params[:id])
  end

  def ensure_phase_active
    unless @budget_phase.can_vote?
      redirect_to budget_budget_phase_path(@budget, @budget_phase), 
                  alert: "Voting is not currently active for this phase."
    end
  end

  def budget_vote_params
    params.require(:budget_vote).permit(
      :voter_name, 
      :voter_email, 
      :comments,
      vote_allocations_attributes: [:budget_category_id, :amount]
    )
  end

  def validate_vote_allocations
    errors = []
    
    # Check if total amount exceeds remaining budget
    total_vote_amount = @budget_vote.vote_allocations.sum(&:amount)
    if total_vote_amount > @budget.remaining_amount
      errors << "Total vote amount ($#{total_vote_amount.round(2)}) exceeds remaining budget ($#{@budget.remaining_amount.round(2)})"
    end
    
    # Check category limits
    @budget_vote.vote_allocations.each do |allocation|
      next if allocation.amount.blank? || allocation.amount <= 0
      
      category = allocation.budget_category
      current_allocated = @budget.budget_allocations.where(budget_category: category).sum(:amount)
      proposed_total = current_allocated + allocation.amount
      max_allowed = @budget.total_amount * (category.spending_limit_percentage / 100.0)
      
      if proposed_total > max_allowed
        errors << "#{category.name} allocation would exceed the #{category.spending_limit_percentage}% limit (max: $#{max_allowed.round(2)})"
      end
    end
    
    errors
  end

  def calculate_category_summary
    summary = {}
    @budget_votes.each do |vote|
      vote.vote_allocations.each do |allocation|
        category_name = allocation.budget_category.name
        summary[category_name] ||= { total_amount: 0, vote_count: 0, amounts: [] }
        summary[category_name][:total_amount] += allocation.amount
        summary[category_name][:amounts] << allocation.amount
      end
    end
    
    # Calculate averages
    summary.each do |category_name, data|
      data[:vote_count] = data[:amounts].count { |amount| amount > 0 }
      data[:average_amount] = data[:vote_count] > 0 ? data[:total_amount] / data[:vote_count] : 0
    end
    
    summary
  end

  def calculate_category_limits
    limits = {}
    @budget.budget_categories.each do |category|
      current_allocated = @budget.budget_allocations.where(budget_category: category).sum(:amount)
      max_allowed = @budget.total_amount * (category.spending_limit_percentage / 100.0)
      remaining = [max_allowed - current_allocated, 0].max
      utilization_rate = max_allowed > 0 ? (current_allocated / max_allowed * 100).round(2) : 0
      
      limits[category.id] = {
        category: category,
        current_allocated: current_allocated,
        max_allowed: max_allowed,
        remaining: remaining,
        utilization_rate: utilization_rate,
        over_limit: utilization_rate > category.spending_limit_percentage
      }
    end
    limits
  end

  def calculate_voting_analytics
    {
      total_votes: @budget_votes.count,
      total_amount_voted: @total_allocated,
      average_vote_amount: @average_per_vote,
      participation_rate: calculate_participation_rate,
      category_distribution: @category_summary,
      phase_progress: @budget_phase.progress_percentage,
      days_remaining: @budget_phase.days_remaining
    }
  end

  def calculate_participation_rate
    # This would typically be based on eligible participants
    # For now, we'll use a simple calculation
    total_votes = @budget_votes.count
    eligible_participants = 100 # This should come from a configuration
    (total_votes.to_f / eligible_participants * 100).round(2)
  end

  def calculate_vote_analytics
    {
      total_amount: @budget_vote.total_amount,
      category_breakdown: @budget_vote.vote_allocations.map do |allocation|
        {
          category: allocation.budget_category.name,
          amount: allocation.amount,
          percentage: @budget_vote.total_amount > 0 ? (allocation.amount / @budget_vote.total_amount * 100).round(2) : 0
        }
      end,
      voter_info: {
        name: @budget_vote.voter_name,
        email: @budget_vote.voter_email,
        submitted_at: @budget_vote.created_at
      }
    }
  end

  def calculate_category_comparison
    comparison = {}
    @budget_vote.vote_allocations.each do |allocation|
      category = allocation.budget_category
      category_limit = @category_limits[category.id]
      
      comparison[category.id] = {
        category: category,
        vote_amount: allocation.amount,
        current_allocated: category_limit[:current_allocated],
        max_allowed: category_limit[:max_allowed],
        remaining: category_limit[:remaining],
        utilization_rate: category_limit[:utilization_rate],
        would_exceed: (category_limit[:current_allocated] + allocation.amount) > category_limit[:max_allowed]
      }
    end
    comparison
  end
end
