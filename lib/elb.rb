require 'aws-sdk-elasticloadbalancingv2'

class ELB
  def initialize(arn, profile)
    @config = {region: 'ap-northeast-1', profile: profile}
    @client = Aws::ElasticLoadBalancingV2::Client.new(@config)
  end
end