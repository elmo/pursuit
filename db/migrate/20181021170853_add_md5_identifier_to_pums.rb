class AddMd5IdentifierToPums < ActiveRecord::Migration[5.1]
  def change
     add_column :pums, :computed_id, :string
     add_index(:pums, :computed_id)
  end
end
