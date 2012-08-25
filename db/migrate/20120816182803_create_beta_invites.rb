class CreateBetaInvites < ActiveRecord::Migration
  def change
    create_table :beta_invites do |t|
      t.integer :user_id
      t.string  :code
      t.string  :email

      t.timestamps
    end
  end
end
