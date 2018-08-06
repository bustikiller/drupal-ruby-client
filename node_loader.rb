module NodeLoader
    require_relative 'node'
    HOST = 'http://kimball.com.es'

    def load(type:)
        with_pagination do |page|
            HTTParty.get("#{HOST}/api/node?parameters[type]=#{type}&page=#{page}", 
                         headers: headers)
            .map{|result| Node.new(result)}
        end
    end

    def deep_load(nid:)
        HTTParty.get("#{HOST}/api/node/#{nid}", headers: headers)
    end

    private

    def headers
        {
            'Content-Type' => 'application/json', 
            'Cookie' => @cookie_content
        }
    end

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