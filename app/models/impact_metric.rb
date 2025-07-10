class ImpactMetric < ApplicationRecord
  belongs_to :budget_allocation
  
  validates :metric_name, presence: true
  validates :description, presence: true
  validates :metric_value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :metric_type, presence: true, inclusion: { in: %w[beneficiaries timeline sustainability cost_effectiveness accessibility] }
  
  scope :by_type, ->(type) { where(metric_type: type) }
  scope :high_value, -> { where('metric_value >= ?', 8.0) }
  scope :medium_value, -> { where('metric_value >= ? AND metric_value < ?', 5.0, 8.0) }
  scope :low_value, -> { where('metric_value < ?', 5.0) }
  scope :recent, -> { order(created_at: :desc) }
  
  def value_level
    case metric_value
    when 0..4 then 'low'
    when 5..7 then 'medium'
    when 8..10 then 'high'
    else 'unknown'
    end
  end
  
  def value_color
    case value_level
    when 'high' then 'text-green-600'
    when 'medium' then 'text-yellow-600'
    when 'low' then 'text-red-600'
    else 'text-gray-600'
    end
  end
  
  def formatted_value
    case metric_type
    when 'beneficiaries'
      "#{metric_value.to_i} people"
    when 'timeline'
      "#{metric_value.to_i} months"
    when 'sustainability', 'accessibility'
      "#{metric_value.round(1)}/10"
    when 'cost_effectiveness'
      "$#{metric_value.round(2)}/person"
    else
      metric_value.to_s
    end
  end
  
  def self.average_by_type(type)
    where(metric_type: type).average(:metric_value) || 0
  end
  
  def self.total_by_type(type)
    where(metric_type: type).sum(:metric_value) || 0
  end
  
  def self.average_value
    average(:metric_value) || 0
  end
end
