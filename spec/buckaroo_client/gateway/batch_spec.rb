require 'buckaroo_client/gateway/batch'

describe BuckarooClient::Gateway::Batch do
  INPUT_HASH = {
    'websitekey' => 'xxx',
    'amount' => '10.00',
    'culture' => 'nl-NL',
    'currency' => 'EUR',
    'description' => 'test PPE 1',
    'invoicenumber' => 'test01923r4a1',
    'service' => 'payperemail',
    'service_payperemail_action' => 'paymentinvitation',
    'service_payperemail_customergender' => '1',
    'service_payperemail_customeremail' => 'support@buckaroo.nl',
    'service_payperemail_customerfirstname' => 'test',
    'service_payperemail_customerlastname' => 'Tester',
    'service_payperemail_merchantsendsemail' => 'FALSE',
    'service_payperemail_paymentmethodsallowed' => 'ideal;transfer',
    'service_payperemail_expirationdate' => '13-1-2012'
  }
  OUTPUT_CSV = <<CSV
websitekey;amount;culture;currency;description;invoicenumber;service;service_payperemail_action;service_payperemail_customergender;service_payperemail_customeremail;service_payperemail_customerfirstname;service_payperemail_customerlastname;service_payperemail_merchantsendsemail;service_payperemail_paymentmethodsallowed;service_payperemail_expirationdate
xxx;10.00;nl-NL;EUR;test PPE 1;test01923r4a1;payperemail;paymentinvitation;1;support@buckaroo.nl;test;Tester;FALSE;"ideal;transfer";13-1-2012
CSV

  describe '#size' do
    it 'defaults to 0' do
      expect(subject.size).to eq 0
    end
  end

  describe '#each' do
    it 'responds to method' do
      expect { subject.each }.not_to raise_error
    end
  end

  describe '<<' do
    it 'stores object in transactions' do
      expect(subject.size).to eq 0
      mock_transaction = double()
      subject << mock_transaction
      expect(subject.size).to eq 1
    end
  end

  describe '#to_csv' do
    it 'converts Gateway-prepared data to valid CSV output' do
      subject << double(gateway_attributes: INPUT_HASH)
      expect(subject.to_csv).to eq OUTPUT_CSV
    end
  end

end
