require 'colorize'
class CurrencyExchange::CLI

    def start
        banner
        welcome_message
        instructions
        welcome_selection
    end

    def instructions
        system `say "In Default Mode you will be converting US dollars into other currencies."`
        system `say "In Free Mode you can select any currency to convert."`
    end

    def welcome_message
        puts "                                                              -------------------------------".yellow
        puts "                                                              *                             *"
        puts "                                                              *  Press 1 for Default Mode   *".italic
        puts "                                                              *                             *"
        puts "                                                              *--------------" + "$".green + "--------------*"
        puts "                                                              *                             *"
        puts "                                                              *    Press 2 for Free Mode    *".italic
        puts "                                                              *                             *"
        puts "                                                              -------------------------------".yellow
        puts "\n\n"
        puts "Welcome to the Currency Exchange!".green
        puts "---------------------------------".yellow
    end

    def welcome_error
        print "."
        sleep(0.25)
        print "."
        sleep(0.25)
        print "."
        sleep(0.25)
        puts "\n\n"
        puts "That is not a valid entry.".red
        puts "\n\n"
        system `say "Please type either the number 1 or the number 2 in order to proceed."`
        welcome_message
        welcome_selection
    end

    def welcome_selection
        input = gets.strip
        case input
        when '1'
            system `say "Enjoy exchanging in Default Mode."`
            @dnew = CurrencyExchange::Default_CLI.new
            @dnew.start
        when '2'
            system `say "Enjoy exchanging in Free Mode."`
            @fnew = CurrencyExchange::FreeMode_CLI.new
            @fnew.start
        when 'exit'
            system `say "See you later!"`
            exit
        else 
            welcome_error
        end
    end

    def banner
        puts <<-'EOF'

         ██████╗██╗   ██╗██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗██╗   ██╗    ███████╗██╗  ██╗ ██████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗
        ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝╚██╗ ██╔╝    ██╔════╝╚██╗██╔╝██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔════╝
        ██║     ██║   ██║██████╔╝██████╔╝█████╗  ██╔██╗ ██║██║      ╚████╔╝     █████╗   ╚███╔╝ ██║     ███████║███████║██╔██╗ ██║██║  ███╗█████╗  
        ██║     ██║   ██║██╔══██╗██╔══██╗██╔══╝  ██║╚██╗██║██║       ╚██╔╝      ██╔══╝   ██╔██╗ ██║     ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══╝  
        ╚██████╗╚██████╔╝██║  ██║██║  ██║███████╗██║ ╚████║╚██████╗   ██║       ███████╗██╔╝ ██╗╚██████╗██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████╗
         ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝   ╚═╝       ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
        
        EOF
        system `say "Welcome to the Currency Exchange!"`
    end
end