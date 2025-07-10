class BudgetCategory < ApplicationRecord
  has_many :budget_allocations, dependent: :destroy
  has_many :budgets, through: :budget_allocations
  has_many :vote_allocations, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :spending_limit_percentage, 
            presence: true, 
            numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  
  def utilization_rate(budget)
    return 0 if budget.total_amount.zero?
    
    total_allocated = budget_allocations.where(budget: budget).sum(:amount)
    (total_allocated / budget.total_amount * 100).round(2)
  end
  
  def remaining_budget(budget)
    total_allocated = budget_allocations.where(budget: budget).sum(:amount)
    max_allowed = budget.total_amount * (spending_limit_percentage / 100.0)
    [max_allowed - total_allocated, 0].max
  end
  
  def over_limit?(budget)
    utilization_rate(budget) > spending_limit_percentage
  end
  
  # Methods for vote allocation views
  def current_allocation
    budget_allocations.sum(:amount)
  end
  
  def limit_amount
    # This would need to be calculated based on the current budget context
    # For now, we'll use a default calculation
    Budget.first&.total_amount.to_f * (spending_limit_percentage / 100.0)
  end
  
  def available_amount
    [limit_amount - current_allocation, 0].max
  end
  
  def usage_percentage
    return 0 if limit_amount.zero?
    (current_allocation / limit_amount * 100).round(2)
  end
end
