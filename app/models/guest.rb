class Guest < ActiveRecord::Base

  validates :name, presence: true

  validates :phone_number, presence: true
  validates :phone_number, format: { with: /\A\+\d{10,13}\z/ }
  validates :phone_number, uniqueness: true

  validates :email, presence: true
  validates :email, format: { with: /@/ }
  validates :email, uniqueness: true

  before_create :add_uuid

  def phone_number=(val)
    num = PhoneNumber.normalize(val)
    write_attribute(:phone_number, num)
  end

  def add_uuid
    self.uuid = SecureRandom.uuid
  end

end
