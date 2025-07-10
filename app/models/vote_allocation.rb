class VoteAllocation < ApplicationRecord
  belongs_to :budget_vote
  belongs_to :budget_category
  
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :amount_within_category_limit
  
  def amount_within_category_limit
    return if amount.blank? || budget_category.blank?
    
    available_amount = budget_category.available_amount
    if amount > available_amount
      errors.add(:amount, "exceeds available amount ($#{available_amount}) for #{budget_category.name}")
    end
  end
end
