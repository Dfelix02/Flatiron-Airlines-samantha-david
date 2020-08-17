class Interface
    attr_reader :prompt
    attr_accessor :user

    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome

    end

    def user_register_helper
        




        self.main_menu
    end

    def main_menu
        user.reload 
        system "clear" 
    end
end