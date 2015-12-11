module PduSms
  class MessageReference

    def initialize(num)
      if (0..255).include?(num)
        @mr = num
      else
        raise ArgumentError, 'The "num" is incorrect'
      end
    end

    def MessageReference.encode_ms(num)
      new(num).freeze
    end

    def MessageReference.decode_ms(pdu)
      new(MessageReference.cut_off_pdu(pdu, :current, :ms).to_i(2)).freeze
    end

    def MessageReference.cut_off_pdu(pdu, part=:all, type=:ms) # tail current
      part_pdu = PDUType.cut_off_pdu(pdu, :tail)
      raise ArgumentError, 'The "pdu" is incorrect' if part_pdu.length < 2
      current = part_pdu[0..1]
      tail = part_pdu[2..-1]
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def get_hex
      '%02X' % @mr
    end

    def get_mr
      @mr
    end

  end
end
