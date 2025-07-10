class BudgetPhase < ApplicationRecord
  belongs_to :budget
  has_many :budget_votes, dependent: :destroy
  
  validates :name, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft active completed] }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  
  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
  scope :draft, -> { where(status: 'draft') }
  scope :upcoming, -> { where('start_date > ?', Date.current) }
  scope :current, -> { where('start_date <= ? AND end_date >= ?', Date.current, Date.current) }
  
  def duration_days
    (end_date - start_date).to_i
  end
  
  def days_remaining
    return 0 if completed?
    [0, (end_date - Date.current).to_i].max
  end
  
  def progress_percentage
    return 100 if completed?
    return 0 if draft?
    
    total_days = duration_days
    elapsed_days = [(Date.current - start_date).to_i, total_days].min
    (elapsed_days.to_f / total_days * 100).round(2)
  end
  
  def can_vote?
    active? && Date.current.between?(start_date, end_date)
  end
  
  def completed?
    status == 'completed'
  end
  
  def active?
    status == 'active'
  end
  
  def draft?
    status == 'draft'
  end
  
  def total_votes
    budget_votes.count
  end
  
  def transition_to_next_phase
    case status
    when 'draft'
      update(status: 'active') if start_date <= Date.current
    when 'active'
      update(status: 'completed') if end_date < Date.current
    end
  end
  
  def auto_transition
    transition_to_next_phase
  end
  
  private
  
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
