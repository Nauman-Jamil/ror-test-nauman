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

# Create sample votes
puts "Creating sample votes..."

# Votes for the active voting phase
BudgetVote.create!(
  budget_phase: voting_phase,
  voter_name: "John Smith",
  voter_email: "john.smith@example.com",
  vote_data: {
    "allocations" => [
      { "category" => "Infrastructure", "amount" => 300000, "description" => "Road improvements" },
      { "category" => "Social Programs", "amount" => 250000, "description" => "Youth programs" },
      { "category" => "Environment", "amount" => 150000, "description" => "Park improvements" }
    ]
  }
)

BudgetVote.create!(
  budget_phase: voting_phase,
  voter_name: "Sarah Johnson",
  voter_email: "sarah.johnson@example.com",
  vote_data: {
    "allocations" => [
      { "category" => "Social Programs", "amount" => 300000, "description" => "Healthcare initiatives" },
      { "category" => "Infrastructure", "amount" => 250000, "description" => "Public transportation" },
      { "category" => "Public Safety", "amount" => 200000, "description" => "Police training" }
    ]
  }
)

BudgetVote.create!(
  budget_phase: voting_phase,
  voter_name: "Mike Davis",
  voter_email: "mike.davis@example.com",
  vote_data: {
    "allocations" => [
      { "category" => "Environment", "amount" => 200000, "description" => "Green energy projects" },
      { "category" => "Infrastructure", "amount" => 300000, "description" => "Bridge repairs" },
      { "category" => "Culture & Recreation", "amount" => 100000, "description" => "Library improvements" }
    ]
  }
)

puts "Created #{BudgetVote.count} budget votes"

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

puts "Created #{ImpactMetric.count} impact metrics"

puts "Seed data created successfully!"
puts "You can now run the application and explore the complete participatory budgeting system."
