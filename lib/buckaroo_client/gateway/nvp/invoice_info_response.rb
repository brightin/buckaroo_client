require 'buckaroo_client/gateway/nvp/response'

module BuckarooClient
  module Gateway
    module NVP
      class InvoiceInfoResponse < Response

        def paid?
          return nil unless response.key?('BRQ_INVOICE_1_PAID')
          response['BRQ_INVOICE_1_PAID'].to_s.downcase == 'true'
        end

      end
    end
  end
end
