require_relative 'node'
require_relative 'request_helper'

module NodeLoader
    
    include RequestHelper

    def load(type:)
        with_pagination do |page|
            HTTParty.get("#{@host}/api/views/last_updates?display_id=services_1&page=#{page}&type=#{type}", 
                         headers: headers)
            .map{|result| Node.new(result)}
        end
    end

    def deep_load(nid:)
        HTTParty.get("#{@host}/api/node/#{nid}", headers: headers).parsed_response
    end

    private

    def with_pagination
        page = 0
        all_results = []
        loop do
            results = yield(page)
            all_results += results
            page += 1
            break if results.empty?
        end
        all_results
    end
end