class BudgetVotesController < ApplicationController
  before_action :set_budget
  before_action :set_budget_phase
  before_action :set_budget_vote, only: [:show]

  def index
    @budget_votes = @budget_phase.budget_votes.includes(:vote_allocations => :budget_category).recent
    @total_allocated = @budget_votes.sum(&:total_amount)
    @average_per_vote = @budget_votes.count > 0 ? @total_allocated / @budget_votes.count : 0
    @category_summary = calculate_category_summary
  end

  def new
    @budget_vote = @budget_phase.budget_votes.build
    @budget_categories = @budget.budget_categories.includes(:budget_allocations)
    
    # Build vote allocations for each category
    @budget_categories.each do |category|
      @budget_vote.vote_allocations.build(budget_category: category)
    end
  end

  def create
    @budget_vote = @budget_phase.budget_votes.build(budget_vote_params)
    @budget_categories = @budget.budget_categories.includes(:budget_allocations)
    
    if @budget_vote.save
      redirect_to budget_budget_phase_path(@budget, @budget_phase), notice: 'Your vote was successfully recorded.'
    else
      # Rebuild vote allocations for the form
      @budget_categories.each do |category|
        @budget_vote.vote_allocations.build(budget_category: category) unless @budget_vote.vote_allocations.any? { |va| va.budget_category_id == category.id }
      end
      render :new, status: :unprocessable_entity
    end
  end

  def show
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

  def budget_vote_params
    params.require(:budget_vote).permit(
      :voter_name, 
      :voter_email, 
      :comments,
      vote_allocations_attributes: [:budget_category_id, :amount]
    )
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
end
