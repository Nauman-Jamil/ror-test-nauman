class VoteAllocation < ApplicationRecord
  belongs_to :budget_vote
  belongs_to :budget_category
  
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :amount_within_budget_and_category_limits
  
  def amount_within_budget_and_category_limits
    return if amount.blank? || budget_category.blank?
    
    budget = budget_vote.budget_phase.budget
    
    # Check if this would exceed the category limit for this specific budget
    current_allocated = budget.budget_allocations.where(budget_category: budget_category).sum(:amount)
    max_allowed = budget.total_amount * (budget_category.spending_limit_percentage / 100.0)
    remaining_in_category = [max_allowed - current_allocated, 0].max
    
    if amount > remaining_in_category
      errors.add(:amount, "exceeds available amount ($#{remaining_in_category.round(2)}) for #{budget_category.name}")
    end
  end
end
