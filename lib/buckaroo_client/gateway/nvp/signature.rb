require 'digest/sha1'

module BuckarooClient
  module Gateway
    module NVP
      module Signature
        def signature(input, secret: BuckarooClient.configuration.secret)
          raise("Config value 'secret' missing") unless secret

          # Base logic and comments taken from github.com/inventid/buckaroo
          #
          # This might actually need some explanation why we are converting do lowercase here
          # BuckarooClient specifies to sort these parameters, although the exact matter of sorting
          # is quite ambigious. So after quite a while of debugging, I discovered that by
          # sorting they do not use the ASCII based sorting Ruby uses. In fact, the sorting
          # is specified to place symbols first (which ASCII does, except for the underscore (_)
          # which is located between the capitals and lowercase letters (jeej ASCII!).
          # So in this case, by converting everything to lowercase before comparing, we ensure
          # that all symbols are in the table before the letters.
          #
          # Actual case where it went wrong: keys BRQ_TRANSACTIONS and BRQ_TRANSACTION_CANCELABLE
          # Ruby would sort these in this exact order, whereas BuckarooClient would reverse them. And
          # since for hashing the reversal generates a totally different sequence, that would
          # break message validation.
          #
          # TLDR; Leave it with a downcase
          sorted_data = input.sort_by { |key, _| key.to_s.downcase }
          to_hash = ''
          sorted_data.each { |key, value| to_hash << key.to_s+'='+value.to_s }
          to_hash << secret
          Digest::SHA1.hexdigest(to_hash)
        end
      end
    end
  end
end
