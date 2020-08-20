class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :flight

  def self.delete(reservation)
    reservation.destroy
  end
  
end
