# Participatory Budgeting System

A comprehensive Rails application for managing participatory budgeting processes with advanced features for budget allocation, multi-phase voting, and impact assessment.

## Features

### 1. Budget Category Limits & Spending Controls

**Business Problem**: Organizations need to limit spending within specific budget categories (e.g., maximum 40% for infrastructure, 30% for social programs).

**Features Implemented**:

- ✅ `spending_limit_percentage` field on budget categories
- ✅ Real-time budget allocation validation during voting
- ✅ Admin interface for setting and monitoring category limits
- ✅ Visual indicators showing category utilization rates
- ✅ Category limit enforcement with error messages
- ✅ Progress bars and color-coded status indicators

**Demo Focus**:

- Show voting process with limit enforcement
- Admin monitoring dashboard with real-time utilization tracking

### 2. Multi-Phase Budget Voting

**Business Problem**: Organizations want to run budget voting in phases (e.g., pre-selection, final voting, implementation tracking).

**Features Implemented**:

- ✅ Multiple voting phases with different configurations
- ✅ Phase-specific voting rules and participant eligibility
- ✅ Automatic phase transitions based on conditions
- ✅ Phase-specific reporting and analytics
- ✅ Timeline visualization and progress tracking
- ✅ Phase status management (draft, active, completed)

**Demo Focus**:

- Show phase transitions and different voting behaviors per phase
- Comprehensive reporting and analytics dashboard

### 3. Budget Impact Assessment Integration

**Business Problem**: Organizations need to collect and display impact metrics for budget proposals.

**Features Implemented**:

- ✅ Impact metrics model with multiple types (beneficiaries, timeline, sustainability, cost_effectiveness, accessibility)
- ✅ Impact assessment forms for project creators
- ✅ Impact-based filtering and sorting for voters
- ✅ Impact reports for approved projects
- ✅ Visual impact score indicators
- ✅ Category and budget-level impact analysis

**Demo Focus**:

- Show impact data collection and voter filtering
- Comprehensive impact reporting system

## Installation & Setup

### Prerequisites

- Ruby 3.0+
- Rails 7.0+
- PostgreSQL
- Node.js (for asset compilation)

