class CreateBudgetAllocations < ActiveRecord::Migration[8.0]
  def change
    create_table :budget_allocations do |t|
      t.references :budget, null: false, foreign_key: true
      t.references :budget_category, null: false, foreign_key: true
      t.decimal :amount
      t.text :description

      t.timestamps
    end
  end
end
