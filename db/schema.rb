# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181023144110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.string "client_customer_id"
    t.string "campaign_id"
    t.string "name"
    t.string "status"
    t.string "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ces", force: :cascade do |t|
    t.datetime "grouping_date"
    t.integer "lead_request_users"
    t.integer "lead_users"
    t.integer "leads"
    t.float "leads_by_lead_users"
    t.float "unreconciled_publisher_lead_revenue"
    t.integer "clickout_impressions"
    t.integer "clickouts"
    t.float "clickthrough_rate"
    t.float "unreconciled_publisher_clickout_revenue"
    t.float "unreconciled_publisher_total_revenue"
    t.string "source_code"
    t.string "tracking_code"
    t.integer "adult_lead_request_users"
    t.integer "adult_lead_users"
    t.integer "adult_leads"
    t.integer "adult_leads_by_lead_users"
    t.float "adult_unreconciled_publisher_lead_revenue"
    t.integer "adult_clickouts"
    t.integer "adult_clickout_revenue"
    t.integer "hs_lead_request_users"
    t.integer "hs_lead_users"
    t.integer "hs_leads"
    t.integer "hs_leads_by_lead_users"
    t.float "hs_unreconciled_published_clickout_revenue"
    t.integer "hs_clickouts"
    t.float "hs_clickout_revenue"
  end

  create_table "pums", force: :cascade do |t|
    t.datetime "date"
    t.string "label"
    t.string "account_id"
    t.string "campaign_id"
    t.string "ad_group_id"
    t.string "keyword_id"
    t.string "publisher"
    t.string "account_name"
    t.string "campaign_name"
    t.string "ad_group_name"
    t.string "keyword"
    t.string "focus_word"
    t.string "industry"
    t.string "device_type"
    t.integer "impressions"
    t.float "cost_per_click"
    t.float "cost"
    t.integer "click_count"
    t.float "total_unreconciled_revenue"
    t.float "total_clickout_revenue"
    t.integer "leads"
    t.integer "clickouts"
    t.integer "lead_users"
    t.integer "lead_request_users"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "computed_id"
    t.integer "conversions"
    t.string "match_type"
    t.string "keyword_status"
    t.string "final_url"
    t.string "final_mobile_url"
    t.index ["account_id"], name: "index_pums_on_account_id"
    t.index ["account_name"], name: "index_pums_on_account_name"
    t.index ["ad_group_id"], name: "index_pums_on_ad_group_id"
    t.index ["ad_group_name"], name: "index_pums_on_ad_group_name"
    t.index ["campaign_id"], name: "index_pums_on_campaign_id"
    t.index ["campaign_name"], name: "index_pums_on_campaign_name"
    t.index ["computed_id"], name: "index_pums_on_computed_id"
    t.index ["device_type"], name: "index_pums_on_device_type"
    t.index ["focus_word"], name: "index_pums_on_focus_word"
    t.index ["industry"], name: "index_pums_on_industry"
    t.index ["keyword"], name: "index_pums_on_keyword"
    t.index ["keyword_id"], name: "index_pums_on_keyword_id"
    t.index ["label"], name: "index_pums_on_label"
    t.index ["publisher"], name: "index_pums_on_publisher"
  end

  create_table "pursuit_metrics", force: :cascade do |t|
    t.datetime "date"
    t.integer "account_id"
    t.string "custom"
    t.float "earnings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
