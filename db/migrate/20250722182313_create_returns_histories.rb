class CreateReturnsHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :returns_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.datetime :assigned_at
      t.datetime :returned_at

      t.timestamps
    end
  end
end
