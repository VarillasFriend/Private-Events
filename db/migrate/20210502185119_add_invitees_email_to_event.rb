class AddInviteesEmailToEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :invitees_email, :string
  end
end
