# Participatory Budgeting System - Complete Implementation

A comprehensive Rails-based participatory budgeting system that implements **all three features** from the ROR Contract Hiring Round 2 Assignment 1: Participatory Budgeting Enhancements.

## 🎯 All Features Implemented

### ✅ 1. Budget Category Limits & Spending Controls

- **Business Problem**: Organizations need to limit spending within specific budget categories (e.g., maximum 40% for infrastructure, 30% for social programs)
- **Implementation**:
  - ✅ Added `spending_limit_percentage` field to budget categories
  - ✅ Implemented real-time budget allocation validation during voting
  - ✅ Created admin interface for setting and monitoring category limits
  - ✅ Added visual indicators showing category utilization rates
- **Demo Focus**: Show voting process with limit enforcement, admin monitoring dashboard

### ✅ 2. Multi-Phase Budget Voting

- **Business Problem**: Organizations want to run budget voting in phases (e.g., pre-selection, final voting, implementation tracking)
- **Implementation**:
  - ✅ Extended budget component to support multiple voting phases
  - ✅ Added phase-specific configurations (voting rules, participant eligibility)
  - ✅ Implemented automatic phase transitions based on conditions
  - ✅ Created phase-specific reporting and analytics
- **Demo Focus**: Show phase transitions, different voting behaviors per phase, reporting

### ✅ 3. Budget Impact Assessment Integration

- **Business Problem**: Organizations need to collect and display impact metrics for budget proposals
- **Implementation**:
  - ✅ Created impact metrics model (estimated beneficiaries, timeline, sustainability score)
  - ✅ Built impact assessment form for project creators
  - ✅ Added impact-based filtering and sorting for voters
  - ✅ Generated impact reports for approved projects
- **Demo Focus**: Show impact data collection, voter filtering, impact reporting

## 🚀 Quick Start

### Prerequisites

- Ruby 3.4.4 or higher
- PostgreSQL
- Rails 8.0.2

### Installation

1. **Clone and setup the application:**

   ```bash
   git clone <repository-url>
   cd ror-contract
   bundle install
   ```

2. **Setup the database:**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Start the server:**

   ```bash
   rails server
   ```

4. **Visit the application:**
   Open http://localhost:3000 in your browser

## 📊 Demo Data

The system comes pre-loaded with comprehensive sample data:

### Budget Categories with Limits

- **Infrastructure** (40% limit): Roads, bridges, public buildings
- **Social Programs** (30% limit): Education, healthcare, community services
- **Environment** (20% limit): Parks, green spaces, environmental protection
- **Public Safety** (25% limit): Police, fire, emergency services
- **Culture & Recreation** (15% limit): Libraries, museums, sports facilities

### Sample Budgets with Phases

- **City Annual Budget 2024** ($1,000,000): Multi-phase participatory budgeting
- **Community Development Fund** ($250,000): Neighborhood-level initiatives

### Multi-Phase Voting Examples

- **Proposal Collection Phase**: Citizens submit budget proposals
- **Final Voting Phase**: Active voting with real-time validation
- **Implementation Tracking Phase**: Progress monitoring and feedback

### Impact Assessment Data

- **Beneficiaries**: Number of people impacted
- **Timeline**: Implementation duration in months
- **Sustainability**: Long-term impact scores (1-10)
- **Cost Effectiveness**: Cost per beneficiary
- **Accessibility**: Ease of access scores (1-10)

## 🎮 How to Use

### 1. Budget Category Limits

- Navigate to "Categories" to see spending limits
- Create allocations and watch real-time validation
- See visual indicators when categories exceed limits
- Monitor utilization rates with progress bars

### 2. Multi-Phase Voting

- Go to any budget and click "Phases"
- Create different voting phases with specific rules
- Set participant eligibility and voting rules
- Watch automatic phase transitions based on dates
- View voting statistics and participation rates

### 3. Impact Assessment

- From budget allocations, click "Impact"
- Add impact metrics for beneficiaries, timeline, sustainability
- View impact scores and filtering options
- Generate impact reports for approved projects

### 4. Complete Workflow Demo

1. **Create Budget**: Set total amount and categories
2. **Set Category Limits**: Define spending percentages
3. **Create Phases**: Set up multi-phase voting process
4. **Add Allocations**: Create budget allocations with validation
5. **Assess Impact**: Add impact metrics for each allocation
6. **Vote**: Participate in voting phases with real-time feedback
7. **Monitor**: Track progress and utilization rates

