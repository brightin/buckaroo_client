require 'buckaroo_client'

describe BuckarooClient do

  describe '.transaction' do

    subject(:transaction) { described_class.transaction }

    it 'returns an object implementing Transaction interface' do
      expect(subject).to respond_to(:invoicenumber=)
      expect(subject).to respond_to(:amount=)
      expect(subject).to respond_to(:description=)
      expect(subject).to respond_to(:select_service)
      expect(subject).to respond_to(:select_additional_service)
    end

  end

  describe '.gateway' do

    subject(:gateway) { described_class.gateway }

    it 'returns an object implementing NVP service operations' do
      expect(gateway).to respond_to(:transaction_request)
      expect(gateway).to respond_to(:transaction_status)
      expect(gateway).to respond_to(:invoice_info)
      expect(gateway).to respond_to(:refund_info)
      expect(gateway).to respond_to(:transaction_request_specification)
      expect(gateway).to respond_to(:cancel_transaction)
    end

  end

end
