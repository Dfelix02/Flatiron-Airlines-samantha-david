class Flight < ActiveRecord::Base
  has_many :reservations
  has_many :users, through: :reservations

  def self.all_destinations
    all_destinations = Destination.all.map do |destination|
      "#{destination.city}, #{destination.country}, #{destination.airport}"
    end
  end

  def self.find_flights(date, destination_id)
    Flight.where(date: date, destination_id: destination_id)
  end
  
end
