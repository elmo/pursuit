class AddNewColsToPums < ActiveRecord::Migration[5.1]
  def change
    add_column :pums, :match_type, :string
    add_column :pums, :keyword_status, :string
    add_column :pums, :final_url, :string
    add_column :pums, :final_mobile_url, :string
  end
end
