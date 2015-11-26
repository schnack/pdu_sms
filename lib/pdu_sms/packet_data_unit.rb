
module PduSms

  class PacketDataUnit

    attr_reader(:sca,:service_center_address,:pdu_type,:mr,:message_reference,:da,:destination_address,
                :pid,:protocol_identifier,:dcs,:data_coding_scheme,:vp,:validity_period,:udl,:user_data_length,:ud,:user_data,
                :oa,:originating_address,:scts,:service_center_time_stamp)

    def initialize(sca: false, pdu_type: false, mr: false, da: false, pid: false, dcs: false, vp: false, udl: false, ud: false, oa: false, scts: false)
      raise ArgumentError, 'sca parameter should contain an object of class ServiceCenterAddress' unless ServiceCenterAddress == sca.class
      raise ArgumentError, 'pdu_type parameter should contain an object of class PDUType' unless PDUType == pdu_type.class
      raise ArgumentError, 'mr parameter should contain an object of class MessageReference' unless mr == false or MessageReference == mr.class
      raise ArgumentError, 'da parameter should contain an object of class DestinationAddress' unless da == false or DestinationAddress == da.class
      raise ArgumentError, 'pid parameter should contain an object of class ProtocolIdentifier' unless ProtocolIdentifier == pid.class
      raise ArgumentError, 'dcs parameter should contain an object of class DataCodingScheme' unless DataCodingScheme == dcs.class
      raise ArgumentError, 'vp parameter should contain an object of class ValidityPeriod' unless vp == false or ValidityPeriod == vp.class
      raise ArgumentError, 'udl parameter should contain an object of class UserDataLength' unless UserDataLength == udl.class
      raise ArgumentError, 'ud parameter should contain an object of class UserData' unless UserData == ud.class
      raise ArgumentError, 'oa parameter should contain an object of class OriginatingAddress' unless oa == false or OriginatingAddress == oa.class
      raise ArgumentError, 'scts parameter should contain an object of class ServiceCenterTimeStamp' unless scts == false or ServiceCenterTimeStamp == scts.class
      @sca = @service_center_address = sca
      @pdu_type = pdu_type
      @mr = @message_reference = mr
      @da = @destination_address = da
      @pid = @protocol_identifier = pid
      @dcs = @data_coding_scheme = dcs
      @vp = @validity_period = vp
      @udl = @user_data_length = udl
      @ud = @user_data = ud
      @oa = @originating_address = oa
      @scts = @service_center_time_stamp = scts
    end

    def PacketDataUnit.encode_ms(phone, message, coding: :auto, phone_npi: false, phone_ton: false, sca: false, sca_npi: false, sca_ton: false, rp: REPLY_PATH_0, srr: STATUS_REPORT_REQUEST_0, vp: false, rd: REJECT_DUPLICATES_0, message_class: false, compressed: UNCOMPRESSED)
      user_data_array = UserData.encode_ms(message, coding)
      user_data_array.collect.each_with_index do |user_data, current_num_pdu|
        service_center_address = ServiceCenterAddress.encode_ms(sca, sca_npi, sca_ton)
        destination_address = DestinationAddress.encode_ms(phone, phone_npi, phone_ton)
        protocol_identifier = ProtocolIdentifier.encode_ms
        message_reference = MessageReference.encode_ms(current_num_pdu)
        validity_period = ValidityPeriod.encode_ms(vp)
        pdu_type = PDUType.encode_ms(rp:rp, srr:srr, rd:rd, udhi: user_data.get_udh, vpf: validity_period.is_setup)
        data_coding_scheme = DataCodingScheme.encode_ms(compressed: compressed, message_class: message_class, alphabet: user_data.get_coding)
        user_data_length = UserDataLength.encode_ms(user_data)
        new(sca: service_center_address, pdu_type: pdu_type, mr: message_reference, da: destination_address, pid: protocol_identifier, dcs: data_coding_scheme, vp: validity_period, udl: user_data_length, ud: user_data).freeze
      end
    end

    def PacketDataUnit.decode_ms(pdu)
      service_center_address = ServiceCenterAddress.decode_ms(pdu)
      pdu_type = PDUType.decode_ms(pdu)
      message_reference = MessageReference.decode_ms(pdu)
      destination_address = DestinationAddress.decode_ms(pdu)
      protocol_identifier = ProtocolIdentifier.decode_ms(pdu)
      data_coding_scheme = DataCodingScheme.decode_ms(pdu)
      validity_period = ValidityPeriod.decode_ms(pdu)
      user_data_length = UserDataLength.decode_ms(pdu)
      user_data = UserData.decode_ms(pdu)
      new(sca: service_center_address, pdu_type: pdu_type, mr: message_reference, da: destination_address, pid: protocol_identifier, dcs: data_coding_scheme, vp: validity_period, udl: user_data_length, ud: user_data).freeze
    end

    def PacketDataUnit.encode_sc(sca, phone, message, coding: :auto, sca_npi: false, sca_ton: false, phone_npi: false, phone_ton: false, rp: REPLY_PATH_0, sri: STATUS_REPORT_INDICATION_0, mms: MORE_MESSAGES_TO_SEND_0, message_class: false, compressed: UNCOMPRESSED, scts: Time.now.getutc.to_i)
      user_data_array = UserData.encode_sc(message, coding)
      user_data_array.collect do |user_data|
        service_center_address = ServiceCenterAddress.encode_sc(sca, sca_npi, sca_ton)
        pdu_type = PDUType.encode_sc(rp: rp, udhi: user_data.get_udh, sri: sri, mms: mms)
        originating_address = OriginatingAddress.encode_sc(phone, phone_npi, phone_ton)
        protocol_identifier = ProtocolIdentifier.encode_sc
        data_coding_scheme = DataCodingScheme.encode_sc(compressed: compressed, message_class: message_class, alphabet: user_data.get_coding)
        service_center_time_stamp = ServiceCenterTimeStamp.encode_sc(scts)
        user_data_length = UserDataLength.encode_sc(user_data)
        new(sca: service_center_address, pdu_type: pdu_type, pid: protocol_identifier, dcs: data_coding_scheme, udl: user_data_length, ud: user_data, oa: originating_address, scts: service_center_time_stamp).freeze
      end
    end

    def PacketDataUnit.decode_sc(pdu)
      service_center_address = ServiceCenterAddress.decode_sc(pdu)
      pdu_type = PDUType.decode_sc(pdu)
      originating_address = OriginatingAddress.decode_sc(pdu)
      protocol_identifier = ProtocolIdentifier.decode_sc(pdu)
      data_coding_scheme = DataCodingScheme.decode_sc(pdu)
      service_center_time_stamp = ServiceCenterTimeStamp.decode_sc(pdu)
      user_data_length = UserDataLength.decode_sc(pdu)
      user_data = UserData.decode_sc(pdu)
      new(sca: service_center_address, pdu_type: pdu_type, pid: protocol_identifier, dcs: data_coding_scheme, udl: user_data_length, ud: user_data, oa: originating_address, scts: service_center_time_stamp).freeze
    end

    def PacketDataUnit.decode(pdu)
      pdu_type = PDUType.decode(pdu)
      if pdu_type.message_type_indicator_in?
        decode_sc(pdu)
      elsif pdu_type.message_type_indicator_out?
        decode_ms(pdu)
      else
        raise ArgumentError, 'failed to recognize the type of package'
      end
    end

    def get_hex
      if @pdu_type.message_type_indicator_out?
        '' << @sca.get_hex << @pdu_type.get_hex << @mr.get_hex << @da.get_hex << @pid.get_hex << @dcs.get_hex << @vp.get_hex << @udl.get_hex << @ud.get_hex
      elsif @pdu_type.message_type_indicator_in?
        '' << @sca.get_hex << @pdu_type.get_hex << @oa.get_hex << @pid.get_hex << @dcs.get_hex << @scts.get_hex << @udl.get_hex << @ud.get_hex
      else
        raise PacketDataUnitError, 'oops SMS-SUBMIT not supported by this version of the library'
      end
    end

    def get_message
      @ud.get_message
    end

    def get_phone_number
      if @pdu_type.message_type_indicator_out?
        @da.get_phone_number
      elsif @pdu_type.message_type_indicator_in?
        @oa.get_phone_number
      else
        raise PacketDataUnitError, 'oops SMS-SUBMIT not supported by this version of the library'
      end
    end

  end
end