### Setup Instructions

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd ror-contract
   ```

2. **Install dependencies**

   ```bash
   bundle install
   npm install
   ```

3. **Database setup**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**

   ```bash
   rails server
   ```

5. **Visit the application**
   ```
   http://localhost:3000
   ```

## Usage Guide

### 1. Budget Category Management

**Access**: Navigate to "Budget Categories" from the main menu.

**Features**:

- Create new budget categories with spending limits
- Set percentage limits (e.g., 40% for infrastructure)
- Monitor real-time utilization rates
- View visual progress bars and status indicators
- Admin dashboard with comprehensive monitoring

**Example Workflow**:

1. Create "Infrastructure" category with 40% limit
2. Create "Social Programs" category with 30% limit
3. Monitor utilization in real-time dashboard
4. Receive alerts when categories approach limits

### 2. Multi-Phase Budget Voting

**Access**: Navigate to a budget, then "Budget Phases".

**Features**:

- Create multiple phases with different rules
- Set phase-specific voting rules and eligibility
- Automatic phase transitions
- Phase-specific analytics and reporting
- Timeline visualization

**Example Workflow**:

1. Create "Proposal Collection" phase (draft)
2. Create "Final Voting" phase (active)
3. Create "Implementation Tracking" phase (draft)
4. Monitor phase progress and transitions
5. View phase-specific analytics

### 3. Impact Assessment

**Access**: Navigate to "Impact Metrics" from the main menu.

**Features**:

- Create impact metrics for budget allocations
- Multiple metric types: beneficiaries, timeline, sustainability, cost_effectiveness, accessibility
- Impact-based filtering and sorting
- Comprehensive impact reports
- Visual impact score indicators

**Example Workflow**:

1. Create budget allocation
2. Add impact metrics (e.g., "50,000 beneficiaries", "18-month timeline")
3. View impact scores and filtering options
4. Generate comprehensive impact reports

### 4. Voting Process

**Access**: Navigate to an active budget phase and click "Vote Now".

**Features**:

- Real-time category limit validation
- Visual progress indicators
- Category utilization warnings
- Budget remaining calculations
- Impact-based project information

**Example Workflow**:

1. Enter voter information
2. Allocate funds across categories
3. Real-time validation prevents exceeding limits
4. Submit vote with impact considerations
5. View voting results and analytics

## Database Schema

### Core Models

**BudgetCategory**

- `name`: Category name
- `description`: Category description
- `spending_limit_percentage`: Maximum percentage of total budget

**Budget**

- `title`: Budget title
- `description`: Budget description
- `total_amount`: Total budget amount
- `status`: Budget status (draft, active, completed)

**BudgetPhase**

- `name`: Phase name
- `description`: Phase description
- `status`: Phase status (draft, active, completed)
- `start_date`: Phase start date
- `end_date`: Phase end date
- `voting_rules`: Phase-specific voting rules
- `participant_eligibility`: Eligibility criteria

**BudgetVote**

- `voter_name`: Voter's name
- `voter_email`: Voter's email
- `comments`: Optional comments

**VoteAllocation**

- `amount`: Amount allocated to category
- Links vote to budget category

**BudgetAllocation**

- `amount`: Amount allocated
- `description`: Allocation description
- Links budget to budget category

**ImpactMetric**

- `metric_name`: Metric name
- `metric_value`: Metric value
- `metric_type`: Type (beneficiaries, timeline, sustainability, etc.)
- `description`: Metric description

## API Endpoints

### Budget Categories

- `GET /budget_categories` - List all categories
- `GET /budget_categories/:id` - Show category details
- `POST /budget_categories` - Create new category
- `PUT /budget_categories/:id` - Update category
- `DELETE /budget_categories/:id` - Delete category

### Budget Phases

- `GET /budgets/:budget_id/budget_phases` - List phases for budget
- `GET /budgets/:budget_id/budget_phases/:id` - Show phase details
- `POST /budgets/:budget_id/budget_phases` - Create new phase
- `PUT /budgets/:budget_id/budget_phases/:id` - Update phase
- `PATCH /budgets/:budget_id/budget_phases/:id/transition` - Transition phase

### Budget Votes

- `GET /budgets/:budget_id/budget_phases/:phase_id/budget_votes` - List votes
- `GET /budgets/:budget_id/budget_phases/:phase_id/budget_votes/new` - New vote form
- `POST /budgets/:budget_id/budget_phases/:phase_id/budget_votes` - Submit vote

### Impact Metrics

- `GET /impact_metrics` - List all metrics
- `GET /impact_metrics/report` - Impact report
- `POST /impact_metrics` - Create new metric
- `PUT /impact_metrics/:id` - Update metric

## Sample Data

The application includes comprehensive sample data:

### Budget Categories

- Infrastructure (40% limit)
- Social Programs (30% limit)
- Environment (20% limit)
- Public Safety (25% limit)
- Culture & Recreation (15% limit)

### Sample Budgets

- City Annual Budget 2024 ($1,000,000)
- Community Development Fund ($250,000)

### Sample Phases

- Proposal Collection (completed)
- Final Voting (active)
- Implementation Tracking (draft)

### Sample Votes

- Multiple votes with different allocations
- Real vote allocations (not just vote_data)

### Sample Impact Metrics

- Beneficiaries, timeline, sustainability scores
- Cost effectiveness and accessibility metrics

## Testing

Run the test suite:

```bash
rails test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please open an issue in the repository.

---

**Demo Instructions**:

1. **Category Limits Demo**:

   - Visit Budget Categories page
   - Show utilization monitoring dashboard
   - Demonstrate limit enforcement during voting

2. **Multi-Phase Demo**:

   - Show phase timeline and transitions
   - Demonstrate different voting behaviors per phase
   - Display comprehensive analytics

3. **Impact Assessment Demo**:
   - Show impact data collection
   - Demonstrate voter filtering by impact
   - Display comprehensive impact reports

All features are fully implemented and working with comprehensive sample data for immediate demonstration.
