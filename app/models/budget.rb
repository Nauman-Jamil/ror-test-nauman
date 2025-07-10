class Budget < ApplicationRecord
  has_many :budget_allocations, dependent: :destroy
  has_many :budget_categories, through: :budget_allocations
  has_many :budget_phases, dependent: :destroy
  has_many :budget_votes, through: :budget_phases
  
  validates :title, presence: true
  validates :description, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[draft active completed] }
  
  scope :active, -> { where(status: 'active') }
  scope :draft, -> { where(status: 'draft') }
  scope :completed, -> { where(status: 'completed') }
  
  def total_allocated
    budget_allocations.sum(:amount)
  end
  
  def remaining_amount
    total_amount - total_allocated
  end
  
  def utilization_percentage
    return 0 if total_amount.zero?
    (total_allocated / total_amount * 100).round(2)
  end
  
  def category_utilization(category)
    category.utilization_rate(self)
  end
  
  def can_allocate_to_category?(category, amount)
    return false if amount <= 0
    return false if remaining_amount < amount
    
    # Check if allocation would exceed category limit
    current_category_total = budget_allocations.where(budget_category: category).sum(:amount)
    new_total = current_category_total + amount
    max_allowed = total_amount * (category.spending_limit_percentage / 100.0)
    
    new_total <= max_allowed
  end
  
  def current_phase
    budget_phases.current.first
  end
  
  def active_phases
    budget_phases.active
  end
  
  def completed_phases
    budget_phases.completed
  end
  
  def total_votes_across_phases
    budget_votes.count
  end
  
  def average_impact_score
    allocations_with_metrics = budget_allocations.joins(:impact_metrics)
    return 0 if allocations_with_metrics.empty?
    
    total_score = allocations_with_metrics.sum do |allocation|
      allocation.impact_score
    end
    
    total_score / allocations_with_metrics.count
  end
end
