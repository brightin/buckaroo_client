require 'buckaroo_client/service/invoice_specification'

describe BuckarooClient::Service::InvoiceSpecification do

  def invoice_line_attributes(opts = {})
    {
      description: 'your description',
      currency: '€',
      amount: '10.00',
      tax: '2.10',
      numberofunits: '1',
      unitprice: '10.00',
      unitname: 'unit1'
    }.merge(opts)
  end

  describe '#initialize' do
    it 'allows empty attributes Hash to be passed in' do
      expect { described_class.new({}) }.not_to raise_error
    end

    it 'raises error on invalid attributes' do
      expect { described_class.new(invalid_name: 'Some Text') }.to raise_error(NoMethodError)
    end
  end

  describe 'servicecode' do
    it 'defaults to InvoiceSpecification' do
      expect(subject.servicecode).to eq 'InvoiceSpecification'
    end
  end

  describe 'action' do
    it 'defaults to ExtraInfo' do
      expect(subject.action).to eq 'ExtraInfo'
    end
  end

  describe 'gateway_attributes' do
    it 'produces valid output' do
      subject.add_invoice_line invoice_line_attributes
      subject.add_invoice_line invoice_line_attributes
      subject.add_sub_total_line invoice_line_attributes
      subject.add_total_line invoice_line_attributes
      expect(subject.gateway_attributes).to eq({
        'service_InvoiceSpecification_action' => 'ExtraInfo',
        'service_InvoiceSpecification_InvoiceLine_1' => '1|your description|€|10.00|2.10|1|10.00|unit1',
        'service_InvoiceSpecification_InvoiceLine_2' => '2|your description|€|10.00|2.10|1|10.00|unit1',
        'service_InvoiceSpecification_SubTotalLine_1' => '3|your description|€|10.00|2.10|1|10.00|unit1',
        'service_InvoiceSpecification_TotalLine_1' => '4|your description|€|10.00|2.10|1|10.00|unit1',
      })
    end
  end
end
