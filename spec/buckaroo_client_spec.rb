require 'buckaroo_client'

describe BuckarooClient do
  describe '.configuration' do
    it 'returns an object' do
      expect(described_class.configuration).not_to be_nil
    end
  end

  describe '.configure' do
    it 'allows configuration setting through a block' do
      expect {
        described_class.configure do |c|
          c.websitekey = 'x'
        end
      }.not_to raise_error
      expect(described_class.configuration.websitekey).to eq 'x'
    end
  end

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
