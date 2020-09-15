class CurrencyExchange::CLI

    def start
        welcome_message
        welcome_selection until welcome_selection == true
    end

    def welcome_message
        puts "Press 1 for Default Mode"
        puts "Press 2 for Free Mode"
    end

    def welcome_selection
        input = gets.strip.to_i
        case input
        when 1
            @dnew = CurrencyExchange::Default_CLI.new
            @dnew.start
        when 2
            @fnew = CurrencyExchange::FreeMode_CLI.new
            @fnew.start
        else 
            return false
        end
    end
end