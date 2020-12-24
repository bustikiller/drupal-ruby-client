require_relative 'node'
require_relative 'request_helper'

module NodeSaver
    include RequestHelper

    def save(node)
        return unless node.deep_load?

        copy = Marshal.load(Marshal.dump(node.raw))

        fix_og_parameter copy
        fix_date_fields copy
        fix_taxonomy_fields copy
        fix_boolean_fields copy

        renew_token

        response = HTTParty.put("#{@host}/api/node/#{node.nid}", body: copy.to_json, headers: headers)
        if response.success?
            return true
        else
            puts "Error saving node: [#{response.code}] #{response.body}"
            return false
        end
    end

    private

    def fix_og_parameter(copy)
        copy['og_group_ref']['und'] = copy['og_group_ref']['und'][0]['target_id']
    end

    def fix_date_fields(copy)
        date_fields = copy.select{|_, v| contains_attribute? v, 'date_type'}
        date_fields.each do |k, v|
            raw_date = v['und'][0]['value']
            unless raw_date.nil?
                parsed_date = parse_date(raw_date)
                copy[k] = {'und' => [{'value' => {'date' => parsed_date }}]}
            end 
        end
    end

    def parse_date(date)
        return Time.at(date.to_i).strftime('%d/%m/%Y') if date == date.to_i.to_s
        Date.parse(date).strftime('%m/%d/%Y')
    rescue ArgumentError => e
        DateTime.strptime(date,'%s')
    end

    def fix_taxonomy_fields(copy)
        taxonomy_fields = copy.select{|_, v| contains_attribute? v, 'tid'}
        taxonomy_fields.each do |k, v|
            copy[k] = {'und' => v['und'][0]['tid']}
        end
    end

    def fix_boolean_fields(copy)
        copy.select{ |_, v| v.is_a?(Hash) && v['und'].is_a?(Array) && v['und'].first['value'] == '0' }
            .keys.each{ |field| copy.delete(field) }
    end

    def contains_attribute?(v, attr_name)
        v.is_a?(Hash) && v['und'].is_a?(Array) && v['und'].first[attr_name]
    end
end