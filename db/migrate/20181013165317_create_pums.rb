class CreatePums < ActiveRecord::Migration[5.1]
  def change
    create_table :pums do |t|
      t.datetime :date
      t.string :label
      t.string :account_id
      t.string :campaign_id
      t.string :ad_group_id
      t.string :keyword_id
      t.string :publisher
      t.string :account_name
      t.string :campaign_name
      t.string :ad_group_name
      t.string :keyword
      t.string :focus_word
      t.string :industry
      t.string :device_type
      t.integer :impressions
      t.float :cost_per_click
      t.float :cost
      t.integer :click_count
      t.float :total_unreconciled_revenue
      t.float :total_clickout_revenue
      t.integer :leads
      t.integer :clickouts
      t.integer :lead_users
      t.integer :lead_request_users
      t.timestamps
    end
  end
end
