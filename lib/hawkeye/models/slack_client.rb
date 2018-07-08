require 'slack-ruby-bot'

class SlackClient
  def initialize()
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end
    @client = Slack::Web::Client.new
    @client.auth_test
  end

  def post_message(channel, message)
    @client.chat_postMessage(channel: channel, text: message, as_user: true)
  end
end