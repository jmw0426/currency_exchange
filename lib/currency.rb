class CurrencyExchange::Currency
    attr_accessor :name, :value

    @@all = []

    def initialize(name, value)
        @name, @value = name, value
        save
    end

    def self.mass_create_from_api(hash)
        hash.each { |key, value| self.new(key, value) }
    end

    def self.get_single_currency(input)
        self.all.select do |name| 
            name == input 
        end
    end

    def self.all
        @@all
    end

    def save 
        @@all << self
    end 
end