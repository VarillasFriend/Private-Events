class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable
    has_many :created_events, foreign_key: :creator_id, class_name: 'Event', dependent: :destroy
    has_many :user_events, foreign_key: :invitee_id, dependent: :destroy
    has_many :invited_events, through: :user_events, source: :event

    has_many :attendance_user_events, foreign_key: :attendee_id, dependent: :destroy
    has_many :attending_events, through: :attendance_user_events, source: :event
end
