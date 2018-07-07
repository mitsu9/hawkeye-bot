module Hawkeye
  module Commands
    class Echo < SlackRubyBot::Commands::Base
      command 'echo' do |client, data, _match|
        client.say(channel: data.channel, text: 'hello')
      end
    end
  end
end
