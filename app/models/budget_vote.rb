class BudgetVote < ApplicationRecord
  belongs_to :budget_phase
  has_many :vote_allocations, dependent: :destroy
  accepts_nested_attributes_for :vote_allocations, allow_destroy: true
  
  validates :voter_name, presence: true
  validates :voter_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :total_amount_within_budget_limit
  validate :category_limits_not_exceeded
  
  scope :recent, -> { order(created_at: :desc) }
  
  def vote_summary
    return "No allocations" if vote_allocations.empty?
    
    vote_allocations.map do |allocation|
      "#{allocation.budget_category.name}: $#{allocation.amount}"
    end.join(", ")
  end
  
  def total_amount
    vote_allocations.sum(:amount)
  end
  
  def allocation_by_category(category)
    vote_allocations.find_by(budget_category: category)
  end
  
  def has_allocation_for?(category)
    vote_allocations.exists?(budget_category: category)
  end
  
  def self.vote_statistics(phase)
    votes = where(budget_phase: phase)
    total_votes = votes.count
    
    return {
      total_votes: 0,
      unique_voters: 0,
      average_amount: 0,
      participation_rate: 0
    } if total_votes == 0
    
    {
      total_votes: total_votes,
      unique_voters: votes.distinct.count(:voter_email),
      average_amount: votes.sum(&:total_amount) / total_votes.to_f,
      participation_rate: (total_votes.to_f / 100) * 100 # Assuming 100 is max participants
    }
  end
  
  private
  
  def total_amount_within_budget_limit
    return if vote_allocations.empty?
    
    budget = budget_phase.budget
    remaining_amount = budget.remaining_amount
    
    if total_amount > remaining_amount
      errors.add(:base, "Total vote amount ($#{total_amount}) exceeds remaining budget ($#{remaining_amount})")
    end
  end
  
  def category_limits_not_exceeded
    return if vote_allocations.empty?
    
    budget = budget_phase.budget
    vote_allocations.each do |allocation|
      category = allocation.budget_category
      current_allocated = budget.budget_allocations.where(budget_category: category).sum(:amount)
      proposed_amount = allocation.amount || 0
      
      # Calculate what the total would be if this vote is added
      total_for_category = current_allocated + proposed_amount
      max_allowed = budget.total_amount * (category.spending_limit_percentage / 100.0)
      
      if total_for_category > max_allowed
        errors.add(:base, "#{category.name} allocation would exceed the #{category.spending_limit_percentage}% limit (max: $#{max_allowed.round(2)})")
      end
    end
  end
end
