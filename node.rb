class Node

    attr_reader :nid, :type, :title, :raw
    def initialize(params)
        @nid = params['nid']
        @type = params['type']
        @title = params['title']
        @deep_load = false
        @raw = {}
    end

    def deep_load!
        if !@deep_load
            @raw = Client.instance.deep_load(nid: @nid)
            @deep_load = true
        end
        return self
    end
end