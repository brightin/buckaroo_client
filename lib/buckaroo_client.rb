require 'buckaroo_client/gateway'
require 'buckaroo_client/service'
require 'buckaroo_client/transaction'
require 'buckaroo_client/version'

module BuckarooClient
  DEFAULT_TRANSACTION_ATTRIBUTES = {
    websitekey: ENV['BUCKAROO_CLIENT_WEBSITEKEY']
  }

  def self.gateway
    Gateway::NVP
  end

  def self.batch(attributes = {})
    Gateway::Batch.new(attributes)
  end

  def self.transaction(attributes = {})
    Transaction.new(DEFAULT_TRANSACTION_ATTRIBUTES.merge(attributes))
  end

  def self.service(name, attributes = {})
    case name.to_s
    when 'credit_management'
      Service::CreditManagement.new
    when 'invoice_specification'
      Service::InvoiceSpecification.new
    when 'pay_per_email'
      Service::PayPerEmail.new(attributes)
    else
      raise ArgumentError.new("service '#{name}' does not exist")
    end
  end
end
