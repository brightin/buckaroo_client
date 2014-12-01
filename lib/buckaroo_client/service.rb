require 'buckaroo_client/service/credit_management'
require 'buckaroo_client/service/invoice_specification'
require 'buckaroo_client/service/pay_per_email'

module BuckarooClient
  module Service
    def self.from_key(key, attributes = {})
      case key.to_s
      when 'credit_management'
        Service::CreditManagement.new
      when 'invoice_specification'
        Service::InvoiceSpecification.new
      when 'pay_per_email'
        Service::PayPerEmail.new(attributes)
      else
        raise ArgumentError.new("service '#{key}' does not exist")
      end
    end
  end
end
