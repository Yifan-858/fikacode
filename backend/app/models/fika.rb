class Fika < ApplicationRecord

  STATUS = ["pending","accepted","rejected"]

  def initialize(attributes = {})
    super
    self.status ="pending"
  end

  validates :sender_id, :receiver_id, :scheduled_at, presence: {message: "cannot be blank"}
  validates :status, inclusion: { in: STATUS, message:"is not valid" }
  validate :sender_and_receriver_are_different

  def sender_and_receriver_are_different
    if sender_id === receiver_id
      errors.add(:receiver_id, "cannot be the same person")
    end
  end

  def create_or_update
    if fika_id.present?
      update_fika
    else
      create_fika
    end
  end

  def create_fika
  
    if valid?
      Rails.logger.debug "It is a new fika invitation"
      self.fika_id = SecureRandom.uuid

      new_fika = {
        fika_id: fika_id,
        sender_id: sender_id,
        receiver_id: receiver_id, 
        status: status,
        scheduled_at: scheduled_at
      }

      fikas = Rails.cache.read('fikas') || []
      fikas << new_fika
      Rails.cache.write('fikas', fikas)
      
      return new_fika

    else

      error.add(:base, "Invalid data. Cannot create new fika")
      return false
    end
  end

  def update_fika
    fikas = Rails.cache.read('fikas') || []
    fika_to_update = fikas.find { |fika| fika[:fika_id] == fika_id }
  
    if fika_to_update
     
      fika_to_update[:status] = status if status.present?
      fika_to_update[:scheduled_at] = scheduled_at if scheduled_at.present?
  
      Rails.cache.write('fikas', fikas)
      return fika_to_update
    else
      errors.add(:fika_id, "not found")
      return nil
    end
  end

end