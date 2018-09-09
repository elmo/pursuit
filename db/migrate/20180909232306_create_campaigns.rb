class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string :client_customer_id
      t.string :campaign_id
      t.string :name
      t.string :status
      t.string :budget
      t.timestamps
    end
  end
end
