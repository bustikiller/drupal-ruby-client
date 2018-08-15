require_relative 'client'
require 'io/console'
require 'pry'

puts 'Username:'
username = gets.chomp
puts 'Password:'
password = STDIN.noecho(&:gets).chomp

actas = Client.instance.login(username, password).load(type: :acta)