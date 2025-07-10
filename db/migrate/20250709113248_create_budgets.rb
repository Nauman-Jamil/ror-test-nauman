class CreateBudgets < ActiveRecord::Migration[8.0]
  def change
    create_table :budgets do |t|
      t.string :title
      t.text :description
      t.decimal :total_amount
      t.string :status

      t.timestamps
    end
  end
end
