require 'forwardable'

module BuckarooClient
  module Service
    class InvoiceSpecification

      def servicecode
        'InvoiceSpecification'
      end

      def action
        'ExtraInfo'
      end

      def add_invoice_line(data)
        invoice_lines.add_line('InvoiceLine', data)
      end

      def add_sub_total_line(data)
        invoice_lines.add_line('SubTotalLine', data)
      end

      def add_total_line(data)
        invoice_lines.add_line('TotalLine', data)
      end

      def invoice_lines
        @invoice_lines ||= InvoiceLines.new
      end

      def gateway_attributes
        output = {
          'service_InvoiceSpecification_action' => action,
        }
        output.merge(invoice_lines.gateway_attributes)
      end

      class InvoiceLines
        extend Forwardable
        def_delegators :@lines, :size, :each

        attr_accessor :lines

        def initialize
          @lines = []
        end

        def add_line(type, data)
          # Auto-increment line order value if not set by user
          data[:lineordering] ||= size + 1
          lines << [type, InvoiceLineData.new(data)]
        end

        def gateway_attributes
          output = {}
          line_type_count = Hash.new(0)
          lines.each do |type, line_data|
            output.store("service_InvoiceSpecification_#{type}_#{line_type_count[type] += 1}", line_data.gateway_string)
          end
          output
        end
      end

      class InvoiceLineData
        ATTRIBUTES = [
          :lineordering,
          :description,
          :currency,
          :amount,
          :tax,
          :numberofunits,
          :unitprice,
          :unitname
        ]
        attr_accessor *ATTRIBUTES

        def initialize(args = {})
          ATTRIBUTES.each do |name|
            self.send "#{name}=", args.delete(name)
          end
          unless args.empty?
            raise ArgumentError.new("Illegal attributes given: #{args.keys.join(',')}")
          end
        end

        def gateway_string
          ATTRIBUTES.map {|a| self.send(a) }.join('|')
        end
      end
    end
  end
end
