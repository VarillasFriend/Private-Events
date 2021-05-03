class CreateUserEvents < ActiveRecord::Migration[6.0]
    def change
        create_table :user_events do |t|
            t.integer :event_id
            t.integer :invitee_id

            t.timestamps
        end
        change_table :events do |t|
            t.rename :user_id, :creator_id
          end
          
    end
end
