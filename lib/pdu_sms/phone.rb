module PduSms

  class Phone

    attr_reader(:number_plan_identifier, :type_number)

    @phone_number = ''
    @number_plan_identifier = false
    @type_number = false

    def get_phone_number
      if @number_plan_identifier == ID_INTERNATIONAL
        '+%s' % @phone_number
      else
        '%s' % @phone_number
      end
    end

    protected

    def _auto_detect(phone_number)
      if /^\+\d+$/ === phone_number
        @number_plan_identifier = ID_INTERNATIONAL
        @type_number = TP_ISDN
      elsif /^\d+$/ === phone_number
        @number_plan_identifier = ID_UNKNOWN
        @type_number = TP_ISDN
      elsif is_7bit?(phone_number)
        @number_plan_identifier = ID_ALPHANUMERIC
        @type_number = TP_UNKNOWN
      else
        raise PacketDataUnitError, 'Could not automatically determine the type of phone number'
      end
      self
    end

    def _check_phone?
      if @number_plan_identifier == ID_ALPHANUMERIC
        is_7bit?(@phone_number)
      else
        /^\d+$/ === @phone_number
      end
    end

    def _get_hex_type_and_phone
      if @number_plan_identifier == ID_ALPHANUMERIC
        '%s%s' % [_type_of_address_hex, encode_7bit(@phone_number)]
      else
        '%s%s' % [_type_of_address_hex, _convert_to_bcd_format]
      end
    end

    def _set_phone_number(phone_number, number_play_identifier=false, type_number=false)
      if number_play_identifier == false or type_number == false
        _auto_detect(phone_number)
      else
        raise ArgumentError, 'Incorrect type of phone number' unless (TP_UNKNOWN..TP_RESERVED).include?(type_number)
        raise ArgumentError, 'Invalid type id telephone' unless (ID_UNKNOWN..ID_RESERVED).include?(number_play_identifier)
        @type_number = type_number
        @number_plan_identifier = number_play_identifier
      end

      if @number_plan_identifier == ID_INTERNATIONAL and phone_number[0] == '+'
        @phone_number = phone_number[1..-1]
      else
        @phone_number = phone_number
      end

      unless _check_phone?
        @phone_number = ''
        raise ArgumentError, 'Phone number is invalid'
      end
      self
    end

    private

    def _set_hex_type_and_phone(bcd)
      _convert_to_normal_format bcd
      unless _check_phone?
        @phone_number = ''
        raise ArgumentError, 'Phone number is invalid'
      end
      self
    end

    def _convert_to_bcd_format
      if @phone_number[0] == ?+
        clear_phone = @phone_number[1..-1]
      else
        clear_phone = @phone_number
      end
      if clear_phone.length % 2 != 0
        clear_phone += 'F'
      end
      encode_bcd(clear_phone)
    end

    def _convert_to_normal_format(bcd)
      @phone_number = ''
      if bcd.length < 4
        raise ArgumentError, 'Wrong format'
      end
      raise ArgumentError, 'Incorrect number plan identifier' unless (128..255).include?(bcd[0..1].to_i(16))
      number_type = '%08b' % bcd[0..1].to_i(16)
      @number_plan_identifier = number_type[1..3].to_i(2)
      @type_number = number_type[4..7].to_i(2)
      if @number_plan_identifier == ID_ALPHANUMERIC
        @phone_number = decode_7bit(bcd[2..-1])
      else
        @phone_number = decode_bcd(bcd[2..-1])[/[fF]$/] ? decode_bcd(bcd[2..-1])[0..-2] : decode_bcd(bcd[2..-1])
      end
      self
    end

    def _type_of_address_hex
      '%02x' % ('1%03b%04b' % [@number_plan_identifier, @type_number]).to_i(2)
    end

  end
end
