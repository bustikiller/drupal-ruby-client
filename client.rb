require 'io/console'
require 'httparty'
require 'cgi'
requore

class Client
    HOST = 'http://kimball.com.es'

    def login
        puts 'Username:'
        username = gets.chomp
        puts 'Password:'
        password = STDIN.noecho(&:gets).chomp

        @cookie_content = cookie_content(username, password)
    end

    private

    def cookie_content(username, password)
        response = HTTParty.post("#{HOST}/api/user/login", 
                                  headers: {"Content-Type" => 'application/json', 'X-CSRF-Token' => token}, 
                                  body: {username: username, password: password}.to_json)
        CGI::Cookie.parse(response.headers['set-cookie']).first.flatten.join('=')
    end

    def token
        HTTParty.post("#{HOST}/services/session/token", 
                      headers: {"Content-Type" => "application/json"})
    end
end