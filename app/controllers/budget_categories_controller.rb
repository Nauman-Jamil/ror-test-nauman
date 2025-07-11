class BudgetCategoriesController < ApplicationController
  before_action :set_budget_category, only: [:show, :edit, :update, :destroy]

  def index
    @budget_categories = BudgetCategory.all.order(:name)
    @budgets = Budget.active
    @category_utilization = calculate_category_utilization
  end

  def show
    @budgets = Budget.active
    @utilization_data = calculate_utilization_data
    @recent_allocations = @budget_category.budget_allocations.includes(:budget).order(created_at: :desc).limit(10)
  end

  def new
    @budget_category = BudgetCategory.new
  end

  def create
    @budget_category = BudgetCategory.new(budget_category_params)
    
    if @budget_category.save
      redirect_to @budget_category, notice: 'Budget category was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @budget_category.update(budget_category_params)
      redirect_to @budget_category, notice: 'Budget category was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget_category.destroy
    redirect_to budget_categories_url, notice: 'Budget category was successfully deleted.'
  end

  private

  def set_budget_category
    @budget_category = BudgetCategory.find(params[:id])
  end

  def budget_category_params
    params.require(:budget_category).permit(:name, :description, :spending_limit_percentage)
  end
  
  def calculate_category_utilization
    utilization = {}
    Budget.active.each do |budget|
      budget.budget_categories.each do |category|
        utilization[category.id] ||= {}
        utilization[category.id][budget.id] = {
          utilization_rate: category.utilization_rate(budget),
          remaining_budget: category.remaining_budget(budget),
          over_limit: category.over_limit?(budget)
        }
      end
    end
    utilization
  end
  
  def calculate_utilization_data
    data = {}
    Budget.active.each do |budget|
      data[budget.id] = {
        budget: budget,
        utilization_rate: @budget_category.utilization_rate(budget),
        remaining_budget: @budget_category.remaining_budget(budget),
        over_limit: @budget_category.over_limit?(budget),
        total_allocated: @budget_category.budget_allocations.where(budget: budget).sum(:amount),
        max_allowed: budget.total_amount * (@budget_category.spending_limit_percentage / 100.0)
      }
    end
    data
  end
end
