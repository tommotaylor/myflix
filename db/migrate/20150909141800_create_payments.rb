class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.float :amount
      t.string :reference_id

      t.timestamps
    end
  end
end
