class AddPasswordResetFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_column :users, :password_reset_sent_at, :datetime
  end
end
