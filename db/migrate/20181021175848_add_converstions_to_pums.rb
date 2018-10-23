class AddConverstionsToPums < ActiveRecord::Migration[5.1]
  def change
    add_column :pums, :conversions, :integer
  end
end
