require 'date'
require 'time'

class User < ActiveRecord::Base
    has_many :reservations
    has_many :flights, through: :reservations

  
    def self.register
        prompt = TTY::Prompt.new

        new_username = prompt.ask("Create a username:")#ask the user for their username
        until !User.find_by(user_name: new_username)
            puts "Sorry, that username has been taken."
            new_username = prompt.ask("Create a username:")
        end

        password = prompt.ask("Enter a password:")
        confirm_password = prompt.ask("Confirm password:")

        until confirm_password == password
            puts "Passwords do not match, please try again."
            password = prompt.ask("Enter a password:")
            confirm_password = prompt.ask("Confirm password:")
        end
        
        puts "Account successfully created."

        user_info = prompt.collect do
            key(:name).ask("Enter your full name, as it appears on your passport:")
            key(:cc_info).ask("Please enter your credit/debit card number:")
        end

        new_user = User.create(name: user_info[:name], user_name: new_username, password: password, cc_info: user_info[:cc_info])

        first_name = new_user.name.split(" ")
        puts "Welcome, #{first_name[0]}!"

        new_user
    end

    def self.log_in
        prompt = TTY::Prompt.new
        user_name = prompt.ask("Enter username:")
        find_user = User.find_by(user_name: user_name)

        if !find_user
            return nil
        end
        
        password = prompt.ask("Enter password:")
        until password == find_user.password
            password = prompt.ask("Enter password:")
        end
        first_name = find_user.name.split(" ")
        puts "Welcome back, #{first_name[0]}!"
        
        return find_user
    
    end

  
    def book_a_flight
        prompt = TTY::Prompt.new
        date = prompt.ask("Enter date of departure:")
        prompt.select("Choose your destination:") do |menu|
            menu.choice "Enter your destination", -> { find_from_entering_destination(date) }
            menu.choice "Select from destinations", -> { find_from_destination_list(date) }
        end
        system "clear"
    end

    def find_from_entering_destination(date)
        prompt = TTY::Prompt.new
        destination = prompt.ask("Enter city, country")
        destination_arr = destination.split(",")
        city = destination_arr[0]
        destination = Destination.find_by(city: city)
        Plane.plane_animation
        system "clear"
        flights = Flight.find_flights(date, destination.id)
        if flights != []
            flights_arr = flights.map do |flight|
                "Flight no. #{flight.id} - Date: #{flight.date} - Leaving from: New York City - Going to: #{destination.city}, #{destination.country} - Departing: #{flight.departing_time} - Arriving: #{flight.arrival_time}"
            end
            self.select_flight(flights_arr)
        else
            puts "Sorry, there are no available flights on this day. Please try your search again."
            self.book_a_flight
        end
        system "clear"
    end

    def find_from_destination_list(date)
        prompt = TTY::Prompt.new
        destination = prompt.select("Destinations:", [Flight.all_destinations])
        destination_arr = destination.split(",")
        city = destination_arr[0]
        destination = Destination.find_by(city: city)
        Plane.plane_animation
        system "clear"
        flights = Flight.find_flights(date, destination.id)
        if flights != []
            flights_arr = flights.map do |flight|
                "Flight no. #{flight.id} - Date: #{flight.date} - Leaving from: New York City - Going to: #{destination.city}, #{destination.country} - Departing: #{flight.departing_time} - Arriving: #{flight.arrival_time}"
            end
            self.select_flight(flights_arr)
        else
            puts "Sorry, there are no available flights on this day."
            choice3 = prompt.select("Options:") do |menu|
                menu.choice "New Search", -> {self.book_a_flight}
                menu.choice "Back to Main Menu", -> {return}
            end
        end
    end

    def select_flight(flights_arr)
        prompt = TTY::Prompt.new
        flight = prompt.select("Please select a flight:", flights_arr)
        flight_chosen = flight.split(" ")
        flight_id = flight_chosen[2]
        prompt.select("#{flight}") do |menu|
            menu.choice "Confirm and Book Flight", -> {self.confirm_and_book_flight(flight_id)}
            menu.choice "Select Another Flight", -> {self. select_flight(flights_arr)}
            menu.choice "New Search", -> {self.book_a_flight}
            menu.choice "Back to Main Menu", -> {return}
        end
    end

    def confirm_and_book_flight(flight_id)
        prompt = TTY::Prompt.new
        new_reservation = Reservation.create(user_id: self.id, flight_id: flight_id)
        Plane.plane_animation
        puts "Your flight is confirmed and your card ending in #{self.cc_info.split(//).last(4).join} will be charged."
        prompt.select("Option: ") do |menu|
            menu.choice "Back to Main Menu", -> {return}
        end
    end

    def view_reservations
        prompt = TTY::Prompt.new
        if reservations != []
            reservations.each do |reservation_info|
                puts "Confirmation no: #{reservation_info.id}"
                puts reservation_info.user.name
                puts "Traveling to #{reservation_info.flight.destination.city}, #{reservation_info.flight.destination.country} (#{reservation_info.flight.destination.airport})"
                p reservation_info.flight.date
                puts "Departing time: #{reservation_info.flight.departing_time}"
                puts "Arrival time: #{reservation_info.flight.arrival_time}"
                puts "-------------------------------------------------"
            end
            choice = prompt.select("Options:", ["Cancel a Reservation", "Back to Main Menu"])
            choice == "Cancel a Reservation" ? self.cancel_reservation : return
        else
            puts "You have no reservations."
            choice= prompt.select("Options:") do |menu|
                menu.choice "Back to Main Menu", -> {return}
            end
        end
            system "clear"
    end


    def cancel_reservation
        prompt = TTY::Prompt.new
        # binding.pry
        if self.user_reservations == nil
            puts "You have no reservations."
            choice1= prompt.select("Options:") do |menu|
                menu.choice "Back to Main Menu", -> {return}
            end
        else
            reservation = prompt.select("Which reservation would you like to cancel?", self.user_reservations)
            reservation = reservation.split(" ")
            reservation_id = reservation[2]
            reservation_to_cancel = Reservation.find_by(id: reservation_id)
            confirm_cancellation = prompt.yes?("Are you sure you want to cancel this reservation?")
            if confirm_cancellation
                Reservation.delete(reservation_to_cancel)
                system "clear"
                Plane.plane_animation
                system "clear"
                puts "Your reservation has been cancelled."   
                choice2= prompt.select("Options:") do |menu|
                    menu.choice "Back to Main Menu", -> {return}
                end
            else
                choice3 = prompt.select("Options:") do |menu|
                    menu.choice "Select Another Reservation to Cancel", -> {self.cancel_reservation}
                    menu.choice "Back to Main Menu", -> {return}
                end
            end
        end
        system "clear"
    end

    def user_reservations
        reservations_array = reservations.map do |reservation_info|
            "Confirmation number: #{reservation_info.id}\n
            #{reservation_info.user.name}\n
            Traveling to #{reservation_info.flight.destination.city}, #{reservation_info.flight.destination.country} (#{reservation_info.flight.destination.airport})\n
            #{reservation_info.flight.date}\n
            Departing time: #{reservation_info.flight.departing_time}\n
            Arrival time: #{reservation_info.flight.arrival_time}\n
            -------------------------------------------------"
        end
        reservations_array
    end

    # def update_reservation
    #     if self.user_reservations == nil
    #         puts "You have no reservations."
    #         choice1= prompt.select("Options:") do |menu|
    #             menu.choice "Back to Main Menu", -> {return}
    #     end

    #     reservation = prompt.select("Which reservation would you like to update?", self.user_reservations)
    #     reservation = reservation.split(" ")
    #     reservation_id = reservation[2]
    #     reservation_to_update = Reservation.find_by(id: reservation_id)

    #     prompt.select("What would you like to update?") do |menu|
    #         menu.choice "Destination", -> 
    #         { 
    #             confirm = prompt.yes?("Are you sure you want to update the destination of the flight?")
    #             if confirm
    #                 system "clear"
    #                 self.update_destination
    #             end
    #         }
    #     end

    #     prompt.select("Would you like to make any other changes?") do |menu|
    #         menu.choice "Yes", -> {self.update_reservation}
    #         menu.choice "No, take me to the main menu.", -> 
    #         {
    #             system "clear"
    #             Plane.plane_animation
    #             return            
    #         }
    #         end
            
    # end

    # def update_destination(reservation)
    #     system "clear"
    #     Reservation.delete(reservation)
    #     self.book_a_flight
    #     puts "Your reservation has been updated."
    # end
end
