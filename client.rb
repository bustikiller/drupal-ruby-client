require 'httparty'
require 'cgi'
require 'singleton'

require_relative 'node_loader'
require_relative 'node_saver'

class Client
    include Singleton
    include NodeLoader
    include NodeSaver

    def login(username, password, host)
        @host = host
        @cookie_content = cookie_content(username, password) unless @cookie_content
        self
    end

    def cookie_content(username, password)
        response = HTTParty.post("#{@host}/api/user/login", 
                                  headers: {"Content-Type" => 'application/json', 'X-CSRF-Token' => token}, 
                                  body: {username: username, password: password}.to_json)
        CGI::Cookie.parse(response.headers['set-cookie']).first.flatten.join('=')
    end

    def token
        @token || renew_token
    end

    def renew_token
        @token = HTTParty.post("#{@host}/services/session/token", headers: headers)
    end
end