require 'net/http'
require 'json'

module ProcessSurvey
    def self.get_data
        response = Net::HTTP.get_response('localhost', '/survey-data', 3000)
        if response.is_a?(Net::HTTPSuccess)
            parsed_data = JSON.parse(response.body)
            puts JSON.pretty_generate(parsed_data)
        else
            puts "Failed to retrieve data: #{response.message}"
        end
    end 
end

ProcessSurvey.get_data