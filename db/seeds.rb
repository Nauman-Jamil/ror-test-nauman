# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create budget categories
puts "Creating budget categories..."

infrastructure = BudgetCategory.create!(
  name: "Infrastructure",
  description: "Roads, bridges, public buildings, and utilities",
  spending_limit_percentage: 40.0
)

social_programs = BudgetCategory.create!(
  name: "Social Programs",
  description: "Education, healthcare, and community services",
  spending_limit_percentage: 30.0
)

environment = BudgetCategory.create!(
  name: "Environment",
  description: "Parks, green spaces, and environmental protection",
  spending_limit_percentage: 20.0
)

public_safety = BudgetCategory.create!(
  name: "Public Safety",
  description: "Police, fire, and emergency services",
  spending_limit_percentage: 25.0
)

culture_recreation = BudgetCategory.create!(
  name: "Culture & Recreation",
  description: "Libraries, museums, sports facilities, and events",
  spending_limit_percentage: 15.0
)

puts "Created #{BudgetCategory.count} budget categories"

# Create sample budgets
puts "Creating sample budgets..."

city_budget = Budget.create!(
  title: "City Annual Budget 2024",
  description: "Participatory budget for city-wide improvements and services",
  total_amount: 1000000.00,
  status: "active"
)

community_budget = Budget.create!(
  title: "Community Development Fund",
  description: "Focused on neighborhood improvements and local initiatives",
  total_amount: 250000.00,
  status: "active"
)

puts "Created #{Budget.count} budgets"

# Create sample allocations
puts "Creating sample allocations..."

# City Budget Allocations (within limits)
infrastructure_allocation = BudgetAllocation.create!(
  budget: city_budget,
  budget_category: infrastructure,
  amount: 350000.00, # 35% of 1M (within 40% limit)
  description: "Road repairs and maintenance for major thoroughfares"
)

social_allocation = BudgetAllocation.create!(
  budget: city_budget,
  budget_category: social_programs,
  amount: 250000.00, # 25% of 1M (within 30% limit)
  description: "After-school programs and community health initiatives"
)

environment_allocation = BudgetAllocation.create!(
  budget: city_budget,
  budget_category: environment,
  amount: 150000.00, # 15% of 1M (within 20% limit)
  description: "Urban tree planting and park improvements"
)

safety_allocation = BudgetAllocation.create!(
  budget: city_budget,
  budget_category: public_safety,
  amount: 200000.00, # 20% of 1M (within 25% limit)
  description: "Police equipment upgrades and fire station maintenance"
)

# Community Budget Allocations (within limits)
community_social_allocation = BudgetAllocation.create!(
  budget: community_budget,
  budget_category: social_programs,
  amount: 75000.00, # 30% of 250K (within 30% limit)
  description: "Local youth programs and senior services"
)

community_culture_allocation = BudgetAllocation.create!(
  budget: community_budget,
  budget_category: culture_recreation,
  amount: 37500.00, # 15% of 250K (within 15% limit)
  description: "Community center improvements and cultural events"
)

community_env_allocation = BudgetAllocation.create!(
  budget: community_budget,
  budget_category: environment,
  amount: 25000.00, # 10% of 250K (within 20% limit)
  description: "Neighborhood park upgrades and green space development"
)

puts "Created #{BudgetAllocation.count} budget allocations"

# Create budget phases for multi-phase voting
puts "Creating budget phases..."

# City Budget Phases
proposal_phase = BudgetPhase.create!(
  budget: city_budget,
  name: "Proposal Collection",
  description: "Citizens submit and discuss budget proposals",
  status: "completed",
  start_date: Date.current - 30.days,
  end_date: Date.current - 15.days,
  voting_rules: "Open to all residents. Maximum 3 proposals per person.",
  participant_eligibility: "All registered city residents"
)

voting_phase = BudgetPhase.create!(
  budget: city_budget,
  name: "Final Voting",
  description: "Citizens vote on the top proposals from the collection phase",
  status: "active",
  start_date: Date.current - 10.days,
  end_date: Date.current + 5.days,
  voting_rules: "One vote per resident. Rank your top 5 choices.",
  participant_eligibility: "All registered city residents"
)

