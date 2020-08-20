class Interface
    attr_reader :prompt
    attr_accessor :user

    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome
        system "clear"
        Ascii_imgs.flatiron_logo
        prompt.select("#{Ascii_imgs.flatiron_banner}\n") do |menu|
            menu.choice "Log in\n", -> { user_logging_in}
            menu.choice "Register\n", -> { user_register_helper }
        end
        system "clear"
    end

    def user_logging_in
        user_instance = User.log_in
        
        if !user_instance
            system "clear"
            puts "Username does not exist. Going back to login/registration."
            sleep(2)
            system "clear"
            self.welcome
        end
       self.user = user_instance
        self.main_menu

    end

    def user_register_helper
        user_instance = User.register
       until user_instance
        user_instance = User.register
       end
       self.user = user_instance
        self.main_menu
    end


    def main_menu
        user.reload 
        system "clear" 
        Ascii_imgs.flatiron_logo
        prompt.select("#{Ascii_imgs.flatiron_banner}\n" + "Welcome #{self.user.name}!\n") do |menu|
            menu.choice "Book a flight\n", -> { booking_a_flight }
            menu.choice "View reservations\n", -> { viewing_reservations}
            menu.choice "Cancel reservation\n", -> { canceling_reservation}
            menu.choice "Update account info\n", -> { updating_account_info }
            menu.choice "Exit\n", -> { welcome }
        end
    end


    def booking_a_flight
        user.book_a_flight
        main_menu
    end

    def viewing_reservations
        system "clear"
        user.view_reservations
        main_menu
    end

    def canceling_reservation
        user.cancel_reservation
        main_menu
    end

    def updating_account_info
        user.update_account_info
        main_menu
    end

    
    
    
end