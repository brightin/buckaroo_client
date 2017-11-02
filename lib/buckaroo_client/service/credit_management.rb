module BuckarooClient
  module Service
    class CreditManagement

      # Source: Credit Management BPE 3.0 documentation v1.03
      # Some values need 'service_creditmanagement_' prefix, some don't.
      # This is based on trail-and-error and example request as given in
      # document "Bestand aanbieden in BPE 3.0" v2.14 on page 16.
      ATTRIBUTE_MAPPING = {
        invoice_date: 'Service_creditmanagement3_InvoiceDate',
        date_due: 'Service_creditmanagement3_DueDate',
        amount_vat: 'Service_creditmanagement3_InvoiceAmountVat',
        max_reminder_level: 'Service_creditmanagement3_MaxStepIndex',
        payment_methods_allowed: 'Service_creditmanagement3_AllowedServices',
        customer_type: 'CustomerType', # Deleted
        customer_code: 'Service_creditmanagement3_Debtor_Code',
        customer_title: 'Service_creditmanagement3_Person_Title',
        customer_initials: 'Service_creditmanagement3_Person_Initials',
        customer_first_name: 'Service_creditmanagement3_Person_FirstName',
        customer_last_name_prefix: 'Service_creditmanagement3_Person_LastNamePrefix',
        customer_last_name: 'Service_creditmanagement3_Person_LastName',
        customer_gender: 'Service_creditmanagement3_Person_Gender',
        customer_birth_date: 'Service_creditmanagement3_Person_BirthDate',
        customer_email: 'Service_creditmanagement3_Email_Email',
        phone_number: 'Service_creditmanagement3_Phone_Landline',
        mobile_phone_number: 'Service_creditmanagement3_Phone_Mobile',
        fax_number: 'Service_creditmanagement3_Phone_Fax',
        street: 'Service_creditmanagement3_Address_Street',
        house_number: 'Service_creditmanagement3_Address_HouseNumber',
        house_number_suffix: 'Service_creditmanagement3_Address_HouseNumberSuffix',
        zip_code: 'Service_creditmanagement3_Address_Zipcode',
        city: 'Service_creditmanagement3_Address_City',
        state: 'Service_creditmanagement3_Address_State',
        country: 'Service_creditmanagement3_Address_Country',
        customer_account_number: 'service_creditmanagement_CustomerAccountNumber', # deleted in new API
        company_name: 'Service_creditmanagement3_Company_Name',
        company_coc_registration: 'Service_creditmanagement3_Company_ COCRegistration', # deleted?
        company_vat_applicable: 'Service_creditmanagement3_Company_VatApplicable',
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
