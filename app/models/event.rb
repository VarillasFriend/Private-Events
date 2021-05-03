class Event < ApplicationRecord
    belongs_to :creator, class_name: 'User'
    has_many :user_events, foreign_key: :event_id, dependent: :destroy
    has_many :invitees, through: :user_events, source: :invitee

    has_many :attendance_user_events, foreign_key: :event_id, dependent: :destroy
    has_many :attendees, through: :attendance_user_events, source: :attendee
end
