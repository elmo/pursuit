class CreatePursuitMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :pursuit_metrics do |t|
      t.datetime :date
      t.integer :account_id
      t.string :custom
      t.float :earnings
      t.timestamps
    end
  end
end
