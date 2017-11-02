require 'buckaroo_client/service/credit_management'

describe BuckarooClient::Service::CreditManagement do

  describe '#initialize' do
    it 'sets attributes given' do
      object = described_class.new(company_name: 'Bedrijf')
      expect(object.company_name).to eq 'Bedrijf'
    end

    it 'raises error on invalid attributes' do
      expect { described_class.new(invalid_name: 'Some Text') }.to raise_error(NoMethodError)
    end
  end

  describe '#servicecode' do
    it 'defaults to creditmanagement' do
      expect(subject.servicecode).to eq 'creditmanagement'
    end
  end

  describe '#action' do
    it 'defaults to invoice' do
      expect(subject.action).to eq 'invoice'
    end
  end

  context '"invoice" action' do
    describe '#gateway_attributes' do

      it 'prefixes "action" attribute' do
        expect(subject.gateway_attributes['service_creditmanagement_action']).to eq 'invoice'
      end

      it 'converts Boolean attributes to uppercase String' do
        subject.company_vat_applicable = true
        expect(subject.gateway_attributes['Service_creditmanagement3_Company_VatApplicable']).to eq 'TRUE'
      end

      it 'filters out nil values' do
        expect(subject.company_name).to be_nil
        expect(subject.gateway_attributes).not_to have_key('service_creditmanagement_CompanyName')
      end

    end
  end

  context '"creditnote" action' do
    pending 'not yet implemented'
  end

end
