class CreateImpactMetrics < ActiveRecord::Migration[8.0]
  def change
    create_table :impact_metrics do |t|
      t.references :budget_allocation, null: false, foreign_key: true
      t.string :metric_name
      t.decimal :metric_value
      t.string :metric_type
      t.text :description

      t.timestamps
    end
  end
end
