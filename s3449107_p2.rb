#!/usr/bin/ruby

require 'thor'

class SayWelcome < Thor

  desc "welcome NAME", "say welcome to NAME"
  def welcome(name)
    puts "Welcome #{name}! :)"
  end

end

SayWelcome.start(ARGV)
