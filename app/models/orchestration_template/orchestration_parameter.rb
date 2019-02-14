class OrchestrationTemplate
  class OrchestrationParameter
    #  Aliyun CloudFormation data types
    #      String
    #      Number
    #      List<Number>
    #      CommaDelimitedList
    #      Aliyun::ECS::KeyPair::KeyName
    #      Aliyun::ECS::SecurityGroup::Id
    #      Aliyun::ECS::Subnet::Id
    #      Aliyun::ECS::VPC::Id
    #      List<Aliyun::ECS::VPC::Id>
    #      List<Aliyun::ECS::SecurityGroup::Id>
    #      List<Aliyun::ECS::Subnet::Id>
    #
    # OpenStack HOT data types
    #      string
    #      number
    #      json
    #      comma_delimited_list
    #      boolean

    attr_accessor :name
    attr_accessor :label
    attr_accessor :description
    attr_accessor :data_type
    attr_accessor :default_value
    attr_accessor :hidden
    attr_accessor :required
    attr_accessor :reconfigurable
    attr_writer   :constraints

    def initialize(hash = {})
      @reconfigurable = true
      hash.each { |key, value| public_send("#{key}=", value) }
    end

    def constraints
      @constraints ||= []
    end

    def hidden?
      !!hidden
    end

    def required?
      !!required
    end
  end
end
