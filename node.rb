require_relative 'parser'

class Node

    FIELD_PREFIX = 'field_'

    def initialize(params)
        @nid = params['nid']
        @type = params['type']
        @title = params['title']
        @deep_load = false
    end

    def deep_load!
        if !@deep_load
            params = Client.instance.deep_load(nid: @nid)
            fields = params.select{|k, _| k.start_with? FIELD_PREFIX}

            fields.each{|k, v| process_field(k, v)}
            @deep_load = true
        end
        return self
    end

    private

    def process_field(key, value)
        field_name = key.sub FIELD_PREFIX, ''
        field_value = Parsers::Parser.parse(value)

        instance_variable_set "@#{field_name}", field_value
        self.class.attr_accessor field_name.to_sym
    end
end