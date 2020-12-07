require 'aws-sdk-route53'

class R53
  def initialize(zone_id, profile)
    @config  = {region: 'ap-northeast-1', profile: profile}
    @client  = Aws::Route53::Client.new(@config)
    @zone_id = zone_id
  end

  def target_list
    records = get_records

    records.map do |r|
      target = r.resource_records.first.value unless r.resource_records.empty?
      target = r.alias_target.dns_name        unless r.alias_target.nil?

      {
        name: r.name,
        target: target
      }
    end
  end

  def get_records
    records = Array.new

    zone = @client.list_resource_record_sets({
      hosted_zone_id: @zone_id,
      max_items: 1
    })
    records   = records.concat(zone.resource_record_sets)
    next_name = zone.next_record_name

    while not next_name == nil
      pp next_name
      zone = @client.list_resource_record_sets({
        hosted_zone_id: @zone_id,
        start_record_name: next_name,
        max_items: 100
      })
      records   = records.concat(zone.resource_record_sets)
      next_name = zone.next_record_name
    end

    records
  end
end
