require 'securerandom'

class Fika < ApplicationRecord

  STATUS = ["pending","accepted","declined"]

  before_validation :set_sender_and_receiver_names
  before_create :generate_fika_id
  
  validates :sender_id, :sender_name,:receiver_id,:receiver_name, :scheduled_at, presence: {message: "cannot be blank"}
  validates :status, inclusion: { in: STATUS, message:"is not valid" }
  validate :sender_and_receriver_are_different
 
  private

  def sender_and_receriver_are_different
    if sender_id === receiver_id
      errors.add(:receiver_id, "cannot be the same person")
    end
  end

  def generate_fika_id
    self.fika_id ||= SecureRandom.uuid
  end

  def set_sender_and_receiver_names
    self.sender_name ||= User.find_by(id: sender_id)&.name
    self.receiver_name ||= User.find_by(id: receiver_id)&.name
  end

end