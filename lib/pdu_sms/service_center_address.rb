module PduSms

  class ServiceCenterAddress < Phone

    def initialize(type, data=false, number_play_identifier=false, type_number=false)
      if not data
        @phone_number = ''
      elsif type == :encode_ms
        _set_phone_number data, number_play_identifier, type_number
      elsif type == :decode_ms
        _set_pdu_hex ServiceCenterAddress.cut_off_pdu(data, part=:current, :ms)
      elsif type == :encode_sc
        _set_phone_number data, number_play_identifier, type_number
      elsif type == :decode_sc
        _set_pdu_hex ServiceCenterAddress.cut_off_pdu(data, part=:current, :sc)
      end
    end

    def ServiceCenterAddress.encode_ms(str_phone_number=false, number_play_identifier=false, type_number=false)
      new(:encode_ms, str_phone_number, number_play_identifier, type_number).freeze
    end

    def ServiceCenterAddress.decode_ms(str_pdu)
      new(:decode_ms, str_pdu).freeze
    end

    def ServiceCenterAddress.encode_sc(str_phone_number=false, number_play_identifier=false, type_number=false)
      new(:encode_sc, str_phone_number, number_play_identifier, type_number).freeze
    end

    def ServiceCenterAddress.decode_sc(str_pdu)
      new(:decode_sc, str_pdu).freeze
    end

    def ServiceCenterAddress.cut_off_pdu(pdu, part=:all, type=:sc) # tail current
      raise ArgumentError, 'The "pdu" is incorrect' if pdu.length < 3
      sca_length = pdu[0..1].to_i
      if sca_length > 0
        current = pdu[0..(sca_length * 2 + 1)]
        tail = pdu[(sca_length * 2 + 2)..-1]
      else
        current = '00'
        tail = pdu[2..-1]
      end
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def get_hex
      return '%02X' % 0x00 unless _check_phone?
      '%s%s' % [_address_length_hex, _get_hex_type_and_phone]
    end

    private

    def _set_pdu_hex(str_pdu)
      if str_pdu == '00'
        @phone_number = ''
      else
        _set_hex_type_and_phone(str_pdu[2..-1])
      end
      self
    end

    def _address_length_hex
      '%02X' % (_get_hex_type_and_phone.size / 2).to_s.to_i(16)
    end

  end
end

