require 'buckaroo_client/service'

module BuckarooClient
  class Transaction
    attr_accessor :websitekey, :amount, :culture, :currency, :description, :invoicenumber
    attr_accessor :service, :additional_services

    def initialize(args = {})
      @websitekey = args[:websitekey]
      @amount = args[:amount]
      @culture = args.fetch(:culture, 'nl-NL')
      @currency = args.fetch(:currency, 'EUR')
      @description = args[:description]
      @invoicenumber = args[:invoicenumber]
      @service = args[:service]
      @additional_services = args.fetch(:additional_services, [])
    end

    def select_service(key, attributes = {}, &block)
      service = Service.from_key(key, attributes)
      yield service if block_given?
      self.service = service
      service
    end

    def gateway_attributes
      output = {
        'websitekey' => websitekey,
        'amount' => amount,
        'culture' => culture,
        'currency' => currency,
        'description' => description,
        'invoicenumber' => invoicenumber,
      }
      if service
        output['service'] = service.servicecode
        output.merge!(service.gateway_attributes)
      end
      if additional_services.count > 0
        output['additional_service'] = additional_services.map(&:servicecode).join(',')
        additional_services.each do |a|
          output.merge!(a.gateway_attributes)
        end
      end
      output
    end
  end
end
