class Destination < ActiveRecord::Base
    has_many :flights

    def set_destination
        prompt = TTY::Prompt.new

        country = prompt.ask("Enter country:")
        city = prompt.ask("Enter city:")
        airport = prompt.ask("Enter airport:")
        travelling_to = Destination.new(country,city,airport)
    end
end