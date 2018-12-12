class AddScFieldsToCe < ActiveRecord::Migration[5.1]
  def change
    add_column :ces, :campaign_id, :string
    add_column :ces, :adgroup_id, :string
    add_column :ces, :keyword_id, :string
    add_column :ces, :page_variation_1, :string
    add_column :ces, :page_variation_2, :string
  end
end