## 🔧 Technical Implementation

### Models & Relationships

- **Budget**: Manages budget metadata and total amounts
- **BudgetCategory**: Defines categories with spending limit percentages
- **BudgetAllocation**: Links budgets to categories with amounts
- **BudgetPhase**: Manages multi-phase voting workflows
- **BudgetVote**: Tracks votes in different phases
- **ImpactMetric**: Stores impact assessment data

### Key Features

```ruby
# Category limit validation
def category_limit_not_exceeded
  unless budget.can_allocate_to_category?(budget_category, amount)
    errors.add(:amount, "would exceed category limit")
  end
end

# Phase transition logic
def auto_transition
  case status
  when 'draft'
    update(status: 'active') if start_date <= Date.current
  when 'active'
    update(status: 'completed') if end_date < Date.current
  end
end

# Impact score calculation
def impact_score
  metrics = impact_metrics
  return 0 if metrics.empty?
  metrics.sum(:metric_value) / metrics.count
end
```

### Visual Indicators

- Progress bars for budget utilization
- Color-coded category limits (red for over-limit)
- Phase status indicators (draft/active/completed)
- Impact score badges (high/medium/low)
- Real-time validation feedback

## 🎯 Assignment Requirements Met

### ✅ Business Problems Solved

1. **Category Limits**: Organizations can now limit spending within specific budget categories
2. **Multi-Phase Voting**: Organizations can run budget voting in phases with different rules
3. **Impact Assessment**: Organizations can collect and display impact metrics for proposals

### ✅ Technical Implementation

1. **Category Limits**: Real-time validation, visual indicators, admin controls
2. **Multi-Phase Voting**: Phase management, automatic transitions, voting analytics
3. **Impact Assessment**: Impact metrics model, assessment forms, filtering and reporting

### ✅ Demo Features

1. **Voting Process**: Multi-phase voting with limit enforcement
2. **Admin Monitoring**: Complete dashboard for all features
3. **Visual Feedback**: Progress bars, color coding, real-time validation
4. **Impact Reporting**: Comprehensive impact assessment and filtering

## 🛠 Development

### Running Tests

```bash
rails test
```

### Code Quality

```bash
rubocop
```

### Database Reset

```bash
rails db:reset  # Drops, recreates, and seeds the database
```

## 📱 User Interface

The application features a modern, responsive interface built with:

- **Tailwind CSS** for styling
- **Rails 8** with Hotwire for dynamic interactions
- **PostgreSQL** for data persistence
- **RESTful routing** for clean URLs
- **Real-time validation** and feedback

## 🎥 Demo Video Features

The system demonstrates all three assignment features:

### 1. Budget Category Limits & Spending Controls

- Setting up budget categories with percentage limits
- Creating allocations with real-time validation
- Visual indicators for category utilization
- Error messages when limits are exceeded

### 2. Multi-Phase Budget Voting

- Creating different voting phases with specific rules
- Automatic phase transitions based on dates
- Voting interface with real-time validation
- Phase-specific reporting and analytics

### 3. Budget Impact Assessment Integration

- Adding impact metrics for budget allocations
- Impact-based filtering and sorting
- Impact score calculations and visual indicators
- Comprehensive impact reporting

## 📈 System Architecture

### Core Features

- **Budget Management**: Complete CRUD with category limits
- **Phase Management**: Multi-phase voting workflows
- **Impact Assessment**: Comprehensive impact metrics
- **Real-time Validation**: Immediate feedback on all actions
- **Visual Analytics**: Progress bars, charts, and indicators

### Data Flow

1. **Budget Creation** → Set categories and limits
2. **Phase Setup** → Configure voting phases
3. **Allocation Creation** → Add allocations with validation
4. **Impact Assessment** → Add impact metrics
5. **Voting Process** → Multi-phase voting with real-time feedback
6. **Monitoring** → Track progress and utilization

## 🎉 Ready for Submission

- ✅ **Complete Implementation**: All three assignment features implemented
- ✅ **Public GitHub Repository**: Well-documented and structured code
- ✅ **Demo Video Ready**: System demonstrates all required features
- ✅ **Comprehensive README**: Complete setup and feature documentation
- ✅ **Modern UI/UX**: Professional, responsive interface
- ✅ **Real-world Data**: Realistic sample data for demonstration

---

**Built for ROR Contract Hiring Round 2 - Assignment 1: Participatory Budgeting Enhancements**

_All three features successfully implemented and ready for demonstration!_ 🚀
