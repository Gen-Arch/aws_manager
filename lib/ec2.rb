require 'time'
require 'aws-sdk-ec2'

class EC2
  def initialize(name, profile)
    @config = {region: 'ap-northeast-1', profile: profile}
    @client = Aws::EC2::Client.new(@config)
    @hosts  = {}
    create_hosts(name)
  end

  def image(name)
    host = @hosts[name]
    resp = @client.create_image({
      name: "#{name}_#{Time.now.strftime("%Y%m%d")}",
      instance_id: host.instance_id,
      description: "aws manager",
      no_reboot: true
    })
  end

  def list
    @hosts.keys
  end

  def hosts
    @hosts.sort
  end

  def host?(ip)
    @hosts.find{ |host, i| i.private_ip_address == ip }
  end

  def filter_hosts
    @hosts.map do |host, i|
      tags = airtrip_tags(i.tags)

      {
        env:                tags[:env],
        name:               tags[:name],
        instance_id:        i.instance_id,
        public_ip_address:  i.public_ip_address,
        private_ip_address: i.private_ip_address,
        instance_type:      i.instance_type,
        subnet_id:          i.subnet_id,
        vpc_id:             i.vpc_id,
        ami_id:             i.image_id,
        device_type:        i.root_device_type,
        key_name:           i.key_name,
        group:              tags[:group],
        schdule:            tags[:schdule],
        status:             i.state.name,
      }
    end
  end

  private
  def create_hosts(query)
    ec2 = Aws::EC2::Resource.new(@config)
    ec2.instances.each do |i|
      tags = airtrip_tags(i.tags)
      name = tags[:name]

      #next unless i.state.name == "running"
      next unless name =~ /#{query}/
      @hosts[name] = i
    end
  end

  def airtrip_tags(tags)
    name    = tags.find{|t| t.key == 'Name'        }
    env     = tags.find{|t| t.key == 'Env'         }
    group   = tags.find{|t| t.key == 'ServerGroup' }
    schdule = tags.find{|t| t.key == 'Schedule'    }

    {
      name:    name    ? name.value    : name,
      env:     env     ? env.value     : env,
      group:   group   ? group.value   : group,
      schdule: schdule ? schdule.value : schdule
    }
  end
end
