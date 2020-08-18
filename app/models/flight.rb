class Flight < ActiveRecord::Base
  has_many :reservations
  has_many :users, through: :reservations

  def self.find_flights
  end
  
end
