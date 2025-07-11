class ImpactMetricsController < ApplicationController
  before_action :set_budget, only: [:new, :create, :edit, :update, :destroy], if: -> { params[:budget_id].present? }
  before_action :set_budget_allocation, only: [:new, :create, :edit, :update, :destroy], if: -> { params[:budget_allocation_id].present? }
  before_action :set_impact_metric, only: [:show, :edit, :update, :destroy]

  def index
    @impact_metrics = ImpactMetric.includes(:budget_allocation).all
    
    # Apply filters
    @impact_metrics = @impact_metrics.by_type(params[:metric_type]) if params[:metric_type].present?
    @impact_metrics = @impact_metrics.where('metric_value >= ?', params[:min_value]) if params[:min_value].present?
    @impact_metrics = @impact_metrics.where('metric_value <= ?', params[:max_value]) if params[:max_value].present?
    
    # Apply sorting
    case params[:sort]
    when 'value_high'
      @impact_metrics = @impact_metrics.order(metric_value: :desc)
    when 'value_low'
      @impact_metrics = @impact_metrics.order(metric_value: :asc)
    when 'recent'
      @impact_metrics = @impact_metrics.recent
    when 'type'
      @impact_metrics = @impact_metrics.order(:metric_type, :metric_value)
    else
      @impact_metrics = @impact_metrics.recent
    end
    
    @total_metrics = @impact_metrics.count
    @average_value = @impact_metrics.average(:metric_value) || 0
    @type_impact = calculate_type_impact
    @value_distribution = calculate_value_distribution
    @impact_summary = calculate_impact_summary
  end

  def show
    @related_metrics = ImpactMetric.where.not(id: @impact_metric.id)
                                  .where(metric_type: @impact_metric.metric_type)
                                  .limit(6)
    @impact_comparison = calculate_impact_comparison
  end

  def new
    if params[:budget_allocation_id].present?
      @impact_metric = @budget_allocation.impact_metrics.build
    else
      @impact_metric = ImpactMetric.new
    end
  end

  def create
    if params[:budget_allocation_id].present?
      @impact_metric = @budget_allocation.impact_metrics.build(impact_metric_params)
      
      if @impact_metric.save
        redirect_to budget_path(@budget), notice: 'Impact metric was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    else
      @impact_metric = ImpactMetric.new(impact_metric_params)
      
      if @impact_metric.save
        redirect_to impact_metric_path(@impact_metric), notice: 'Impact metric was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def update
    if @impact_metric.update(impact_metric_params)
      if params[:budget_id].present?
        redirect_to budget_path(@budget), notice: 'Impact metric was successfully updated.'
      else
        redirect_to impact_metric_path(@impact_metric), notice: 'Impact metric was successfully updated.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @impact_metric.destroy
    if params[:budget_id].present?
      redirect_to budget_path(@budget), notice: 'Impact metric was successfully deleted.'
    else
      redirect_to impact_metrics_path, notice: 'Impact metric was successfully deleted.'
    end
  end

  def report
    @impact_metrics = ImpactMetric.includes(:budget_allocation).all
    @impact_report = generate_impact_report
    @category_impact = calculate_category_impact
    @budget_impact = calculate_budget_impact
  end

  private

  def set_budget
    @budget = Budget.find(params[:budget_id]) if params[:budget_id].present?
  end

  def set_budget_allocation
    @budget_allocation = @budget.budget_allocations.find(params[:budget_allocation_id]) if params[:budget_allocation_id].present?
  end

  def set_impact_metric
    @impact_metric = ImpactMetric.find(params[:id])
  end

  def impact_metric_params
    params.require(:impact_metric).permit(
      :metric_name,
      :metric_value,
      :metric_type,
      :description
    )
  end

  def calculate_type_impact
    ImpactMetric.group(:metric_type)
                .select(
                  'metric_type',
                  'COUNT(*) as count',
                  'AVG(metric_value) as avg_value',
                  'MAX(metric_value) as max_value',
                  'MIN(metric_value) as min_value'
                )
                .each_with_object({}) do |result, hash|
      hash[result.metric_type] = {
        count: result.count,
        avg_value: result.avg_value || 0,
        max_value: result.max_value || 0,
        min_value: result.min_value || 0
      }
    end
  end

  def calculate_value_distribution
    ImpactMetric.group(:metric_value)
                .count
                .sort.to_h
  end

  def calculate_impact_summary
    {
      total_metrics: ImpactMetric.count,
      average_value: ImpactMetric.average(:metric_value) || 0,
      high_value_count: ImpactMetric.high_value.count,
      medium_value_count: ImpactMetric.medium_value.count,
      low_value_count: ImpactMetric.low_value.count,
      type_distribution: ImpactMetric.group(:metric_type).count
    }
  end

  def calculate_impact_comparison
    same_type_metrics = ImpactMetric.where(metric_type: @impact_metric.metric_type)
                                   .where.not(id: @impact_metric.id)
    
    {
      average_for_type: same_type_metrics.average(:metric_value) || 0,
      max_for_type: same_type_metrics.maximum(:metric_value) || 0,
      min_for_type: same_type_metrics.minimum(:metric_value) || 0,
      percentile: calculate_percentile(@impact_metric.metric_value, same_type_metrics.pluck(:metric_value))
    }
  end

  def calculate_percentile(value, values)
    return 0 if values.empty?
    sorted_values = values.sort
    position = sorted_values.index { |v| v > value } || sorted_values.length
    (position.to_f / sorted_values.length * 100).round(1)
  end

  def generate_impact_report
    {
      overall_stats: {
        total_metrics: ImpactMetric.count,
        average_value: ImpactMetric.average(:metric_value) || 0,
        value_range: {
          min: ImpactMetric.minimum(:metric_value) || 0,
          max: ImpactMetric.maximum(:metric_value) || 0
        }
      },
      by_type: ImpactMetric.group(:metric_type).select(
        'metric_type',
        'COUNT(*) as count',
        'AVG(metric_value) as avg_value',
        'SUM(metric_value) as total_value'
      ),
      by_value_level: {
        high: ImpactMetric.high_value.count,
        medium: ImpactMetric.medium_value.count,
        low: ImpactMetric.low_value.count
      }
    }
  end

  def calculate_category_impact
    ImpactMetric.joins(budget_allocation: :budget_category)
                .group('budget_categories.name')
                .select(
                  'budget_categories.name as category_name',
                  'COUNT(*) as metric_count',
                  'AVG(impact_metrics.metric_value) as avg_value',
                  'SUM(impact_metrics.metric_value) as total_value'
                )
                .each_with_object({}) do |result, hash|
      hash[result.category_name] = {
        metric_count: result.metric_count,
        avg_value: result.avg_value || 0,
        total_value: result.total_value || 0
      }
    end
  end

  def calculate_budget_impact
    ImpactMetric.joins(budget_allocation: :budget)
                .group('budgets.title')
                .select(
                  'budgets.title as budget_title',
                  'COUNT(*) as metric_count',
                  'AVG(impact_metrics.metric_value) as avg_value',
                  'SUM(impact_metrics.metric_value) as total_value'
                )
                .each_with_object({}) do |result, hash|
      hash[result.budget_title] = {
        metric_count: result.metric_count,
        avg_value: result.avg_value || 0,
        total_value: result.total_value || 0
      }
    end
  end
end
