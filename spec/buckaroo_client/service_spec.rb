require 'buckaroo_client/service'

describe BuckarooClient::Service do

  describe '.from_key' do
    it 'returns an object for valid input values' do
      # Both Symbols and String should be accepted for valid keys
      expect(described_class.from_key(:pay_per_email)).not_to be_nil
      expect(described_class.from_key('pay_per_email')).not_to be_nil
      expect(described_class.from_key(:credit_management)).not_to be_nil
      expect(described_class.from_key('invoice_specification')).not_to be_nil
    end
  end

end
