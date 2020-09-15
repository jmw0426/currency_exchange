require 'colorize'
class CurrencyExchange::Default_CLI
    attr_accessor :error_input, :user
    def initialize(user=nil)
        @user = user
        @error_input = []
    end

    def start
        welcome
        introduction
        get_currency_data
        main_loop
    end

    def welcome
        puts "Welcome to the Currency Exchange! What is your name?\n\n".green.italic
        system `say "Welcome to the Currency Exchange! Please enter your name: "`
        self.user = gets.strip
        system `say "Hello #{self.user}. Get ready to start exchanging currency!"`
    end

    def introduction

        puts "\n\n\n\n"

        puts <<-'EOF'

        ██████╗██╗   ██╗██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗██╗   ██╗    ███████╗██╗  ██╗ ██████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗
        ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝╚██╗ ██╔╝    ██╔════╝╚██╗██╔╝██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔════╝
        ██║     ██║   ██║██████╔╝██████╔╝█████╗  ██╔██╗ ██║██║      ╚████╔╝     █████╗   ╚███╔╝ ██║     ███████║███████║██╔██╗ ██║██║  ███╗█████╗  
        ██║     ██║   ██║██╔══██╗██╔══██╗██╔══╝  ██║╚██╗██║██║       ╚██╔╝      ██╔══╝   ██╔██╗ ██║     ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══╝  
        ╚██████╗╚██████╔╝██║  ██║██║  ██║███████╗██║ ╚████║╚██████╗   ██║       ███████╗██╔╝ ██╗╚██████╗██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████╗
        ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝   ╚═╝       ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
        
        EOF
        sleep(2) 
        puts "        --------------------------------------------------------------------------------------------------------------------------------------------".yellow 
        puts "\n"
        puts '                                                            Welcome to the Currency Exchange!'.green
        puts "\n\n"
        puts '                                                  All currency rates are measured off of the US dollar.'.green
        puts "\n\n"
        puts '                                             Simply type in the number of the currency and start exchanging.'.green
        puts "\n"
        puts "        --------------------------------------------------------------------------------------------------------------------------------------------".yellow
        puts "\n\n"
        sleep(2)
    end

    def get_currency_data
        CurrencyExchange::APIManager.get_rates
    end

    def main_loop
        loop do
            menu
            input = get_currency_choice
            case input
            when "exit"
                farewell
                exit_message
                break
            when "invalid"
                next
            else
                display_single_currency(input)
            end
        end
    end

    def menu
        display_currency_list
        display_instructions
    end

    def display_instructions
        puts "Please choose a currency by number or type " + "exit".red  + " to exit the program."
        puts "----------------------------------------------------------------------"
        system `say "Type in the number of the currency you wish to choose and press enter."`
    end

    def action_menu
        puts "Type " + "exit".red  + " to exit the program."
        sleep(1)
        puts "Or type " + "menu".yellow + " to see the list of currencies."
        puts "---------------------------------------------"
        
        input = gets.strip
        case input
        when "exit"
            exit_confirmation
        when "menu"
            puts "\n\n"
        end
    end

    def get_currency_choice
        input = gets.strip.downcase
        commands = ["exit", "menu"]
        return input.downcase if commands.include?(input.downcase)
        if input.to_i.between?(1, CurrencyExchange::Currency.all.length)
            return input.to_i - 1
        else
            error_message
            return "invalid" 
        end
    end

    def display_currency_list
        currencies = ["1.  CAD = Canadian dollar",
        "2.  HKD = Hong Kong dollar",
        "3.  ISK = Icelandic króna",
        "4.  PHP = Philippine peso",
        "5.  DKK = Danish krone",
        "6.  HUF = Hungarian forint",
        "7.  CZK = Czech koruna",
        "8.  GBP = Great British pound",
        "9.  RON = Romanian leu",
        "10. SEK = Swedish krona",
        "11. IDR = Indonesian rupiah",
        "12. INR = Indian rupee",
        "13. BRL = Brazilian real",
        "14. RUB = Russian ruble",
        "15. HRK = Croatian kuna",
        "16. JPY = Japanese yen",
        "17. THB = Thai baht",
        "18. CHF = Swiss franc",
        "19. EUR = Euro",
        "20. MYR = Malaysian ringgit",
        "21. BGN = Bulgarian lev",
        "22. TRY = Turkish lira",
        "23. CNY = Chinese renminbi",
        "24. NOK = Norwegian krone",
        "25. NZD = New Zealand dollar",
        "26. ZAR = South African rand",
        "27. USD = United States dollar",
        "28. MXN = Mexican peso",
        "29. SGD = Singapore dollar",
        "30. AUD = Australian dollar",
        "31. ILS = Israeli new shekel",
        "32. KRW = South Korean won",
        "33. PLN = Polish złoty"]

        puts "CURRENCIES".green + ":"
        puts "---------------------------".yellow
        puts "\n"

        currencies.each do |currency| 
            sleep 0.15
            puts currency
        end

        puts "\n"
        puts "---------------------------".yellow
        puts "\n\n"
    end

    def display_single_currency(i)
        self.error_input << i
        currency_obj = CurrencyExchange::Currency.all[i]

        puts "\n\n"
        system `say "You are currently converting US dollars to #{currency_obj.name}."`
        sleep(1)
        puts "---------------------------------------------------------------".yellow
        puts "It takes " + "#{currency_obj.value}".green + " #{currency_obj.name} to equal the value of 1 US dollar."
        puts "---------------------------------------------------------------".yellow
        system `say "It takes approximately #{currency_obj.value.to_i} #{currency_obj.name} to equal the value of one US dollar."`
        sleep(1)
        puts "\n\n\n\n"
        puts "Enter a USD value to convert to #{currency_obj.name}."
        puts "------------------------------------"

        input = gets.strip
        exchange = input.to_f * currency_obj.value.to_f
        if input == 'exit'
            exit_confirmation
        elsif input == 'menu'
            action_menu    
        elsif exchange == 0
            error_dsc
        else
            puts "\n\n"
            puts "---------------------------------------------------------------".yellow
            puts "#{input.to_f}".green + " USD is equal to " + "#{exchange}".green + " #{currency_obj.name}."
            puts "---------------------------------------------------------------".yellow
            system `say "Woah! That's a lot of moola!"`
            puts "\n\n"

            self.error_input.clear
            sleep(1)
            action_menu
        end
    end

    def error_dsc
        error_message
        redirect_to_dsc
    end
        
    def error_message
        puts "\n\n"
        print "."
        sleep(1)
        print "."
        sleep(1)
        print "."
        sleep(1)
        puts "\n\n\n\n"
        puts "That is not a valid entry.".red
        system `say "Please try again."`
        sleep(1)
        puts "\n\n\n"
    end

    def redirect_to_dsc
        i = self.error_input[-1]
        display_single_currency(i)
    end

    def exit_message
        puts "\n\n"
        puts "Thank you for using the Currency Exchange!".yellow
        puts "\n\n\n\n"
        powered_by 
        puts "----------------------------------------------"
        puts"\n"
        puts "- https://api.exchangeratesapi.io/".blue
        puts "\n\n"
        puts "- https://github.com/jmw0426/currency_exchange".blue
        puts "\n"
        puts "----------------------------------------------"
        sleep(1.5)
    end

    def powered_by
        print "P".red
        sleep(0.15)
        print "o".yellow
        sleep(0.15)
        print "w".colorize(:blue)
        sleep(0.15)
        print "e".green
        sleep(0.15)
        print "r".yellow
        sleep(0.15)
        print "e".colorize(:blue)
        sleep(0.15)
        print "d".red
        sleep(0.15)
        print " "
        print "b"
        sleep(0.15)
        print "y"
        print ":"
        sleep(1)
        puts "\n\n"
    end

    def exit_confirmation
        puts "\n\n"
        puts "Are you sure you wish to exit the program?".on_red.blink
        system `say "Leaving so soon?"`
        puts "\n\n"
        puts "Type " + "yes".red + " or " + "no".green + "."
        puts "-------------------------------------------"

        input = gets.strip.downcase
        case input
        when 'yes'
            puts "\n\n"
            farewell
            exit_message
            exit
        when 'no'
            puts "\n\n"
            system `say "What do you want to exchange next #{self.user}?"`
        else 
            puts "I don't understand."
            return "invalid"    
        end
    end

    def farewell
        system `say "See you later #{self.user}!"`
    end
end