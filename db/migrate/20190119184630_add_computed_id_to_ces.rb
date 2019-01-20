class AddComputedIdToCes < ActiveRecord::Migration[5.1]
  def change
    add_column :ces, :computed_id, :string
    add_index :ces, :computed_id
  end
end
