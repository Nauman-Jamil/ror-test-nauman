class ImpactMetricsController < ApplicationController
  before_action :set_budget, only: [:new, :create, :edit, :update, :destroy], if: -> { params[:budget_id].present? }
  before_action :set_budget_allocation, only: [:new, :create, :edit, :update, :destroy], if: -> { params[:budget_allocation_id].present? }
  before_action :set_impact_metric, only: [:show, :edit, :update, :destroy]

  def index
    @impact_metrics = ImpactMetric.includes(:budget_allocation).all
    @total_metrics = @impact_metrics.count
    @average_value = @impact_metrics.average(:metric_value) || 0
    @type_impact = calculate_type_impact
    @value_distribution = calculate_value_distribution
  end

  def show
    @related_metrics = ImpactMetric.where.not(id: @impact_metric.id)
                                  .where(metric_type: @impact_metric.metric_type)
                                  .limit(6)
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
                  'AVG(metric_value) as avg_value'
                )
                .each_with_object({}) do |result, hash|
      hash[result.metric_type] = {
        count: result.count,
        avg_value: result.avg_value || 0
      }
    end
  end

  def calculate_value_distribution
    ImpactMetric.group(:metric_value)
                .count
                .sort.to_h
  end
end
