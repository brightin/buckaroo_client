require 'buckaroo_client/gateway/nvp'
require 'dotenv'

describe BuckarooClient::Gateway::NVP do

  before :all do
    Dotenv.load
    ENV['BUCKAROO_CLIENT_WEBSITEKEY'] || raise("Please set BUCKAROO_CLIENT_WEBSITEKEY ENV variable")
    ENV['BUCKAROO_CLIENT_SECRET'] || raise("Please set BUCKAROO_CLIENT_SECRET ENV variable")
  end

  def random_invoice_number
    "TEST#{rand(100000000000000000000000000)}"
  end

  TRANSACTION_REQUEST_ATTRIBUTES = {
    'channel' => 'BACKOFFICE',
    'payment_method' => 'payperemail',
    'amount' => '99.99',
    'currency' => 'EUR',
    'culture' => 'nl-NL',
    'invoicenumber' => '0000',
    'description' => 'Test payperemail transaction',
    'service_payperemail_action' => 'paymentinvitation',
    'service_payperemail_customergender' => '1',
    'service_payperemail_customeremail' => 'example@example.com',
    'service_payperemail_customerfirstname' => 'Cus',
    # Set value below to TRUE to skip sending e-mails.
    # Otherwise, Buckaroo sends an actual mail for test transactions.
    'service_payperemail_merchantsendsemail' => 'TRUE',
    'service_payperemail_customerlastname' => 'Tomer'
  }

  INVOICE_INFO_ATTRIBUTES = {
    'invoicenumber' => '0000'
  }

  INVOICE_REQUEST_ATTRIBUTES = {
    "brq_amount" =>  '120.9978',
    "brq_culture" => "nl-NL",
    "brq_currency" => "EUR",
    "brq_description" => "Testfactuur",
    # Don't use hard-coded invoicenumber, let spec generate random one.
    # Buckaroo rejects duplicate invoicenumbers for Credit Management invoices.
    # "brq_invoicenumber" => "123467898",
    "brq_service" => "payperemail",
    "brq_service_payperemail_action" => "paymentinvitation",
    "brq_service_payperemail_customergender" => "9",
    "brq_service_payperemail_customeremail" => 'example@example.com',
    "brq_service_payperemail_customerfirstname" => "Cus",
    "brq_service_payperemail_customerlastname" => "Tomer",
    # Set value below to TRUE to skip sending e-mails.
    # Otherwise, Buckaroo sends an actual mail for test transactions.
    "brq_service_payperemail_merchantsendsemail" => "TRUE",
    # "brq_service_payperemail_paymentmethodsallowed" => nil,
    # "brq_service_payperemail_expirationdate" => nil,

    "brq_additional_service" => "creditmanagement,invoicespecification",

    "brq_service_InvoiceSpecification_action" => "ExtraInfo",
    "brq_service_InvoiceSpecification_InvoiceLine_1" =>
      "1|Factuurregelomschrijving|€|99.99|20.9979|||",
    "brq_service_InvoiceSpecification_SubTotalLine_1" =>
      "2|Totaal exclusief BTW|€|99.99||||",
    "brq_service_InvoiceSpecification_InvoiceLine_2" =>
      "3|Totaal BTW|€|20.9979||||",
    "brq_service_InvoiceSpecification_TotalLine_1" =>
      "4|Totaal inclusief BTW|€|120.9879||||",

    "brq_service_creditmanagement_action" => "invoice",
    "brq_InvoiceDate" => Date.today.to_s,
    "brq_DateDue" => Date.today.next_day(14).to_s,
    "brq_AmountVat" => "20.9979",
    "brq_service_creditmanagement_MaxReminderLevel" => "3",
    # "brq_service_creditmanagement_PaymentMethodsAllowed" => "",
    "brq_CustomerType" => "2",
    "brq_CustomerCode" => "14342",
    "brq_CustomerTitle" => "",
    "brq_CustomerInitials" => "",
    "brq_CustomerFirstName" => "Cus",
    "brq_CustomerLastNamePrefix" => "",
    "brq_CustomerLastName" => "Tomer",
    "brq_CustomerGender" => "9",
    "brq_service_creditmanagement_CustomerBirthDate" => "",
    "brq_CustomerEmail" => "example@example.com",
    "brq_PhoneNumber" => "+31999999999",
    "brq_MobilePhoneNumber" => "",
    "brq_FaxNumber" => "",
    "brq_Address_Street_1" => "Straatlaan",
    "brq_Address_HouseNumber_1" => "999",
    "brq_Address_HouseNumberSuffix_1" => "",
    "brq_Address_ZipCode_1" => "9999 ZZ",
    "brq_Address_City_1" => "Stad",
    "brq_Address_State_1" => "",
    "brq_Address_Country_1" => "NL",
    "brq_service_creditmanagement_CustomerAccountNumber" => "",
    "brq_service_creditmanagement_CompanyName" => "Organization1",
    "brq_service_creditmanagement_CompanyCOCRegistration" => "A99",
    "brq_service_creditmanagement_CompanyVATApplicable" => "TRUE"
  }

  describe '.websitekey' do
    it 'raises error if not set' do
      old_value = ENV.delete('BUCKAROO_CLIENT_WEBSITEKEY')
      expect { described_class.websitekey }.to raise_error
      ENV['BUCKAROO_CLIENT_WEBSITEKEY'] = old_value
    end
  end

  describe '.secret_key' do
    it 'raises error if not set' do
      old_value = ENV.delete('BUCKAROO_CLIENT_SECRET')
      expect { described_class.secret_key }.to raise_error
      ENV['BUCKAROO_CLIENT_SECRET'] = old_value
    end
  end

  describe '.url' do
    it 'defaults to test location' do
      expect(ENV['BUCKAROO_CLIENT_ENVIRONMENT']).to eq nil
      expect(described_class.url.to_s).to eq 'https://testcheckout.buckaroo.nl/nvp/'
    end

    it 'returns live location if live mode enabled' do
      expect(ENV['BUCKAROO_CLIENT_ENVIRONMENT']).to eq nil
      ENV['BUCKAROO_CLIENT_ENVIRONMENT'] = 'production'
      expect(described_class.url.to_s).to eq 'https://checkout.buckaroo.nl/nvp/'
      ENV.delete('BUCKAROO_CLIENT_ENVIRONMENT')
    end
  end

  describe '.transaction_request' do
    it 'returns a success response' do
      response = described_class.transaction_request(TRANSACTION_REQUEST_ATTRIBUTES)
      # Success response code for PayPerEmail: 792 Awaiting Consumer
      expect(response.body).to include('BRQ_STATUSCODE=792')
      expect(response.verified?).to eq true
      expect(response.success).to eq true
    end

    it 'returns success for valid PayPerEmail request with InvoiceSpecification and CreditManagement' do
      variables = INVOICE_REQUEST_ATTRIBUTES.merge('brq_invoicenumber' => random_invoice_number)
      response = described_class.transaction_request(variables)
      # Success response code for PayPerEmail: 792 Awaiting Consumer
      expect(response.body).to include('BRQ_STATUSCODE=792')
      expect(response.verified?).to eq true
      expect(response.success).to eq true
    end
  end

  describe '.transaction_status' do
    pending 'not yet implemented'
  end

  describe '.invoice_info' do
    it 'returns a success response for an existing transaction' do
      described_class.transaction_request(TRANSACTION_REQUEST_ATTRIBUTES)
      response = described_class.invoice_info(INVOICE_INFO_ATTRIBUTES)
      expect(response.body).to include('BRQ_APIRESULT=Success')
    end
  end

  describe '.transaction_request_specification' do
    it 'returns a succesful response' do
      params = {
        'channel' => 'BACKOFFICE',
        'services' => 'payperemail'
      }
      response = described_class.transaction_request_specification(params)
      expect(response.body).to include('BRQ_APIRESULT=Success')
    end
  end
end