implementation_phase = BudgetPhase.create!(
  budget: city_budget,
  name: "Implementation Tracking",
  description: "Track progress of approved budget allocations",
  status: "draft",
  start_date: Date.current + 10.days,
  end_date: Date.current + 100.days,
  voting_rules: "Monthly progress reports and community feedback",
  participant_eligibility: "Project managers and community representatives"
)

# Community Budget Phases
community_proposal_phase = BudgetPhase.create!(
  budget: community_budget,
  name: "Neighborhood Proposals",
  description: "Local residents submit neighborhood improvement ideas",
  status: "active",
  start_date: Date.current - 5.days,
  end_date: Date.current + 10.days,
  voting_rules: "Open to neighborhood residents. Maximum 2 proposals per household.",
  participant_eligibility: "Residents of the target neighborhood"
)

puts "Created #{BudgetPhase.count} budget phases"

# Create sample votes with proper vote allocations
puts "Creating sample votes..."

# Calculate remaining budget for voting
city_remaining = city_budget.remaining_amount # Should be 50,000 (1M - 950K allocated)
community_remaining = community_budget.remaining_amount # Should be 112,500 (250K - 137.5K allocated)

# Vote 1: John Smith (City Budget - conservative allocations)
john_vote = BudgetVote.create!(
  budget_phase: voting_phase,
  voter_name: "John Smith",
  voter_email: "john.smith@example.com"
)

VoteAllocation.create!(
  budget_vote: john_vote,
  budget_category: infrastructure,
  amount: 20000.00 # Within remaining budget
)

VoteAllocation.create!(
  budget_vote: john_vote,
  budget_category: culture_recreation,
  amount: 15000.00 # Within remaining budget
)

VoteAllocation.create!(
  budget_vote: john_vote,
  budget_category: environment,
  amount: 10000.00 # Within remaining budget
)

# Vote 2: Sarah Johnson (City Budget - different priorities)
sarah_vote = BudgetVote.create!(
  budget_phase: voting_phase,
  voter_name: "Sarah Johnson",
  voter_email: "sarah.johnson@example.com"
)

VoteAllocation.create!(
  budget_vote: sarah_vote,
  budget_category: public_safety,
  amount: 25000.00 # Within remaining budget
)

VoteAllocation.create!(
  budget_vote: sarah_vote,
  budget_category: infrastructure,
  amount: 15000.00 # Within remaining budget
)

VoteAllocation.create!(
  budget_vote: sarah_vote,
  budget_category: culture_recreation,
  amount: 10000.00 # Within remaining budget
)

# Vote 3: Mike Davis (City Budget - environment focus)
mike_vote = BudgetVote.create!(
  budget_phase: voting_phase,
  voter_name: "Mike Davis",
  voter_email: "mike.davis@example.com"
)

VoteAllocation.create!(
  budget_vote: mike_vote,
  budget_category: environment,
  amount: 20000.00 # Within remaining budget
)

VoteAllocation.create!(
  budget_vote: mike_vote,
  budget_category: infrastructure,
  amount: 15000.00 # Within remaining budget
)

VoteAllocation.create!(
  budget_vote: mike_vote,
  budget_category: culture_recreation,
  amount: 15000.00 # Within remaining budget
)

# Vote 4: Lisa Chen (Community Budget)
lisa_vote = BudgetVote.create!(
  budget_phase: community_proposal_phase,
  voter_name: "Lisa Chen",
  voter_email: "lisa.chen@example.com"
)

VoteAllocation.create!(
  budget_vote: lisa_vote,
  budget_category: environment,
  amount: 20000.00 # Environment has 20% limit, only 10% used, so 25K remaining
)

VoteAllocation.create!(
  budget_vote: lisa_vote,
  budget_category: public_safety,
  amount: 50000.00 # Public Safety has 25% limit, 0% used in community budget
)

