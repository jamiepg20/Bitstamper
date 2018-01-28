RSpec.configure do |config|
  config.before(:each) do
    # The famous singleton problem
    Bitstamper.configure do |config|
      config.key = nil
      config.secret = nil
      config.client_id = nil
    end
  end
end

require "yaml"

def setup_bitstamper(type = :full)
  cfg_path              =   File.join(File.dirname(__FILE__), "../../credentials.yml")
  
  if ::File.exists?(cfg_path)
    cfg                 =   YAML.load_file(cfg_path).fetch("#{type}_permissions", {})

    Bitstamper.configure do |config|
      config.key        =   cfg["key"]
      config.secret     =   cfg["secret"]
      config.client_id  =   cfg["client_id"]
  
      config.faraday    =   {
        user_agent: "Bitstamp Ruby",
        verbose:    false
      }
    end
  else
    raise "Missing credentials.yml file - you need to create one and include key, secret, and client_id in order to run specs for private API endpoints."
  end
end
