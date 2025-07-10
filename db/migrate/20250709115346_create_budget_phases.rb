class CreateBudgetPhases < ActiveRecord::Migration[8.0]
  def change
    create_table :budget_phases do |t|
      t.references :budget, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :status
      t.date :start_date
      t.date :end_date
      t.text :voting_rules
      t.text :participant_eligibility

      t.timestamps
    end
  end
end
