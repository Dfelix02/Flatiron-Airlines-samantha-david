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
        all_destinations = Destination.all.map do |destination|
            "#{destination.city}, #{destination.country}, #{destination.airport}"
        end
        
        destination = prompt.select("Choose destination", all_destinations)

        
    end
  

end


