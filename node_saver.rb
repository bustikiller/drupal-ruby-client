require_relative 'node'
require_relative 'request_helper'

module NodeSaver
    include RequestHelper

    def save(node)
        return unless node.deep_load?

        fix_og_parameter node
        fix_date_fields node

        renew_token

        response = HTTParty.put("#{@host}/api/node/#{node.nid}", body: node.raw.to_json, headers: headers)
        response.success?
    end

    private

    def fix_og_parameter(node)
        node.raw['og_group_ref']['und'] = node.raw['og_group_ref']['und'][0]['target_id']
    end

    def fix_date_fields(node)
        date_fields = node.raw.select{|k, v| v.is_a?(Hash) && v['und'].is_a?(Array) && v['und'].first['date_type']}
        date_fields.each do |k, v|
            parsed_date = Date.parse(v['und'][0]['value']).strftime('%m/%d/%Y')
            node.raw[k] = {'und' => [{'value' => {'date' => parsed_date }}]}    
        end
    end
end