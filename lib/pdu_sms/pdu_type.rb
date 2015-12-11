module PduSms
  class PDUType

    def initialize(type, rp: REPLY_PATH_0, udhi: USER_DATA_HEADER_INCLUDED_0, mti: MESSAGE_TYPE_INDICATOR_01, vpf: false, srr: false, sri: false, rd: false, mms: false)
      raise ArgumentError, 'The "rp" is incorrect' unless (REPLY_PATH_0..REPLY_PATH_1).include?(rp)
      raise ArgumentError, 'The "udhi" is incorrect' unless (USER_DATA_HEADER_INCLUDED_0..USER_DATA_HEADER_INCLUDED_1).include?(udhi)
      raise ArgumentError, 'The "mti" is incorrect' unless (MESSAGE_TYPE_INDICATOR_00..MESSAGE_TYPE_INDICATOR_11).include?(mti)
      if mti == MESSAGE_TYPE_INDICATOR_01
        raise ArgumentError, 'The "srr" is incorrect' unless (STATUS_REPORT_REQUEST_0..STATUS_REPORT_REQUEST_1).include?(srr)
        raise ArgumentError, 'The "vpf" is incorrect' unless (VALIDITY_PERIOD_FORMAT_00..VALIDITY_PERIOD_FORMAT_11).include?(vpf)
        raise ArgumentError, 'The "rd" is incorrect' unless (REJECT_DUPLICATES_0..REJECT_DUPLICATES_1).include?(rd)
      elsif mti == MESSAGE_TYPE_INDICATOR_00
        raise ArgumentError, 'The "sri" is incorrect' unless (STATUS_REPORT_INDICATION_0..STATUS_REPORT_INDICATION_1).include?(sri)
        raise ArgumentError, 'The "mms" is incorrect' unless (MORE_MESSAGES_TO_SEND_0..MORE_MESSAGES_TO_SEND_1).include?(mms)
      end
      @rp = rp
      @udhi = udhi
      @srr = srr
      @vpf = vpf
      @rd = rd
      @mti = mti
      @mms = mms
      @sri = sri
    end

    def PDUType.encode(rp: REPLY_PATH_0, udhi: USER_DATA_HEADER_INCLUDED_0, srr: STATUS_REPORT_REQUEST_0, vpf: VALIDITY_PERIOD_FORMAT_00, rd: REJECT_DUPLICATES_0, mti: MESSAGE_TYPE_INDICATOR_01, sri: STATUS_REPORT_INDICATION_0, mms:MORE_MESSAGES_TO_SEND_0)
      if mti == MESSAGE_TYPE_INDICATOR_01
        PDUType.encode_ms(rp:rp,udhi:udhi, srr:srr, vpf:vpf, rd:rd)
      elsif mti == MESSAGE_TYPE_INDICATOR_00
        PDUType.encode_sc(rp:rp, udhi:udhi, sri:sri, mms:mms)
      elsif mti == MESSAGE_TYPE_INDICATOR_10
        raise PacketDataUnitError, 'oops SMS-SUBMIT not supported by this version of the library'
      end
    end

    def PDUType.decode(pdu_str)
      pdu = '%08b' % PDUType.cut_off_pdu(pdu_str, :current, :ms)
      mti = pdu[6..7].to_i(2)
      if mti == MESSAGE_TYPE_INDICATOR_00
        PDUType.decode_sc(pdu_str)
      elsif mti == MESSAGE_TYPE_INDICATOR_01
        PDUType.decode_ms(pdu_str)
      elsif mti == MESSAGE_TYPE_INDICATOR_10
        raise PacketDataUnitError, 'oops SMS-SUBMIT not supported by this version of the library'
      else
        raise PacketDataUnitError, 'format error'
      end
    end

    def PDUType.encode_ms(rp: REPLY_PATH_0, udhi: USER_DATA_HEADER_INCLUDED_0, srr: STATUS_REPORT_REQUEST_0, vpf: VALIDITY_PERIOD_FORMAT_00, rd: REJECT_DUPLICATES_0)
      new(:encode_ms, rp:rp, udhi:udhi, srr:srr, vpf:vpf, rd:rd, mti:MESSAGE_TYPE_INDICATOR_01).freeze
    end

    def PDUType.decode_ms(pdu_str)
      pdu = '%08b' % PDUType.cut_off_pdu(pdu_str, :current, :ms).to_i(16)
      raise ArgumentError, 'wrong format "PDU" package' if pdu[6..7].to_i(2) != MESSAGE_TYPE_INDICATOR_01
      new(:decode_ms, rp:pdu[0].to_i(2), udhi:pdu[1].to_i(2), srr:pdu[2].to_i(2), vpf:pdu[3..4].to_i(2), rd:pdu[5].to_i(2), mti:MESSAGE_TYPE_INDICATOR_01).freeze
    end

    def PDUType.encode_sc(rp: REPLY_PATH_0, udhi: USER_DATA_HEADER_INCLUDED_0, sri: STATUS_REPORT_INDICATION_0, mms:MORE_MESSAGES_TO_SEND_0)
      new(:encode_ms, rp:rp, udhi:udhi, sri:sri, mms:mms, mti:MESSAGE_TYPE_INDICATOR_00).freeze
    end

    def PDUType.decode_sc(pdu_str)
      pdu = '%08b' % PDUType.cut_off_pdu(pdu_str, :current, :sc).to_i(16)
      raise ArgumentError, 'wrong format "PDU" package' if pdu[6..7].to_i(2) != MESSAGE_TYPE_INDICATOR_00
      new(:decode_ms, rp:pdu[0].to_i(2), udhi:pdu[1].to_i(2), sri:pdu[2].to_i(2), mms:pdu[5].to_i(2), mti:MESSAGE_TYPE_INDICATOR_00).freeze
    end

    def PDUType.cut_off_pdu(pdu, part=:all, type=:ms) # tail current
      part_pdu = ServiceCenterAddress.cut_off_pdu(pdu, :tail)
      raise TypeError.new('Слишком короткая строка') if part_pdu.length < 2
      current = part_pdu[0..1]
      tail = part_pdu[2..-1]
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def reply_path?
      @rp == REPLY_PATH_1
    end

    def user_data_header_included?
      @udhi == USER_DATA_HEADER_INCLUDED_1
    end

    def status_report_request?
      @srr == STATUS_REPORT_REQUEST_1
    end

    def validity_period_format_off?
      @vpf == VALIDITY_PERIOD_FORMAT_00
    end

    def validity_period_format_reserve?
      @vpf == VALIDITY_PERIOD_FORMAT_01
    end

    def validity_period_format_relative?
      @vpf == VALIDITY_PERIOD_FORMAT_10
    end

    def validity_period_format_absolute?
      @vpf == VALIDITY_PERIOD_FORMAT_11
    end

    def reject_duplicates?
      @rd == REJECT_DUPLICATES_1
    end

    def message_type_indicator_in?
      @mti == MESSAGE_TYPE_INDICATOR_00
    end

    def message_type_indicator_out?
      @mti == MESSAGE_TYPE_INDICATOR_01
    end

    def message_type_indicator_report?
      @mti == MESSAGE_TYPE_INDICATOR_10
    end

    def message_type_indicator_reserve?
      @mti == MESSAGE_TYPE_INDICATOR_11
    end

    def more_messages_to_send?
      @mms == MORE_MESSAGES_TO_SEND_1
    end

    def status_report_indication?
      @sri == STATUS_REPORT_INDICATION_1
    end

    def get_reply_path
      '%b' % @rp
    end

    def get_user_data_header_included
      '%b' % @udhi
    end

    def get_status_report_request
      '%b' % @srr
    end

    def get_validity_period_format
      '%02b' % @vpf
    end

    def get_reject_duplicates
      '%b' % @rd
    end

    def get_message_type_indicator
      '%02b' % @mti
    end

    def get_status_report_indication
      '%b' % @sri
    end

    def get_more_messages_to_send
      '%b' % @mms
    end

    def get_hex
      if message_type_indicator_out?
        '%02X' % [('' << get_reply_path << get_user_data_header_included << get_status_report_request << get_validity_period_format << get_reject_duplicates << get_message_type_indicator).to_i(2)]
      elsif message_type_indicator_in?
        '%02X' % [('' << get_reply_path << get_user_data_header_included << get_status_report_indication << '00' << get_more_messages_to_send << get_message_type_indicator).to_i(2)]
      end
    end

  end
end
