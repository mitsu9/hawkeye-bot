module Hawkeye
  module Commands
    class Trend < SlackRubyBot::Commands::Base
      command 'trend' do |client, data, match|
        client.say(channel: data.channel, text: "GitHubからTrending情報を取得中...")
        params = match[3].split
        trends = Hawkeye::Helper::GithubHelper.trending(params.at(0), params.at(1))
        message = ""
        trends.each_with_index do |trend, idx|
          message += "#{idx+1} : #{trend[:repo]} -> #{trend[:summary]}\n"
          message += "#{trend[:link]}\n"
        end
        trending_url = Hawkeye::Helper::GithubHelper.trending_url(params.at(0), params.at(1))
        message += "More detail => #{trending_url}"
        client.say(channel: data.channel, text: message)
      end
    end
  end
end
