class BudgetAllocation < ApplicationRecord
  belongs_to :budget
  belongs_to :budget_category
  has_many :impact_metrics, dependent: :destroy
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validate :budget_has_sufficient_funds
  validate :category_limit_not_exceeded
  
  scope :with_impact_metrics, -> { joins(:impact_metrics) }
  scope :high_impact, -> { joins(:impact_metrics).where('impact_metrics.metric_value >= ?', 8.0) }
  scope :by_impact_score, -> { joins(:impact_metrics).order('AVG(impact_metrics.metric_value) DESC') }
  
  def impact_score
    return 0 unless has_impact_metrics?
    
    # Calculate average of all metric values for this allocation
    impact_metrics.average(:metric_value) || 0
  end
  
  def has_impact_metrics?
    impact_metrics.any?
  end
  
  def impact_summary
    return "No impact data" unless has_impact_metrics?
    
    metrics = impact_metrics.group(:metric_type).average(:metric_value)
    summary = []
    
    metrics.each do |type, value|
      case type
      when 'beneficiaries'
        summary << "#{value.to_i} beneficiaries"
      when 'sustainability'
        summary << "#{value.round(1)}/10 sustainability"
      when 'cost_effectiveness'
        summary << "$#{value.round(2)}/person"
      end
    end
    
    summary.join(", ")
  end
  
  private
  
  def budget_has_sufficient_funds
    return unless budget && amount
    
    if budget.remaining_amount < amount
      errors.add(:amount, "exceeds remaining budget amount of #{budget.remaining_amount}")
    end
  end
  
  def category_limit_not_exceeded
    return unless budget && budget_category && amount
    
    unless budget.can_allocate_to_category?(budget_category, amount)
      max_allowed = budget.total_amount * (budget_category.spending_limit_percentage / 100.0)
      current_total = budget.budget_allocations.where(budget_category: budget_category).sum(:amount)
      remaining_in_category = max_allowed - current_total
      
      errors.add(:amount, "would exceed category limit. Maximum allowed: #{remaining_in_category}")
    end
  end
end
