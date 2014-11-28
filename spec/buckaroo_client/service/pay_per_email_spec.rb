require 'buckaroo_client/service/pay_per_email'

describe BuckarooClient::Service::PayPerEmail do

  describe 'servicecode' do
    it 'defaults to payperemail' do
      expect(subject.servicecode).to eq 'payperemail'
    end
  end

  describe 'action' do
    it 'defaults to paymentinvitation' do
      expect(subject.action).to eq 'paymentinvitation'
    end
  end

  describe 'customergender' do
    it 'defaults to 0: Unknown' do
      expect(subject.customergender).to eq 0
    end
  end

  describe 'customeremail' do

  end

  describe 'customerfirstname' do

  end

  describe 'customerlastname' do

  end

  describe 'merchantsendsemail' do
    it 'defaults to FALSE' do
      expect(subject.merchantsendsemail).to eq false
    end
  end

  describe 'paymentmethodsallowed' do

  end

  describe 'expirationdate' do

  end

  describe 'gateway_attributes' do
    it 'produces valid output' do
      subject.customeremail = 'a'
      subject.customerfirstname = 'b'
      subject.customerlastname = 'c'
      subject.paymentmethodsallowed = nil
      subject.expirationdate = 'e'
      expect(subject.gateway_attributes).to eq({
        'service_payperemail_action' => 'paymentinvitation',
        'service_payperemail_customergender' => '0', # Check for String conversion
        'service_payperemail_customeremail' => 'a',
        'service_payperemail_customerfirstname' => 'b',
        'service_payperemail_customerlastname' => 'c',
        'service_payperemail_merchantsendsemail' => 'FALSE', # Check for uppercase String conversion
        # Check that paymentmethodsallowed is excluded (nil values should be left out)
        'service_payperemail_expirationdate' => 'e'
      })
    end
  end
end
