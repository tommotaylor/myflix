class AddInviteTokenToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :invite_token, :string
  end
end
