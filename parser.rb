module Parsers
    class Parser
        def self.parse(raw_node)
            raw_node = raw_node['und'] if raw_node.is_a?(Hash)
            parsed_value = raw_node.map{ |value| process_field(value) }

            return parsed_value.first if parsed_value.size == 1
            parsed_value
        end

        def self.process_field(field)
            return DateTime.parse(field['value']) if field.keys.include?('timezone')
            return field['uri'] if field.keys.include?('filename')
            return field['safe_value'] if field.keys.include?('safe_value')
            return field['email'] if field.keys.include?('email')
            return field['value'] if field.keys == ['value']
            return if field.keys == ['tid']
        end
    end
end