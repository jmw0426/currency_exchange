class CurrencyExchange::CLI

    def initialize
        @page = 1
        @limit = 33
    end

    def start
        introduction
        get_currency_data
        main_loop
    end

    def introduction

        puts "\n\n\n\n"
        puts 'Welcome to the Currency Exchange!'
        sleep(2)
        puts "\n\n\n\n"
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
        display_currency
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
            puts "ummm....that doesn't make sense"
            sleep 2
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

    def get_page_range
        [(@page - 1) * @limit, @page * @limit]
    end

    def display_single_currency(i)
        currency_obj = CurrencyExchange::Currency.all[i]
        # binding.pry
        puts "It takes #{currency_obj.value} #{currency_obj.name} to equal the value of 1 US dollar."
        puts 'press any key to continue'
        gets
    end

    def display_instructions
        puts <<-INST
Please choose a currency by number or type 'exit' to exit the program.
        INST
    end

end