module PduSms
  class UserDataLength

    def initialize(type, ud)
      if type == :encode_ms
        raise ArgumentError, 'Parameter "ud" must be an instance of UserData' unless UserData == ud.class
        @udl = _count_message(ud)
      elsif type == :decode_ms
        @udl = ud
      elsif type == :encode_sc
        raise ArgumentError, 'Parameter "ud" must be an instance of UserData' unless UserData == ud.class
        @udl = _count_message(ud)
      elsif type == :decode_sc
        @udl = ud
      else
        raise ArgumentError, 'The "type" is incorrect'
      end
    end

    def UserDataLength.encode_ms(ud)
      new(:encode_ms, ud).freeze
    end

    def UserDataLength.decode_ms(pdu_str)
      pdu = UserDataLength.cut_off_pdu(pdu_str, :current, :ms)
      new(:decode_ms, pdu).freeze
    end

    def UserDataLength.encode_sc(ud)
      new(:encode_sc, ud).freeze
    end

    def UserDataLength.decode_sc(pdu_str)
      pdu = UserDataLength.cut_off_pdu(pdu_str, :current, :sc)
      new(:decode_sc, pdu).freeze
    end

    def get_hex
      @udl
    end

    def UserDataLength.cut_off_pdu(pdu, part=:all, type=:ms) # tail current
      if type == :ms
        part_pdu = ValidityPeriod.cut_off_pdu(pdu, :tail, :ms)
      elsif type == :sc
        part_pdu = ServiceCenterTimeStamp.cut_off_pdu(pdu, :tail, :sc)
      else
        raise ArgumentError, 'The "pdu" is incorrect'
      end
      raise ArgumentError, 'The "pdu" is incorrect' if part_pdu.length < 2
      current = part_pdu[0..1]
      tail = part_pdu[2..-1]
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    private

    def _count_message(ud)
      case ud.get_coding
        when ALPHABET_7BIT
          count_sms = ud.get_message.length
          count_sms += 8 if ud.is_udh?
        when ALPHABET_8BIT
          count_sms = ud.get_message.length
          count_sms += 6 if ud.is_udh?
        when ALPHABET_16BIT
          count_sms = ud.get_message.length * 2
          count_sms += 6 if ud.is_udh?
        else
          raise ArgumentError, 'The "ud" is incorrect'
      end
      '%02x' % count_sms
    end

  end

end
