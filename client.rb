require 'httparty'
require 'cgi'
require 'singleton'

require_relative 'node_loader'

class Client
    include Singleton
    include NodeLoader

    def login(username, password)0
        @cookie_content = cookie_content(username, password) unless @cookie_content
        self
    end

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