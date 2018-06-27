require 'dotenv'
Dotenv.load

require './lib/hawkeye'

class HawkeyeBot < SlackRubyBot::Bot
  def initialize
    @pid_file = "./hawkeye-bot-daemon.pid"
  end

  def run
    begin
      Process.daemon(true, true)
      open(@pid_file, 'w') { |f| f << Process.pid } if @pid_file

      SlackRubyBot.configure do |config|
        config.logger       = Logger.new("./hawkeye-bot.log", "daily")
        config.logger.level = Logger::INFO
      end
    rescue => e
      STDERR.puts "[ERROR][#{self.class.name}.daemonize] #{e}"
      exit 1
    end

    self.class.superclass.run()
  end
end

begin
  HawkeyeBot.new.run
rescue Exception => e
  STDERR.puts "ERROR: #{e}"
  raise e
end

