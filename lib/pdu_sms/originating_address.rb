module PduSms
  class OriginatingAddress < Phone

    def initialize(type=false, data=false, number_play_identifier=false, type_number=false)
      if type == :decode_sc
        _set_pdu_hex OriginatingAddress.cut_off_pdu(data, :current, :sc)
      elsif type == :encode_sc
        _set_phone_number data, number_play_identifier, type_number
      end
    end

    def OriginatingAddress.encode_sc(phone, number_play_identifier=false, type_number=false)
      new(:encode_sc, phone, number_play_identifier, type_number)
    end

    def OriginatingAddress.decode_sc(pdu)
      new(:decode_sc, pdu).freeze
    end

    def OriginatingAddress.cut_off_pdu(pdu, part=:all, type=:sc) # tail current
      part_pdu = PDUType.cut_off_pdu(pdu, :tail)
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
      if @number_plan_identifier == ID_ALPHANUMERIC
        '%02X' % (@phone_number.length * 0.875 * 2).round
      else
        '%02X' %  @phone_number.length
      end
    end
  end
end
