class AddAccountStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_status, :boolean, default: true
  end
end
