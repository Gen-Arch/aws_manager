require 'aws-sdk-dynamodb'

class DynamoDB
  def initialize(table, profile)
    @config = {region: 'ap-northeast-1', profile: profile}
    @client = Aws::DynamoDB::Resource.new(@config)
    @table  = @client.table(table)
    @items  = items
  end

  def item()
    @table.get_item(query)
  end

  def periods?(name)
    @items.find{|item| item['name'] == name }
  end

  def time?(name)
    time = { begintime: '', endtime: ''}

    return time unless name
    return time if name =~ /^x-/
    item = periods?(name)
    item = periods?(item['periods'].first) if item['type'] == 'schedule'

    time[:begintime] = item['begintime']
    time[:endtime]   = item['endtime']

    return time
  end

  def items
    scan_output = @table.scan({
      select: "ALL_ATTRIBUTES"
    })

    scan_output.items
  end
end
