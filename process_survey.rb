require 'net/http'
require 'json'

FRIEND_ORDER_MAPPING = { "yes" => 0, "maybe" => 1, "no" => 2 }

module ProcessSurvey
    def self.get_data
        uri = URI('http://localhost:3000/survey-data')
        response = Net::HTTP.get_response(uri)
        if response.is_a?(Net::HTTPSuccess)
            parsed_data = JSON.parse(response.body)
            puts JSON.pretty_generate(parsed_data)
            parsed_data["data"]
        else
            puts "Failed to retrieve data: #{response.message}"
        end
    end 

    def self.avg_overall_satisfaction(data)
        avg_satisfaction = data.reduce(0) { |avg, response| avg += response["overall_satisfaction"].to_i }/data.size
        puts "Average overall satisfaction: #{avg_satisfaction}"
    end

    def self.sort_by_satisfaction(data)
        sorted = data.sort_by { |person| person["overall_satisfaction"] }
        puts "Sorted by overall satisfaction #{JSON.pretty_generate(sorted)}"
    end

    def self.group_by_satisfaction_and_team(data)
        sorted = data.sort_by { |person| [person["overall_satisfaction"], person["team_name"].downcase ] }
        puts "Sorted and grouped by overall satisfaction #{JSON.pretty_generate(sorted)}"
    end

    def self.recommend_to_a_friend_mode(data)
        most_common = nil
        max_count = 0
        response_count = Hash.new(0)

        data.each do |response|
            answer = response["recommend_to_friend"]
            response_count[answer] += 1
            if response_count[answer] > max_count
                max_count = response_count[answer]
                most_common = answer
            end
        end

        response_count_values = response_count.values
        most_common = "non-conclusive" if response_count_values.all? { | element | element == response_count_values.first}
        puts "Most common recommendation to a friends is #{most_common.capitalize}"
    end

    def self.sort_by_recommend_to_a_friend(data)
        sorted = data.sort_by { |response| FRIEND_ORDER_MAPPING[response["recommend_to_friend"]] }
        puts "Sorted by positive recommend to a friend response #{JSON.pretty_generate(sorted)}"
    end

    def self.recomendation_percentage(data)
        counts = { "yes" => 0, "maybe" => 0, "no" => 0 }
        total_num_of_recs = data.length

        data.each { |response| counts[response["recommend_to_friend"]] += 1 }

        percents = counts.map do |key, count|
            { key.to_sym => { count: count, percent: (count / total_num_of_recs.to_f) } }
        end

        sorted_percents = percents.sort_by { |item| item.values.first[:percent] }

        puts "Recommendations by percentage #{JSON.pretty_generate(sorted_percents)}"
        puts "Most common recomendation by percentage #{sorted_percents.last.keys.first.capitalize}"
    end

    # def self.identify_outliers
    # end

    # def self.percentage_
    # end
end

raw_data = ProcessSurvey.get_data

# ProcessSurvey.avg_overall_satisfaction(raw_data)
# ProcessSurvey.sort_by_satisfaction(raw_data)
# ProcessSurvey.group_by_satisfaction_and_team(raw_data)
# ProcessSurvey.recommend_to_a_friend_mode(raw_data)
# ProcessSurvey.sort_by_recommend_to_a_friend(raw_data)
ProcessSurvey.recomendation_percentage(raw_data)


