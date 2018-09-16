require_relative 'client'
require 'io/console'
require 'pry'

puts 'Username:'
username = gets.chomp
puts 'Password:'
password = STDIN.noecho(&:gets).chomp

educandos = Client.instance.login(username, password, 'https://kimball.com.es').load(type: :educando)
e = educandos.first.deep_load!
binding.pry