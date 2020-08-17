class User < ActiveRecord::Base
    has_many :reservations
    has_many :flights, through: :reservations

  
    # def self.register
    #     prompt = TTY::Prompt.new
    #     new_username = prompt.ask("Enter username")#ask the user a username
    #     if User.find_by(username: new_username) #checks if it is taken or not
    #         #if it is it will display this message
    #         puts "Sorry, username already taken."
    #     else
    #         #if it is not it will ask for a password and check the password
    #         check_password = prompt.ask("Enter password")
    #         re_enter_password = prompt.ask("Confirm password")
    #         until check_password == re_enter_password
    #             puts "incorrect password, please try again"
    #             check_password = prompt.ask("Enter password")
    #             re_enter_password = prompt.ask("Confirm password")
    #         end
    #         #it will insert the information into the db and store it
    #         User.create(username: userInfo, :password check_password)
    #     end
    # end

    # def self.log_in
    #     prompt = TTY::Prompt.new
    #     check_user = prompt.ask("Enter username")#ask the user a username
    #     if User.find_by(username: check_user) #checks if it is there or not
    #         #if it is it will display this message
    #         puts "Wrong username"
    #     else
    #         #if it is not it will ask for a password and check the password
    #         check_password = prompt.ask("Enter password")
    #         until User.find_by(username: check_user, :password check_password)
    #             puts "incorrect password, please try again"
    #             check_password = prompt.ask("Enter password")
    #             re_enter_password = prompt.ask("Confirm password")
    #         end
    #         #it will insert the information into the db and store it
    #         User.create(username: userInfo, :password check_password)
    #     end
    # end

end