VoteAllocation.create!(
  budget_vote: lisa_vote,
  budget_category: infrastructure,
  amount: 42500.00 # Infrastructure has 40% limit, 0% used in community budget
)

puts "Created #{BudgetVote.count} budget votes with #{VoteAllocation.count} vote allocations"

# Create impact metrics
puts "Creating impact metrics..."

# Impact metrics for infrastructure allocation
ImpactMetric.create!(
  budget_allocation: infrastructure_allocation,
  metric_name: "Estimated Beneficiaries",
  metric_value: 50000,
  metric_type: "beneficiaries",
  description: "Number of residents who will benefit from improved roads"
)

ImpactMetric.create!(
  budget_allocation: infrastructure_allocation,
  metric_name: "Implementation Timeline",
  metric_value: 18,
  metric_type: "timeline",
  description: "Estimated months to complete all road improvements"
)

ImpactMetric.create!(
  budget_allocation: infrastructure_allocation,
  metric_name: "Sustainability Score",
  metric_value: 7.5,
  metric_type: "sustainability",
  description: "Long-term sustainability of road improvements"
)

# Impact metrics for social programs allocation
ImpactMetric.create!(
  budget_allocation: social_allocation,
  metric_name: "Youth Beneficiaries",
  metric_value: 15000,
  metric_type: "beneficiaries",
  description: "Number of youth who will participate in after-school programs"
)

ImpactMetric.create!(
  budget_allocation: social_allocation,
  metric_name: "Cost per Beneficiary",
  metric_value: 16.67,
  metric_type: "cost_effectiveness",
  description: "Cost per youth for after-school programs"
)

ImpactMetric.create!(
  budget_allocation: social_allocation,
  metric_name: "Accessibility Score",
  metric_value: 9.0,
  metric_type: "accessibility",
  description: "Ease of access for all community members"
)

# Impact metrics for environment allocation
ImpactMetric.create!(
  budget_allocation: environment_allocation,
  metric_name: "Trees Planted",
  metric_value: 5000,
  metric_type: "beneficiaries",
  description: "Number of trees to be planted in urban areas"
)

ImpactMetric.create!(
  budget_allocation: environment_allocation,
  metric_name: "Environmental Impact Score",
  metric_value: 8.5,
  metric_type: "sustainability",
  description: "Environmental impact score for tree planting initiative"
)

# Impact metrics for public safety allocation
ImpactMetric.create!(
  budget_allocation: safety_allocation,
  metric_name: "Safety Improvement Score",
  metric_value: 8.8,
  metric_type: "accessibility",
  description: "Community safety improvement rating"
)

ImpactMetric.create!(
  budget_allocation: safety_allocation,
  metric_name: "Response Time Reduction",
  metric_value: 2.5,
  metric_type: "timeline",
  description: "Minutes reduced in emergency response time"
)

# Impact metrics for community allocations
ImpactMetric.create!(
  budget_allocation: community_social_allocation,
  metric_name: "Local Beneficiaries",
  metric_value: 2500,
  metric_type: "beneficiaries",
  description: "Number of local residents who will benefit from youth and senior programs"
)

ImpactMetric.create!(
  budget_allocation: community_culture_allocation,
  metric_name: "Cultural Impact Score",
  metric_value: 8.0,
  metric_type: "accessibility",
  description: "Cultural accessibility and community engagement score"
)

ImpactMetric.create!(
  budget_allocation: community_env_allocation,
  metric_name: "Green Space Impact",
  metric_value: 7.5,
  metric_type: "sustainability",
  description: "Environmental impact of neighborhood green space improvements"
)

puts "Created #{ImpactMetric.count} impact metrics"

puts "Seed data created successfully!"
puts "You can now run the application and explore the complete participatory budgeting system."
puts ""
puts "Features available:"
puts "- Budget Category Limits & Spending Controls"
puts "- Multi-Phase Budget Voting"
puts "- Budget Impact Assessment Integration"
puts ""
puts "Visit http://localhost:3000 to explore the system"
