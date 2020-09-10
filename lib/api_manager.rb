require 'pry'
class CurrencyExchange::APIManager

    BASE_URL = "https://api.exchangeratesapi.io/"

    def self.get_rates(page=1, limit=10)
        url = BASE_URL + "latest?base=USD"
        response = HTTParty.get(url)
        r = response["rates"]
        # 33 return values
        CurrencyExchange::Currency.mass_create_from_api(r)
        # r.each {|name, value| puts name}
        # binding.pry
    end
end