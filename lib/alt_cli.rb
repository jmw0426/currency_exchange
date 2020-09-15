require 'colorize'
class CurrencyExchange::FreeMode_CLI

     #------- CurrencyExchange::APIManager.get_choice(currency) -------

    attr_accessor :currency_selection, :error_input, :user

     def initialize(user=nil)
        @currency_selection = []
        @error_input = []
        @user = user
     end

     def start
        welcome
        introduction
        main_loop
     end

     def welcome
        puts "Welcome to the Free Mode of the Currency Exchange! What is your name?\n\n".green.italic
        prompts(0)
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
        puts '                                                                        Free Mode'.green
        puts "\n\n"
        puts '                                                      Here you can compare any currency to another.'.green
        puts "\n\n"
        puts '                                             Simply type in the number of the currency and start exchanging.'.green
        puts "\n"
        puts "        --------------------------------------------------------------------------------------------------------------------------------------------".yellow
        puts "\n\n"
        sleep(2)
     end

     def prompts(num)
        list  = ["Welcome to the Free Mode of the Currency Exchange! Please enter your name.", 
        "Enter the number value of the currency you want to set as the base.", 
        "Enter the number value of the currency you want to compare.", "Please try again.", 
        "Type in the number of the currency you would like to set as the base and press enter.", 
        "Type in the number of the currency to which you would like to convert and press enter." ]

        prompt(list[num])
     end

     def prompt(v)
        system `say "#{v}"`
     end

    # ------- Navigation -------

    def main_loop
        loop do
            menu
            input = choose_comparator
            case input
            when "exit"
                exit_message
                exit
            when "invalid"
                next
            else
                display_single_currency2(input)
            end
        end
    end

    def action_menu
        puts "Type " + "exit".red  + " to exit the program."
        sleep(1)
        puts "Or type " + "menu".yellow + " to see the list of currencies."
        puts "---------------------------------------------".yellow

        input = gets.strip
        case input
        when "exit"
            exit_confirmation
        when "menu"
            puts "\n\n"
            main_loop
        end
    end

    # ------- Engine --------

    def get_currency_data
        CurrencyExchange::APIManager.get_rates
    end

    def choose_comparator
        choose_base_rate
        puts "\n\n"
        puts "Enter the number value of the currency you want to compare."
        puts "-----------------------------------------------------------".yellow
        prompts(5)
        input = gets.strip.downcase
        commands = ["exit", "menu"]
        return input.downcase if commands.include?(input.downcase)
        if input.to_i.between?(1, CurrencyExchange::Currency.all.length)
            return input.to_i - 1
        elsif input == 'exit'
            exit
        else
            error_message
            return "invalid" 
        end
    end

    def choose_base_rate
        puts "\n\n"
        puts "Enter the number value of the currency you want to set as the base."
        puts "-------------------------------------------------------------------".yellow
        prompts(4)
        input = gets.strip

        case input 
        when 'exit'
            exit_confirmation
            exit
        else
            list_num = input.to_i - 1
            choose_rate(list_num)
            puts "\n\n"
            puts "CURRENCIES:".green
            puts "---------------------------".yellow
            puts "\n"
            CurrencyExchange::Currency.all.each.with_index(1) do |currency, index| 
                puts "#{index}. #{currency.name}" 
                sleep(0.15)
            end
            puts "---------------------------".yellow
        end
    end

    def choose_rate(i)
        CurrencyExchange::Currency.delete_all
        get_currency_data
        # binding.pry
        currency_obj = CurrencyExchange::Currency.all[i.to_i]
        abbr = currency_obj.name
        @currency_selection << abbr
        CurrencyExchange::Currency.delete_all
        CurrencyExchange::APIManager.get_choice(abbr)
    end

    def display_single_currency2(i)
        self.error_input << i
        currency_obj = CurrencyExchange::Currency.all[i]

        puts "\n\n"
        system `say "You are currently converting #{currency_selection[-1]} to #{currency_obj.name}."`
        sleep(1)
        puts "---------------------------------------------------------------".yellow
        puts "It takes " + "#{currency_obj.value}".green + " #{currency_obj.name} to equal the value of 1 #{@currency_selection[-1]}."
        puts "---------------------------------------------------------------".yellow
        system `say "It takes approximately #{currency_obj.value.to_i} #{currency_obj.name} to equal the value of one #{@currency_selection[-1]}."`
        sleep(1)
        puts "\n\n\n\n"
        puts "Enter a #{@currency_selection[-1]} value to convert to #{currency_obj.name}."
        puts "------------------------------------".yellow

        input = gets.strip
        exchange = input.to_f * currency_obj.value.to_f
        if input == 'exit'
            exit_confirmation
        elsif exchange == 0
            error_dsc 
        else
            puts "\n\n"
            puts "---------------------------------------------------------------".yellow
            puts "#{input.to_f}".green + " #{@currency_selection[-1]} is equal to " + "#{exchange}".green + " #{currency_obj.name}."
            puts "---------------------------------------------------------------".yellow
            system `say "Woah! That's a lot of moolah!"`
            puts "\n\n"

            self.error_input.clear
            self.currency_selection.clear
            sleep(1)
            action_menu
        end
    end

    # ------- Display List -------

    def menu
        display_currency_list
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

    # ------- Error handling -------

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
        prompts(3)
        sleep(1)
        puts "\n\n\n"
    end

    def redirect_to_dsc
        i = self.error_input[-1]
        display_single_currency2(i)
    end

    # ------- Exit -------

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
        puts "Type " + "yes".red + " to exit, " + "no".green + " to keep exchanging, or " + "mode".yellow + " to change to a different mode."
        puts "----------------------------------------------------------------------------------".yellow

        input = gets.strip.downcase
        case input
        when 'yes'
            system `say "See you later #{self.user}!"`
            puts "\n\n"
            exit_message
            exit
        when 'no'
            system `say "What do you want to exchange next #{self.user}?"`
            puts "\n\n"
        when 'mode'
            system `say "Thanks for using Free Mode #{self.user}?"`
            @launch_new = CurrencyExchange::CLI.new
            @launch_new.start
        end
    end
    
end