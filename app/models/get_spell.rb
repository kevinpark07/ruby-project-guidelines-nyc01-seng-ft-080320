require 'net/http'
require 'open-uri'
require 'json'


class GetSpell
    
    URL = "https://www.potterapi.com/v1/spells?key=$2a$10$9cotrn8hm2vhEzS8mtY.dO3NJ9uobAe9MuERDSy9iR1K10b8kqvvy"

    def get_spells
        uri = URI.parse(URL)
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
    end
    
end




