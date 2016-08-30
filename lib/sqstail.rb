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
    option :delete_messages, type: :boolean, aliases: :d, default: false
    def queue(url)
      poller = Aws::SQS::QueuePoller.new(url)
      skip_delete = !options[:delete_messages]
      poller.poll(visibility_timeout: 0, skip_delete: skip_delete) do |sqsmessage|
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
