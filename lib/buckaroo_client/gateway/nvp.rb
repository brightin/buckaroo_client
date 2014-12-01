require 'addressable/uri'
require 'digest/sha1'
require 'buckaroo_client/configuration'
require 'buckaroo_client/gateway/nvp/response'
require 'buckaroo_client/gateway/nvp/signature'

module BuckarooClient
  module Gateway
    module NVP
      extend Signature

      def self.websitekey
        @websitekey ||= BuckarooClient.configuration.websitekey
      end

      def self.environment
        @environment ||= BuckarooClient.configuration.environment
      end

      def self.url(action: nil)
        path = case environment
          when 'production'
            'https://checkout.buckaroo.nl/nvp/'
          else
            'https://testcheckout.buckaroo.nl/nvp/'
          end
        path += "?op=#{action}" unless action.nil?
        URI.parse(path)
      end

      def self.transaction_request(buckaroo_variables, custom: {}, additional: {})
        do_request('transactionrequest', buckaroo_variables, custom, additional)
      end

      def self.transaction_status(buckaroo_variables, custom: {}, additional: {})
        do_request('transactionstatus', buckaroo_variables, custom, additional)
      end

      def self.invoice_info(buckaroo_variables, custom: {}, additional: {})
        do_request('invoiceinfo', buckaroo_variables, custom, additional)
      end

      def self.transaction_request_specification(buckaroo_variables, custom: {}, additional: {})
        do_request('transactionrequestspecification', buckaroo_variables, custom, additional)
      end

      private

      def self.do_request(action, buckaroo_variables, custom = {}, additional = {})
        nvp_data = prefixed_and_signed_request_data(buckaroo_variables, custom, additional)
        raise 'websitekey missing' unless nvp_data['brq_websitekey']
        Response.for_action(action, post_data(action, nvp_data))
      end

      def self.post_data(action, data)
        Net::HTTP.post_form(url(action: action), data)
      end

      def self.prefixed_and_signed_request_data(buckaroo, custom, additional)
        output = prefix_if_needed(data: buckaroo, prefix: 'brq_')
        output.merge!(prefix_if_needed(data: custom, prefix: 'cust_'))
        output.merge!(prefix_if_needed(data: additional, prefix: 'add_'))
        output['brq_websitekey'] ||= websitekey
        if output.key?('brq_service')
          output['brq_payment_method'] = output.delete('brq_service')
        end
        sign!(output)
        return output
      end

      def self.prefix_if_needed(prefix:, data:)
        output = {}
        data.each do |key, value|
          prefixed_key = key.to_s.index(prefix) == 0 ? key : "#{prefix}#{key}"
          output[prefixed_key] = value
        end
        return output
      end

      def self.sign!(input)
        input['brq_signature'] = signature(input)
        input
      end
    end
  end
end
