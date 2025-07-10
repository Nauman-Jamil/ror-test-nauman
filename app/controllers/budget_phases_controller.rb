class BudgetPhasesController < ApplicationController
  before_action :set_budget
  before_action :set_budget_phase, only: [:show, :edit, :update, :destroy]

  def index
    @budget_phases = @budget.budget_phases.order(:start_date)
  end

  def show
    @budget_votes = @budget_phase.budget_votes.recent
    @vote_statistics = BudgetVote.vote_statistics(@budget_phase)
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
end
