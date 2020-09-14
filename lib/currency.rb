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

    def self.all
        @@all
    end

    def self.delete_all
        self.all.clear
    end

    def save 
        @@all << self
    end 
end