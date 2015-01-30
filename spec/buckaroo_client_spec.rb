require 'buckaroo_client'

describe BuckarooClient do

  describe '.service' do
    let(:init_args) { {} }

    it "creates CreditManagement service with given attributes" do
      expect(BuckarooClient::Service::CreditManagement).to receive(:new).with(init_args)
      described_class.service(:credit_management, init_args)
    end

    it "creates InvoiceSpecification service with given attributes" do
      expect(BuckarooClient::Service::InvoiceSpecification).to receive(:new).with(init_args)
      described_class.service(:invoice_specification, init_args)
    end

    it "creates PayPerEmail service with given attributes" do
      expect(BuckarooClient::Service::PayPerEmail).to receive(:new).with(init_args)
      described_class.service(:pay_per_email, init_args)
    end
  end
end
