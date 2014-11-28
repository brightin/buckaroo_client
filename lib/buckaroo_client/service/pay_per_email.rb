module BuckarooClient
  module Service
    class PayPerEmail

      attr_accessor :customergender, :customeremail, :customerfirstname, :customerlastname,
        :merchantsendsemail, :paymentmethodsallowed, :expirationdate

      def initialize(args = {})
        @customergender = args.fetch(:customergender, 0)
        @customeremail = args[:customeremail]
        @customerfirstname = args[:customerfirstname]
        @customerlastname = args[:customerlastname]
        @merchantsendsemail = args.fetch(:merchantsendsemail, false)
        @paymentmethodsallowed = args[:paymentmethodsallowed]
        @expirationdate = args[:expirationdate]
      end

      def servicecode
        'payperemail'
      end

      def action
        'paymentinvitation'
      end

      def gateway_attributes
        {
          'service_payperemail_action' => action,
          'service_payperemail_customergender' => customergender.to_s,
          'service_payperemail_customeremail' => customeremail,
          'service_payperemail_customerfirstname' => customerfirstname,
          'service_payperemail_customerlastname' => customerlastname,
          'service_payperemail_merchantsendsemail' => merchantsendsemail.to_s.upcase,
          'service_payperemail_paymentmethodsallowed' => paymentmethodsallowed,
          'service_payperemail_expirationdate' => expirationdate,
        }.select { |_, value| !value.nil? }
      end
    end
  end
end
