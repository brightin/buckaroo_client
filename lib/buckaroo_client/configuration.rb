module BuckarooClient
  class Configuration
    attr_accessor :websitekey, :secret
    attr_writer :environment

    def initialize(args = {})
      self.websitekey = args.fetch(:websitekey, ENV['BUCKAROO_CLIENT_WEBSITEKEY'])
      self.secret = args.fetch(:secret, ENV['BUCKAROO_CLIENT_SECRET'])
      self.environment = args.fetch(:environment, ENV['BUCKAROO_CLIENT_ENVIRONMENT'])
    end

    def environment
      @environment ||= 'test'
    end
  end
end
