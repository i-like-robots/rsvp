class Notification < ActiveRecord::Base
  validates :subject, presence: true
  validates :message, presence: true
end
