class BudgetPhasesController < ApplicationController
  before_action :set_budget
  before_action :set_budget_phase, only: [:show, :edit, :update, :destroy, :transition]

  def index
    @budget_phases = @budget.budget_phases.order(:start_date)
    @phase_analytics = calculate_phase_analytics
  end

  def show
    @budget_votes = @budget_phase.budget_votes.recent
    @vote_statistics = BudgetVote.vote_statistics(@budget_phase)
    @phase_analytics = calculate_phase_analytics
    @category_voting_summary = calculate_category_voting_summary
  end

  def new
    @budget_phase = @budget.budget_phases.build
  end

  def create
    @budget_phase = @budget.budget_phases.build(budget_phase_params)
    
    if @budget_phase.save
      redirect_to budget_budget_phase_path(@budget, @budget_phase), notice: 'Budget phase was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @budget_phase.update(budget_phase_params)
      redirect_to budget_budget_phase_path(@budget, @budget_phase), notice: 'Budget phase was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget_phase.destroy
    redirect_to budget_budget_phases_path(@budget), notice: 'Budget phase was successfully deleted.'
  end

  def transition
    if @budget_phase.transition_to_next_phase
      redirect_to budget_budget_phase_path(@budget, @budget_phase), notice: 'Phase transitioned successfully.'
    else
      redirect_to budget_budget_phase_path(@budget, @budget_phase), alert: 'Phase transition failed.'
    end
  end

  def auto_transition
    @budget.budget_phases.each(&:auto_transition)
    redirect_to budget_budget_phases_path(@budget), notice: 'Automatic phase transition completed for all phases.'
  end

  private

  def set_budget
    @budget = Budget.find(params[:budget_id])
  end

  def set_budget_phase
    @budget_phase = @budget.budget_phases.find(params[:id])
  end

  def budget_phase_params
    params.require(:budget_phase).permit(:name, :description, :status, :start_date, :end_date, :voting_rules, :participant_eligibility)
  end

  def calculate_phase_analytics
    analytics = {}
    @budget.budget_phases.each do |phase|
      analytics[phase.id] = {
        total_votes: phase.total_votes,
        participation_rate: calculate_participation_rate(phase),
        average_vote_amount: calculate_average_vote_amount(phase),
        category_distribution: calculate_category_distribution(phase),
        phase_progress: phase.progress_percentage,
        days_remaining: phase.days_remaining
      }
    end
    analytics
  end

  def calculate_participation_rate(phase)
    # This would typically be based on eligible participants
    # For now, we'll use a simple calculation
    total_votes = phase.total_votes
    eligible_participants = 100 # This should come from a configuration
    (total_votes.to_f / eligible_participants * 100).round(2)
  end

  def calculate_average_vote_amount(phase)
    votes = phase.budget_votes
    return 0 if votes.empty?
    votes.sum(&:total_amount) / votes.count.to_f
  end

  def calculate_category_distribution(phase)
    distribution = {}
    phase.budget_votes.includes(vote_allocations: :budget_category).each do |vote|
      vote.vote_allocations.each do |allocation|
        category_name = allocation.budget_category.name
        distribution[category_name] ||= { total_amount: 0, vote_count: 0 }
        distribution[category_name][:total_amount] += allocation.amount
        distribution[category_name][:vote_count] += 1 if allocation.amount > 0
      end
    end
    distribution
  end

  def calculate_category_voting_summary
    summary = {}
    @budget_phase.budget_votes.includes(vote_allocations: :budget_category).each do |vote|
      vote.vote_allocations.each do |allocation|
        category = allocation.budget_category
        summary[category.id] ||= {
          category: category,
          total_amount: 0,
          vote_count: 0,
          average_amount: 0,
          percentage_of_budget: 0
        }
        summary[category.id][:total_amount] += allocation.amount
        summary[category.id][:vote_count] += 1 if allocation.amount > 0
      end
    end

    # Calculate averages and percentages
    summary.each do |category_id, data|
      data[:average_amount] = data[:vote_count] > 0 ? data[:total_amount] / data[:vote_count] : 0
      data[:percentage_of_budget] = @budget.total_amount > 0 ? (data[:total_amount] / @budget.total_amount * 100).round(2) : 0
    end

    summary
  end
end
