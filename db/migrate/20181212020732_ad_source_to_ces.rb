class AdSourceToCes < ActiveRecord::Migration[5.1]
  def change
    add_column :ces, :publisher, :string
  end
end
