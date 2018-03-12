module PduSms
  class UserData

    def initialize(message, coding, ied1: false, ied2: false, ied3: false, udhl: false, iei: false, iedl: false)
      @coding = _check_coding coding
      @ied1 = _check_ied1 ied1
      @ied2 = _check_ied2 ied2
      @ied3 = _check_ied3 ied3
      @udhl = udhl ? udhl : _check_udhl(ied1)
      @iei = iei ? iei : _check_iei(ied1)
      @iedl = iedl ? iedl : _check_iedl(ied1)
      @message = _check_message message, coding, ied1
    end

    def UserData.encode_ms(message, coding=:auto)
      message_array = [message]
      coding = Helpers.is_7bit?(message) ? ALPHABET_7BIT : ALPHABET_16BIT if coding == :auto
      if coding == ALPHABET_7BIT
        if message.length > 160
          #TODO ide 00  - 153   ied 0000 - 152
          message_array = message.scan(/.{1,153}/)
        end
      elsif coding == ALPHABET_8BIT
        if message.length > 140
          message_array = message.scan(/.{1,133}/)
        end
      elsif coding == ALPHABET_16BIT
        if message.length > 70
          message_array = message.scan(/.{1,67}/)
        end
      else
        raise ArgumentError, 'The "coding" is incorrect'
      end
      ied1 = '%02X' % rand(255)
      message_array.collect.each_with_index do |mess, current_message|
        if message_array.length > 1
          new(mess, coding, ied1:ied1, ied2:message_array.length, ied3:current_message+1).freeze
        else
          new(mess, coding).freeze
        end
      end
    end

    def UserData.decode_ms(pdu_str)
      header, message = UserData.cut_off_pdu(pdu_str, :all, :ms)
      dcs = DataCodingScheme.decode_ms(pdu_str)
      if dcs.alphabet_7bit?
        coding = dcs.get_alphabet.to_i(2)
        if header.empty?
          message = Helpers.decode_7bit(message)
        else
          message = Helpers.decode_7bit_fill_bits(message, header[0..1])
        end
      elsif dcs.alphabet_8bit?
        coding = dcs.get_alphabet.to_i(2)
        message = Helpers.decode_8bit(message)
      elsif dcs.alphabet_16bit?
        coding = dcs.get_alphabet.to_i(2)
        message = Helpers.decode_ucs2(message)
      else
        raise ArgumentError, 'The "pdu_str" is incorrect'
      end
      if header.empty?
        new(message, coding).freeze
      else
        if header[0..1].to_i(16) == UDHL_SIZE_6
          new(message, coding, udhl: header[0..1].to_i(16), iei: header[2..3].to_i(16), iedl: header[4..5].to_i(16), ied1: header[6..9], ied2: header[10..11].to_i(16), ied3: header[12..13].to_i(16)).freeze
        elsif header[0..1].to_i(16) == UDHL_SIZE_5
          new(message, coding, udhl: header[0..1].to_i(16), iei: header[2..3].to_i(16), iedl: header[4..5].to_i(16), ied1: header[6..7], ied2: header[8..9].to_i(16), ied3: header[10..11].to_i(16)).freeze
        else
          new(message, coding).freeze
        end
      end
    end

    def UserData.encode_sc(message, coding=:auto)
      UserData.encode_ms(message, coding)
    end

    def UserData.decode_sc(pdu_str)
      header, message = UserData.cut_off_pdu(pdu_str, :all, :sc)
      dcs = DataCodingScheme.decode_sc(pdu_str)
      if dcs.alphabet_7bit?
        coding = dcs.get_alphabet.to_i(2)
        if header.empty?
          message = Helpers.decode_7bit(message)
        else
          message = Helpers.decode_7bit_fill_bits(message, header[0..1])
        end
      elsif dcs.alphabet_8bit?
        coding = dcs.get_alphabet.to_i(2)
        message = Helpers.decode_8bit(message)
      elsif dcs.alphabet_16bit?
        coding = dcs.get_alphabet.to_i(2)
        message = Helpers.decode_ucs2(message)
      else
        raise ArgumentError, 'The "pdu_str" is incorrect'
      end
      if header.empty?
        new(message, coding).freeze
      else
        if header[0..1].to_i(16) == UDHL_SIZE_6
          new(message, coding, udhl: header[0..1].to_i(16), iei: header[2..3].to_i(16), iedl: header[4..5].to_i(16), ied1: header[6..9], ied2: header[10..11].to_i(16), ied3: header[12..13].to_i(16)).freeze
        elsif header[0..1].to_i(16) == UDHL_SIZE_5
          new(message, coding, udhl: header[0..1].to_i(16), iei: header[2..3].to_i(16), iedl: header[4..5].to_i(16), ied1: header[6..7], ied2: header[8..9].to_i(16), ied3: header[10..11].to_i(16)).freeze
        else
          new(message, coding).freeze
        end
      end
    end

    def UserData.cut_off_pdu(pdu, part=:all, type=:ms) # tail current
      part_pdu = UserDataLength.cut_off_pdu(pdu, :tail, type)
      pdu_type = PDUType.decode(pdu)
      raise ArgumentError, 'The "pdu_str" is incorrect' if part_pdu.length < 2
      if pdu_type.user_data_header_included?
        current = part_pdu[0..(part_pdu[0..1].to_i(16) * 2 + 1)]
        tail = part_pdu[(part_pdu[0..1].to_i(16) * 2 + 2)..-1]
      else
        current = ''
        tail = part_pdu[0..-1]
      end
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def get_message
      @message
    end

    def get_coding
      @coding
    end

    def is_udh?
      @ied1 ? true : false
    end

    def get_udh
      if is_udh?
        USER_DATA_HEADER_INCLUDED_1
      else
        USER_DATA_HEADER_INCLUDED_0
      end
    end

    def get_ied1
      return '' unless @ied1
      @ied1
    end

    def get_ied2
      return '' unless @ied2
      '%02X' % @ied2
    end

    def get_ied3
      return '' unless @ied3
      '%02X' % @ied3
    end

    def get_udhl
      return '' unless @udhl
      '%02X' % @udhl
    end

    def get_iei
      return '' unless @iei
      '%02X' % @iei
    end

    def get_iedl
      return '' unless @iedl
      '%02X' % @iedl
    end

    def get_hex
      if @coding == ALPHABET_7BIT
        message = Helpers.encode_7bit_fill_bits(@message, get_udhl)
      elsif @coding == ALPHABET_8BIT
        message = Helpers.encode_8bit(@message)
      else
        message = Helpers.encode_ucs2(@message)
      end
      '%s%s%s%s%s%s%s' % [get_udhl, get_iei, get_iedl, get_ied1, get_ied2, get_ied3, message]
    end

    private

    def _check_message(message, coding, ied1=false)
      raise ArgumentError, 'The "coding" is incorrect' unless message.class == String and message.encoding.to_s == 'UTF-8'
      case coding
        when ALPHABET_7BIT
          raise ArgumentError, 'The message is too long' if (ied1 and ied1.length == 2 and message.length > 153) or (ied1 and ied1.length == 4 and message.length > 152) or message.length > 160
        when ALPHABET_8BIT
          raise ArgumentError, 'The message is too long' if (ied1 and message.length > 133) or message.length > 140
        when ALPHABET_16BIT
          raise ArgumentError, 'The message is too long' if (ied1 and message.length > 67) or message.length > 70
        else
          raise ArgumentError, 'Unknown encoding'
      end
      message
    end

    def _check_coding(coding)
      raise ArgumentError, 'Unknown encoding' unless (ALPHABET_7BIT..ALPHABET_16BIT).include?(coding)
      coding
    end

    def _check_ied1(ied1)
      return false unless ied1
      raise ArgumentError, 'The message is too long'  unless (0..65535).include?(ied1.to_i(16))
      ied1
    end

    def _check_ied2(ied2)
      raise ArgumentError, 'The "coding" is incorrect' unless ied2 == false or (0..255).include?(ied2)
      ied2
    end

    def _check_ied3(ied3)
      raise ArgumentError, 'The "coding" is incorrect' unless ied3 == false or (0..255).include?(ied3)
      ied3
    end

    def _check_udhl(ied1)
      return false unless ied1
      if ied1.length == 2
        UDHL_SIZE_5
      elsif ied1.length == 4
        UDHL_SIZE_6
      else
        false
      end
    end

    def _check_iei(ied1)
      return false unless ied1
      if ied1.length == 2
        0x00
      elsif ied1.length == 4
        0x08
      else
        false
      end
    end

    def _check_iedl(ied1)
      return false unless ied1
      if ied1.length == 2
        0x03
      elsif ied1.length == 4
        0x04
      else
        false
      end
    end

  end
end