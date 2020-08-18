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
        
        puts "Account created."

        user_info = prompt.collect do
            key(:name).ask("Enter your full name, as it appears on your passport:")
            key(:cc_info).ask("Please enter your credit/debit card number:")
        end

        new_user = User.create(name: user_info[:name], user_name: new_username, password: password, cc_info: user_info[:cc_info])
    end

    def self.log_in
        prompt = TTY::Prompt.new
        check_user = prompt.ask("Enter username")#ask the user a username
        if User.find_by(username: check_user) #checks if it is there or not
            #if it is it will display this message
            puts "Wrong username"
        else
            #if it is not it will ask for a password and check the password
            check_password = prompt.ask("Enter password")
            until User.find_by(username: check_user, :password check_password)
                puts "incorrect password, please try again"
                check_password = prompt.ask("Enter password")
                re_enter_password = prompt.ask("Confirm password")
            end
            #it will insert the information into the db and store it
            User.create(username: userInfo, :password check_password)
        end
    end

end
