require 'pry'
class CurrencyExchange::APIManager

    BASE_URL = "https://api.exchangeratesapi.io/latest?base=USD"

    def self.get_rates
        puts "Network request"

        url = BASE_URL
        response = HTTParty.get(url)
        r = response["rates"]
        # 33 return values
        CurrencyExchange::Currency.mass_create_from_api(r)
        # r.each {|name, value| puts name}
        # binding.pry
    end
end