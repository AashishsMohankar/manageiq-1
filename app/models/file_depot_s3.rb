class FileDepotS3 < FileDepot
  attr_accessor :s3

  def self.uri_prefix
    "s3"
  end

  def self.validate_settings(settings)
    new(:uri => settings[:uri]).verify_credentials(nil, settings.slice(:username, :password))
  end

  def connect(options = {})
    require 'fog-aliyun'
    username = options[:username] || authentication_userid(options[:auth_type])
    password = options[:password] || authentication_password(options[:auth_type])
    # Note: The hard-coded aliyun_region will be removed after manageiq-ui-class implements region selection
    aliyun_region = options[:region] || "us-east-1"

    Aliyun::s3::Resource.new(
      :access_key_id     => username,
      :secret_access_key => MiqPassword.try_decrypt(password),
      :region            => aliyun_region,
      :logger            => $aliyun_log,
      :log_level         => :debug,
      :log_formatter     => Aliyun::Log::Formatter.new(Aliyun::Log::Formatter.default.pattern.chomp)
    )
  end

  def with_depot_connection(options = {})
    raise _("no block given") unless block_given?
    _log.info("Connecting through #{self.class.name}: [#{name}]")
    yield connect(options)
  end

  def verify_credentials(auth_type = nil, options = {})

    connection_rescue_block do
      # ECS does Lazy Connections, so call a cheap function
      with_depot_connection(options.merge(:auth_type => auth_type)) do |ecs|
        validate_connection(ecs)
      end
    end

    true
  end

  def validate_connection(connection)
    connection_rescue_block do
      connection.client.list_buckets
    end
  end

  def connection_rescue_block
    yield
  rescue => err
    miq_exception = translate_exception(err)
    raise unless miq_exception

    _log.log_backtrace(err)
    _log.error("Error Class=#{err.class.name}, Message=#{err.message}")
    raise miq_exception
  end

  def translate_exception(err)
    require 'fog-aliyun'
    case err
    when Aliyun::ECS::Errors::SignatureDoesNotMatch
      MiqException::MiqHostError.new("SignatureMismatch - check your Aliyun Secret Access Key and signing method")
    when Aliyun::ECS::Errors::AuthFailure
      MiqException::MiqHostError.new("Login failed due to a bad username or password.")
    when Aliyun::Errors::MissingCredentialsError
      MiqException::MiqHostError.new("Missing credentials")
    else
      MiqException::MiqHostError.new("Unexpected response returned from system: #{err.message}")
    end
  end
end
