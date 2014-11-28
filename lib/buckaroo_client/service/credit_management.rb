module BuckarooClient
  module Service
    class CreditManagement

      # Source: Credit Management BPE 3.0 documentation v1.03
      # Some values need 'service_creditmanagement_' prefix, some don't.
      # This is based on trail-and-error and example request as given in
      # document "Bestand aanbieden in BPE 3.0" v2.14 on page 16.
      ATTRIBUTE_MAPPING = {
        invoice_date: 'InvoiceDate',
        date_due: 'DateDue',
        amount_vat: 'AmountVat',
        max_reminder_level: 'service_creditmanagement_MaxReminderLevel',
        payment_methods_allowed: 'service_creditmanagement_PaymentMethodsAllowed',
        customer_type: 'CustomerType',
        customer_code: 'CustomerCode',
        customer_title: 'CustomerTitle',
        customer_initials: 'CustomerInitials',
        customer_first_name: 'CustomerFirstName',
        customer_last_name_prefix: 'CustomerLastNamePrefix',
        customer_last_name: 'CustomerLastName',
        customer_gender: 'CustomerGender',
        customer_birth_date: 'service_creditmanagement_CustomerBirthDate',
        customer_email: 'CustomerEmail',
        phone_number: 'PhoneNumber',
        mobile_phone_number: 'MobilePhoneNumber',
        fax_number: 'FaxNumber',
        street: 'Address_Street_1',
        house_number: 'Address_HouseNumber_1',
        house_number_suffix: 'Address_HouseNumberSuffix_1',
        zip_code: 'Address_ZipCode_1',
        city: 'Address_City_1',
        state: 'Address_State_1',
        country: 'Address_Country_1',
        customer_account_number: 'service_creditmanagement_CustomerAccountNumber',
        company_name: 'service_creditmanagement_CompanyName',
        company_coc_registration: 'service_creditmanagement_CompanyCOCRegistration',
        company_vat_applicable: 'service_creditmanagement_CompanyVATApplicable',
      }

      attr_accessor *ATTRIBUTE_MAPPING.keys

      def initialize(args = {})
        args.each do |key, value|
          self.send "#{key}=", value
        end
      end

      def servicecode
        'creditmanagement'
      end

      def action
        'invoice'
      end

      def gateway_attributes
        output = { 'service_creditmanagement_action' => action }
        ATTRIBUTE_MAPPING.each do |name, gateway_name|
          value = self.send(name)
          next if value.nil? # Ignore unspecified values to keep BuckarooClient happy
          if value == true or value == false
            value = value.to_s.upcase
          end
          output[gateway_name] = value.to_s
        end
        output
      end
    end
  end
end
