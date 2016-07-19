require "sqstail/version"

require 'thor'
require 'aws-sdk'
require 'pp'
require 'json'

module SQSTail
  # Your code goes here...
  class CLI < Thor
    desc 'version', 'displays the application version'
    def version
      puts "sqstail #{SQSTail::VERSION}"
    end
  
    desc 'queue URL', 'polls and displays messages for SQS queue at URL'
    def queue(url)
      poller = Aws::SQS::QueuePoller.new(url)
      poller.poll(visibility_timeout: 0) do |sqsmessage|
        body = ""
        begin
          body = "[json] #{JSON.parse(sqsmessage.body)}"
        rescue Exception => e
          # could not parse as json. fall through
          body = "[raw] #{sqsmessage.body}"
        end
        puts "#{Time.now} #{body}"
      end
    end
  end
end
