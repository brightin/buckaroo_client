require 'buckaroo_client/transaction'

describe BuckarooClient::Transaction do

  describe 'websitekey' do
    it 'defaults to nil' do
      expect(subject.websitekey).to be_nil
    end
  end

  describe 'amount' do

  end

  describe 'culture' do
    it 'defaults to nl-NL' do
      expect(subject.culture).to eq 'nl-NL'
    end
  end

  describe 'currency' do
    it 'defaults to EUR' do
      expect(subject.currency).to eq 'EUR'
    end
  end

  describe 'description' do

  end

  describe 'invoicenumber' do

  end

  describe 'service=' do

  end

  describe 'service' do

  end

  describe 'additional_services' do

  end

  describe 'gateway_attributes' do
    it 'converts base attributes' do
      expect(subject.gateway_attributes).to eq({
        'websitekey' => nil,
        'amount' => nil,
        'culture' => 'nl-NL',
        'currency' => 'EUR',
        'description' => nil,
        'invoicenumber' => nil
      })
    end

    it 'uses service#gateway_attributes results' do
      subject.service = double(servicecode: 'aaa', gateway_attributes: {a: :b})
      expect(subject.gateway_attributes['service']).to eq 'aaa'
      expect(subject.gateway_attributes[:a]).to eq :b
    end

    it 'uses additional_services\' gateway_attributes results' do
      subject.additional_services << double(servicecode: 'aaa', gateway_attributes: {a: :b})
      subject.additional_services << double(servicecode: 'ccc', gateway_attributes: {c: :d})
      expect(subject.gateway_attributes['additional_service']).to eq 'aaa,ccc'
      expect(subject.gateway_attributes[:a]).to eq :b
      expect(subject.gateway_attributes[:c]).to eq :d
    end
  end
end
