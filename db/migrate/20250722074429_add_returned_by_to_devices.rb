class AddReturnedByToDevices < ActiveRecord::Migration[7.1]
  def change
    add_reference :devices, :returned_by, null: true, foreign_key: { to_table: :users }
  end
end
