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
            reload!
            @deep_load = true
        end
        return self
    end

    def deep_load?
        !!@deep_load
    end

    def reload!
        @raw = Client.instance.deep_load(nid: @nid)
        self
    end

    def save
        raise 'Node not deep loaded' unless deep_load?
        Client.instance.save(self) && reload!
    end
end