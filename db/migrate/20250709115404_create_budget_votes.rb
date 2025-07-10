class CreateBudgetVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :budget_votes do |t|
      t.references :budget_phase, null: false, foreign_key: true
      t.string :voter_name
      t.string :voter_email
      t.jsonb :vote_data

      t.timestamps
    end
  end
end
