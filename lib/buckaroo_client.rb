require 'buckaroo_client/configuration'
require 'buckaroo_client/gateway'
require 'buckaroo_client/service'
require 'buckaroo_client/transaction'
require 'buckaroo_client/version'

module BuckarooClient

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.gateway
    Gateway::NVP
  end

  def self.batch(attributes = {})
    Gateway::Batch.new(attributes)
  end

  def self.transaction(attributes = {})
    Transaction.new(default_transaction_attributes.merge(attributes))
  end

  def self.service(name, attributes = {})
    case name.to_s
    when 'credit_management'
      Service::CreditManagement.new(attributes)
    when 'invoice_specification'
      Service::InvoiceSpecification.new(attributes)
    when 'pay_per_email'
      Service::PayPerEmail.new(attributes)
    else
      raise ArgumentError.new("service '#{name}' does not exist")
    end
  end

  protected

  def self.default_transaction_attributes
    {
      websitekey: configuration.websitekey
    }
  end

end
