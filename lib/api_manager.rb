class CurrencyExchange::APIManager

    BASE_URL = "https://api.exchangeratesapi.io/"

    def self.get_rates
        url = BASE_URL + "latest?base=USD"
        response = HTTParty.get(url)
        r = response["rates"]
        CurrencyExchange::Currency.mass_create_from_api(r)
    end

    def self.get_choice(currency)
        url = BASE_URL + "latest?base=" + currency
        response = HTTParty.get(url)
        r = response["rates"]
        CurrencyExchange::Currency.mass_create_from_api(r)
    end
end