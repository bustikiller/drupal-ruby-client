module RequestHelper
    
    private

    def headers
        {
            'Content-Type' => 'application/json', 
            'Cookie' => @cookie_content, 
            'X-CSRF-Token' => @token
        }.reject{ |_, v| v.nil? }
    end
end