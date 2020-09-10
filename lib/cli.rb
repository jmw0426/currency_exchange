class CurrencyExchange::CLI
    attr_accessor :error_input
    def initialize
        @page = 1
        @limit = 33
        @error_input = []
    end

    def start
        introduction
        get_currency_data
        main_loop
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
        puts "        --------------------------------------------------------------------------------------------------------------------------------------------" 
        puts "\n"
        sleep(1) 
        puts '                                                            Welcome to the Currency Exchange!'
        sleep(2)
        puts "\n\n"
        puts '                                                  All currency rates are measured off of the US dollar.'
        puts "\n\n"
        sleep(1)
        puts '                                             Simply type in the number of the currency and start exchanging.'
        puts "\n"
        puts "        --------------------------------------------------------------------------------------------------------------------------------------------" 
        puts "\n\n"
        sleep(1)
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
                break
            when "invalid"
                next
            when "next"
                @page += 1
                _, stop = get_page_range
                if CurrencyExchange::Currency.all.length < stop
                    get_currency_data
                end
            when "prev"
                if @page <= 1
                    puts "You are on page 1!"
                else
                    @page -= 1
                end
            else
                display_single_currency(input)
            end

        end
    end

    def menu
        display_currency_list
        display_instructions
        # binding.pry
    end

    def get_currency_choice
        input = gets.strip.downcase
        commands = ["exit", "next", "prev"]
        return input.downcase if commands.include?(input.downcase)
        if input.to_i.between?(1, CurrencyExchange::Currency.all.length)
            return input.to_i - 1
        else
            error_message
            return "invalid" 
        end
    end

    def display_currency
        start, stop = get_page_range
        currency = CurrencyExchange::Currency.all[start...stop]
        currency.each.with_index(1) do |abbr, index|
            puts "#{index}. #{abbr.name}"
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

        puts "CURRENCIES:"
        puts "\n"
        currencies.each do |currency| 
            sleep 0.15
            puts currency
        end
        puts "\n"
    end

    def get_page_range
        [(@page - 1) * @limit, @page * @limit]
    end

    def display_single_currency(i)
        self.error_input << i
        currency_obj = CurrencyExchange::Currency.all[i]
        # binding.pry
        puts "It takes #{currency_obj.value} #{currency_obj.name} to equal the value of 1 US dollar."
        puts "Enter a USD value to convert to #{currency_obj.name}."
        input = gets.strip.to_f
        exchange = input * currency_obj.value.to_f
        if exchange == 0
            error_dsc
        else
            puts "#{input} USD is equal to #{exchange} #{currency_obj.name}."
            self.error_input.clear
            puts "Press 'enter' to continue"
            gets
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
        puts "That is not a valid entry."
        sleep(1)
        puts "\n\n\n\n"
    end

    def redirect_to_dsc
        i = self.error_input[-1]
        display_single_currency(i)
    end

    def display_instructions
        puts <<-INST
Please choose a currency by number or type 'exit' to exit the program.
        INST
    end

    # class MultiplicationError > StandardError
    #     print "."
    #     sleep(1)
    #     print "."
    #     sleep(1)
    #     print "."
    #     sleep(1)
    #     puts "That is not a valid entry."
    #     sleep(1)
    # end
end