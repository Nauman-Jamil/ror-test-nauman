class BudgetCategoriesController < ApplicationController
  before_action :set_budget_category, only: [:show, :edit, :update, :destroy]

  def index
    @budget_categories = BudgetCategory.all.order(:name)
  end

  def show
    @budgets = Budget.active
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
end
