# Partly taken from:
# https://github.com/inventid/buckaroo/blob/develop/lib/buckaroo/response.rb
require 'addressable/uri'
require 'digest/sha1'
require 'buckaroo_client/gateway/nvp/signature'

module BuckarooClient
  module Gateway
    module NVP
      class Response

        include Signature

        attr_reader :body, :response, :status_code, :success

        def self.for_action(action, response)
          klass = case action
          when 'invoiceinfo'
            require 'buckaroo_client/gateway/nvp/invoice_info_response'
            InvoiceInfoResponse
          else
            Response
          end
          klass.new(response)
        end

        def initialize(response)
          @body = response.body
          @response = Hash[Addressable::URI.form_unencode(body)]
          @status_code = @response['BRQ_STATUSCODE'].to_i
          @success = !error_occurred?
        end

        alias_method :success?, :success

        def verify!
          verified? or raise "Response signature does not match expected value"
        end

        def verified?
          input = response.dup
          given_hash = input['BRQ_SIGNATURE']
          input.delete('BRQ_SIGNATURE')
          signature(input) == given_hash
        end

        private

        def error_occurred?
          !verified? || status_code == 491 || status_code == 492
        end

      end
    end
  end
end
