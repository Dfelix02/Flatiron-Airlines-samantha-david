class Flight < ActiveRecord::Base
  has_many :reservations
end
