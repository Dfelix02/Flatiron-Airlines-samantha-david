class Flight < ActiveRecord::Base
  has_many :reservations
  has_many :users, through: :reservations

  def self.book_a_flight(destination_id)
    prompt = TTY::Prompt.new

    date = prompt.ask("Enter date of the flight (mm/dd/yyyy):")
    departing_time = prompt.ask("Enter departing time:")
    arraving_time = prompt.ask("Enter arriving time:")

    self.new
  end
end
