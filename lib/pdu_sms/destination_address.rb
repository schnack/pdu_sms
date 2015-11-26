module PduSms
  class DestinationAddress < Phone

    def initialize(type=false, data=false, number_play_identifier=false, type_number=false)
      if type == :decode_ms
        _set_pdu_hex data
      elsif type == :encode_ms
        _set_phone_number data, number_play_identifier, type_number
      end
    end

    def DestinationAddress.encode_ms(phone_number, number_play_identifier=false, type_number=false)
      new(:encode_ms, phone_number, number_play_identifier, type_number).freeze
    end

    def DestinationAddress.decode_ms(pdu)
      new(:decode_ms, DestinationAddress.cut_off_pdu(pdu, :current, :ms)).freeze
    end

    def DestinationAddress.cut_off_pdu(pdu, part=:all, type=:ms) # tail current
      part_pdu = MessageReference.cut_off_pdu(pdu, :tail)
      raise ArgumentError, 'The "pdu" is incorrect' if part_pdu.length < 4
      length = part_pdu[0..1].to_i(16)
      if length % 2 == 0
        current = part_pdu[0..length+3]
        tail = part_pdu[length+4..-1]
      else
        current = part_pdu[0..length+4]
        tail = part_pdu[length+5..-1]
      end
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def get_hex
      '%s%s' % [_address_length, _get_hex_type_and_phone]
    end

    private
    def _set_pdu_hex(str_pdu)
      _set_hex_type_and_phone(str_pdu[2..-1])
      self
    end

    def _address_length
      if @phone_number[0] == ?+
        '%02x' % (@phone_number.length - 1)
      else
        '%02x' % @phone_number.length
      end
    end

  end
end
