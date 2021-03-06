class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.string :friend_name
      t.string :friend_email
      t.string :message
      t.datetime :invite_sent_at
    end
  end
end
