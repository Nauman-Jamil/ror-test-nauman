class BudgetAllocationsController < ApplicationController
  before_action :set_budget
  before_action :set_budget_allocation, only: [:edit, :update, :destroy]

  def new
    @budget_allocation = @budget.budget_allocations.build
    @budget_categories = BudgetCategory.all
  end

  def create
    @budget_allocation = @budget.budget_allocations.build(budget_allocation_params)
    @budget_categories = BudgetCategory.all
    
    if @budget_allocation.save
      redirect_to @budget, notice: 'Budget allocation was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @budget_categories = BudgetCategory.all
  end

  def update
    @budget_categories = BudgetCategory.all
    
    if @budget_allocation.update(budget_allocation_params)
      redirect_to @budget, notice: 'Budget allocation was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget_allocation.destroy
    redirect_to @budget, notice: 'Budget allocation was successfully deleted.'
  end

  private

  def set_budget
    @budget = Budget.find(params[:budget_id])
  end

  def set_budget_allocation
    @budget_allocation = @budget.budget_allocations.find(params[:id])
  end

  def budget_allocation_params
    params.require(:budget_allocation).permit(:budget_category_id, :amount, :description)
  end
end
