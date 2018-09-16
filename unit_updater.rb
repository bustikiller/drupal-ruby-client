require_relative 'client'
require 'io/console'
require 'pry'

puts 'Username:'
username = gets.chomp
puts 'Password:'
password = STDIN.noecho(&:gets).chomp

educandos = Client.instance.login(username, password, 'https://kimball.com.es').load(type: :educando)

educandos.each do |e|
    begin
        e.deep_load!
        parsed_date = e.raw.dig('field_fecha_de_nacimiento', 'und', 0, 'value')
        unless parsed_date
            puts "skipping node #{e.nid} because it does not have birth date"
            next
        end
        age = DateTime.now.year - Date.parse(parsed_date).year

        unit_id = case(age)
                    when 6..7
                        1
                    when 8..10
                        2
                    when 11..13
                        3
                    when 14..16
                        4
                    when 17..100
                        5
                    end
        unless unit_id
            puts "Skipping node #{e.nid} because it does not match any unit"
            next
        end

        e.raw['field_unidad']['und'].first['tid'] = unit_id.to_s
        puts "Child #{e.title} (#{e.nid}) was changed to unit #{unit_id}"
        e.save
    rescue StandardError => err
        puts "Error updating unit for node #{e.nid}. #{err.message}"
    end
end

