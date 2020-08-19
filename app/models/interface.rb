class Interface
    attr_reader :prompt
    attr_accessor :user

    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome
        
        prompt.select("
███████╗██╗      █████╗ ████████╗██╗██████╗  ██████╗ ███╗   ██╗     █████╗ ██╗██████╗ ██╗     ██╗███╗   ██╗███████╗███████╗
██╔════╝██║     ██╔══██╗╚══██╔══╝██║██╔══██╗██╔═══██╗████╗  ██║    ██╔══██╗██║██╔══██╗██║     ██║████╗  ██║██╔════╝██╔════╝
█████╗  ██║     ███████║   ██║   ██║██████╔╝██║   ██║██╔██╗ ██║    ███████║██║██████╔╝██║     ██║██╔██╗ ██║█████╗  ███████╗
██╔══╝  ██║     ██╔══██║   ██║   ██║██╔══██╗██║   ██║██║╚██╗██║    ██╔══██║██║██╔══██╗██║     ██║██║╚██╗██║██╔══╝  ╚════██║
██║     ███████╗██║  ██║   ██║   ██║██║  ██║╚██████╔╝██║ ╚████║    ██║  ██║██║██║  ██║███████╗██║██║ ╚████║███████╗███████║
╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝\n") do |menu|
            menu.choice "Log in\n", -> { user_logging_in}
            menu.choice "Register\n", -> { user_register_helper }
        end
    end

    def user_logging_in
        user_instance = User.log_in
       until user_instance
        user_instance = User.log_in
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
        prompt.select("
███████╗██╗      █████╗ ████████╗██╗██████╗  ██████╗ ███╗   ██╗     █████╗ ██╗██████╗ ██╗     ██╗███╗   ██╗███████╗███████╗
██╔════╝██║     ██╔══██╗╚══██╔══╝██║██╔══██╗██╔═══██╗████╗  ██║    ██╔══██╗██║██╔══██╗██║     ██║████╗  ██║██╔════╝██╔════╝
█████╗  ██║     ███████║   ██║   ██║██████╔╝██║   ██║██╔██╗ ██║    ███████║██║██████╔╝██║     ██║██╔██╗ ██║█████╗  ███████╗
██╔══╝  ██║     ██╔══██║   ██║   ██║██╔══██╗██║   ██║██║╚██╗██║    ██╔══██║██║██╔══██╗██║     ██║██║╚██╗██║██╔══╝  ╚════██║
██║     ███████╗██║  ██║   ██║   ██║██║  ██║╚██████╔╝██║ ╚████║    ██║  ██║██║██║  ██║███████╗██║██║ ╚████║███████╗███████║
╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝\n Welcome #{self.user.name}!\n") do |menu|
            menu.choice "Book a flight\n", -> { self.user.book_a_flight }
            menu.choice "View reservations\n", -> { self.user.view_reservations}
            menu.choice "Cancel reservation\n", -> {self.user.cancel_reservation}
            menu.choice "Exit\n", -> { self.welcome }
        end
    end
    
end