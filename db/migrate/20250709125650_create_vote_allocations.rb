class CreateVoteAllocations < ActiveRecord::Migration[8.0]
  def change
    create_table :vote_allocations do |t|
      t.references :budget_vote, null: false, foreign_key: true
      t.references :budget_category, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
