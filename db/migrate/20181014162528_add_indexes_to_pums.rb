class AddIndexesToPums < ActiveRecord::Migration[5.1]
  def change
     add_index(:pums, :label)
     add_index(:pums, :account_id)
     add_index(:pums, :campaign_id)
     add_index(:pums, :ad_group_id)
     add_index(:pums, :keyword_id)
     add_index(:pums, :publisher)
     add_index(:pums, :account_name)
     add_index(:pums, :campaign_name)
     add_index(:pums, :ad_group_name)
     add_index(:pums, :keyword)
     add_index(:pums, :focus_word)
     add_index(:pums, :industry)
     add_index(:pums, :device_type)
  end
end
