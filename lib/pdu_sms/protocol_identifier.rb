module PduSms
  class ProtocolIdentifier

    def initialize(num)
      if (0..255).include?(num)
        @pid = num
      else
        raise ArgumentError, 'The "num is incorrect'
      end
    end

    def ProtocolIdentifier.cut_off_pdu(pdu, part=:all, type=:ms)
      if type == :ms
        part_pdu = DestinationAddress.cut_off_pdu(pdu, :tail)
      elsif type == :sc
        part_pdu = OriginatingAddress.cut_off_pdu(pdu, :tail)
      else
        raise ArgumentError, 'Format "PDU" not valid'
      end
      raise ArgumentError, 'Too short packet pdu' if part_pdu.length < 2
      current = part_pdu[0..1]
      tail = part_pdu[2..-1]
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def ProtocolIdentifier.encode_ms(pid=PROTOCOL_IDENTIFIER)
      new(pid).freeze
    end

    def ProtocolIdentifier.decode_ms(pdu)
      new(ProtocolIdentifier.cut_off_pdu(pdu, :current, :ms).to_i(2)).freeze
    end

    def ProtocolIdentifier.encode_sc(pid=PROTOCOL_IDENTIFIER)
      new(pid).freeze
    end

    def ProtocolIdentifier.decode_sc(pdu)
      new(ProtocolIdentifier.cut_off_pdu(pdu, :current, :sc).to_i(2)).freeze
    end

    def get_hex
      '%02X' % [@pid]
    end

    def get_pid
      @pid
    end

  end
end
