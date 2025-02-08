require 'securerandom'

class Fika < ApplicationRecord

  STATUS = ["pending","accepted","rejected"]

  before_create :generate_fika_id
  
  validates :sender_id, :receiver_id, :scheduled_at, presence: {message: "cannot be blank"}
  validates :status, inclusion: { in: STATUS, message:"is not valid" }
  validate :sender_and_receriver_are_different

  def sender_and_receriver_are_different
    if sender_id === receiver_id
      errors.add(:receiver_id, "cannot be the same person")
    end
  end

  def sender_and_receiver_are_different
    errors.add(:receiver_id, "cannot be the same person") if sender_id == receiver_id
  end

  private

  def generate_fika_id
    self.fika_id ||= SecureRandom.uuid
  end

end