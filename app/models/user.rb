require 'date'
require 'time'

class User < ActiveRecord::Base
    has_many :reservations
    has_many :flights, through: :reservations

  
    def self.register
        prompt = TTY::Prompt.new
        system "clear"
        Ascii_imgs.flatiron_logo
        Ascii_imgs.flatiron_banner
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
        system "clear"
        new_user
    end

    def self.log_in
        system "clear"
        Ascii_imgs.flatiron_logo
        Ascii_imgs.flatiron_banner
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

        system "clear"
        return find_user
    
    end

  
    def book_a_flight
        system "clear"
        Ascii_imgs.plane
        Ascii_imgs.flatiron_banner
        prompt = TTY::Prompt.new
        date = prompt.ask("Enter date of departure:")
        prompt.select("Choose your destination:") do |menu|
            menu.choice "Enter your destination", -> { find_from_entering_destination(date) }
            menu.choice "Select from destinations", -> { find_from_destination_list(date) }
        end
    end

    def find_from_entering_destination(date)
        system "clear"
        Ascii_imgs.plane
        Ascii_imgs.flatiron_banner
        prompt = TTY::Prompt.new
        destination = prompt.ask("Enter city, country:")
        destination_arr = destination.split(",")
        city = destination_arr[0].capitalize
        destination = Destination.find_by(city: city)
        Plane.plane_animation
        system "clear"
        Ascii_imgs.plane
        Ascii_imgs.flatiron_banner
        flights = Flight.find_flights(date, destination.id)
        if flights != []
            flights_arr = flights.map do |flight|
                "Flight no. #{flight.id} - Date: #{flight.date} - Leaving from: New York City - Going to: #{destination.city}, #{destination.country} - Departing: #{flight.departing_time} - Arriving: #{flight.arrival_time} - Price: $#{flight.price}"
            end
            self.select_flight(flights_arr)
        else
            puts "Sorry, there are no available flights on this day. Please try your search again."
            self.book_a_flight
        end
    end

    def find_from_destination_list(date)
        system "clear"
        prompt = TTY::Prompt.new
        Ascii_imgs.plane
        Ascii_imgs.flatiron_banner
        destination = prompt.select("Destinations:", [Flight.all_destinations])
        destination_arr = destination.split(",")
        city = destination_arr[0]
        destination = Destination.find_by(city: city)
        Plane.plane_animation
        system "clear"
        Ascii_imgs.plane
        Ascii_imgs.flatiron_banner
        flights = Flight.find_flights(date, destination.id)
        if flights != []
            flights_arr = flights.map do |flight|
                "Flight no. #{flight.id} - Date: #{flight.date} - Leaving from: New York City - Going to: #{destination.city}, #{destination.country} - Departing: #{flight.departing_time} - Arriving: #{flight.arrival_time} - Price: $#{flight.price}"
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
        Ascii_imgs.plane
        Ascii_imgs.flatiron_banner
        new_reservation = Reservation.create(user_id: self.id, flight_id: flight_id)
        Plane.plane_animation
        puts "Your flight is confirmed and your card ending in #{self.cc_info.split(//).last(4).join} will be charged $#{new_reservation.flight.price}."
        prompt.select("Option: ") do |menu|
            menu.choice "Back to Main Menu", -> {return}
        end
    end

    def view_reservations
        system "clear"
        prompt = TTY::Prompt.new
        Ascii_imgs.plane
        Ascii_imgs.flatiron_banner
        if reservations != []
            reservations.each do |reservation_info|
                puts "Confirmation no: #{reservation_info.id}"
                puts reservation_info.user.name
                puts "Traveling to #{reservation_info.flight.destination.city}, #{reservation_info.flight.destination.country} (#{reservation_info.flight.destination.airport})"
                p reservation_info.flight.date
                puts "Departing time: #{reservation_info.flight.departing_time}"
                puts "Arrival time: #{reservation_info.flight.arrival_time}"
                puts "Price: $#{reservation_info.flight.price}"
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
            Price: $#{reservation_info.flight.price}
            -------------------------------------------------"
        end
        system "clear"
        reservations_array
    end

    def update_account_info
        prompt = TTY::Prompt.new
        system "clear"
        Ascii_imgs.plane
        Ascii_imgs.flatiron_banner
        prompt.select("What would you like to do?") do |menu|
            menu.choice "Update username", -> {self.update_username}
            menu.choice "Update password", -> {self.update_password}
            menu.choice "Update credit card info", -> {self.update_cc_info}
            menu.choice "Back to main menu", -> {return}
        end
    end

    def update_username
        prompt = TTY::Prompt.new
        new_username = prompt.ask("Enter new username:")
        self.user_name = new_username
        self.save
        system "clear"
        puts "Your username has been updated to #{self.user_name}."
        sleep(2)
        system "clear"
    end

    def update_password
        prompt = TTY::Prompt.new
        new_password = prompt.ask("Enter new password:")
        confirm_password = prompt.ask("Confirm password:")

        until confirm_password == new_password
            puts "Passwords do not match, please try again."
            new_password = prompt.ask("Enter a password:")
            confirm_password = prompt.ask("Confirm password:")
        end

        self.password = new_password
        self.save
        system "clear"
        puts "Your password has been updated."
        sleep(2)
        system "clear"
    end 
    
    def update_cc_info
        prompt = TTY::Prompt.new
        new_cc_info = prompt.ask("Enter new credit card information:")
        self.cc_info = new_cc_info
        self.save
        system "clear"
        puts "Your payment method has been updated to credit card ending in #{self.cc_info.split(//).last(4).join}."
        sleep(2)
        system "clear"
    end
        
end
