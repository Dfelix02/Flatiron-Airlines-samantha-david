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

        name = new_user.name.split(" ")
        puts "Welcome, #{name[0]}!"

        new_user
    end

    def self.log_in
        prompt = TTY::Prompt.new
        user_name = prompt.ask("Enter username:")
        find_user = User.find_by(user_name: user_name)
        if !find_user
            not_found = prompt.select("Username not found.", ["Try Again", "Register"])
            not_found == "Try Again" ? self.log_in : self.register
        end

        password = prompt.ask("Enter password:")
        until password == find_user.password
            password = prompt.ask("Enter password:")
        end

        name = find_user.name.split(" ")
        puts "Welcome back, #{name[0]}!"

        find_user
    end

    def book_a_flight
        prompt = TTY::Prompt.new
        date = prompt.ask("Enter date of departure:")
        prompt.select("Choose your destination:") do |menu|
            menu.choice "Enter your destination (ex: city, country)", -> { find_from_entering_destination(date) }
            menu.choice "Select from destinations", -> { find_from_destination_list(date) }
        end
        
    end

    def find_from_destination_list(date)
        prompt = TTY::Prompt.new
        destination = prompt.select("Destinations:", [Flight.all_destinations])
        destination_arr = destination.split(",")
        city = destination_arr[0]
        destination = Destination.find_by(city: city)
        # Plane.plane_animation
        flights = Flight.find_flights(date, destination.id)
        if flights
            flights_arr = flights.map do |flight|
                "Flight no. #{flight.id} - Date: #{flight.date} - Leaving from: New York City - Going to: #{destination.city}, #{destination.country} - Departing: #{flight.departing_time} - Arriving: #{flight.arrival_time}"
            end
            self.select_flight(flights_arr)
        else
            puts "Sorry, there are no available flights on this day."
            self.book_a_flight
        end
    end

    def select_flight(flights_arr)
        prompt = TTY::Prompt.new
        flight = prompt.select("Please select a flight:", flights_arr)
        flight_chosen = flight.split(" ")
        flight_id = flight_chosen[2]



        


        

    end
  

end


