class CreateAttendanceUserEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :attendance_user_events do |t|
        t.integer :event_id
        t.integer :attendee_id

      t.timestamps
    end
  end
end
