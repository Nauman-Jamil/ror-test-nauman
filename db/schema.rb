# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_09_125650) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "budget_allocations", force: :cascade do |t|
    t.bigint "budget_id", null: false
    t.bigint "budget_category_id", null: false
    t.decimal "amount"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_category_id"], name: "index_budget_allocations_on_budget_category_id"
    t.index ["budget_id"], name: "index_budget_allocations_on_budget_id"
  end

  create_table "budget_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "spending_limit_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "budget_phases", force: :cascade do |t|
    t.bigint "budget_id", null: false
    t.string "name"
    t.text "description"
    t.string "status"
    t.date "start_date"
    t.date "end_date"
    t.text "voting_rules"
    t.text "participant_eligibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_budget_phases_on_budget_id"
  end

  create_table "budget_votes", force: :cascade do |t|
    t.bigint "budget_phase_id", null: false
    t.string "voter_name"
    t.string "voter_email"
    t.jsonb "vote_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_phase_id"], name: "index_budget_votes_on_budget_phase_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "total_amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impact_metrics", force: :cascade do |t|
    t.bigint "budget_allocation_id", null: false
    t.string "metric_name"
    t.decimal "metric_value"
    t.string "metric_type"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_allocation_id"], name: "index_impact_metrics_on_budget_allocation_id"
  end

  create_table "vote_allocations", force: :cascade do |t|
    t.bigint "budget_vote_id", null: false
    t.bigint "budget_category_id", null: false
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_category_id"], name: "index_vote_allocations_on_budget_category_id"
    t.index ["budget_vote_id"], name: "index_vote_allocations_on_budget_vote_id"
  end

  add_foreign_key "budget_allocations", "budget_categories"
  add_foreign_key "budget_allocations", "budgets"
  add_foreign_key "budget_phases", "budgets"
  add_foreign_key "budget_votes", "budget_phases"
  add_foreign_key "impact_metrics", "budget_allocations"
  add_foreign_key "vote_allocations", "budget_categories"
  add_foreign_key "vote_allocations", "budget_votes"
end
