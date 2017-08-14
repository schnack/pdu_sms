require_relative '../../spec/spec_helper'

describe PacketDataUnit do

  describe '.encode_ms' do
    it 'Создание объекта PDU пакета (Возвращается ввиде массива объектов)MS' do
      expect(PacketDataUnit.encode_ms('+71234567890', 'test')).to be_an_instance_of(Array)
    end
    before :each do
      @pdu = PacketDataUnit.encode_ms('+71234567890', 'test', coding:2)[0]
    end
    it 'Проверяем определение длины PDU' do
      expect(@pdu.length).to eq(21)
    end
    it 'Проверяем количество частей сообщения' do
      expect(@pdu.id_message).to eq(0)
      expect(@pdu.all_parts).to eq(0)
      expect(@pdu.part_number).to eq(0)
    end
    it 'Проверяем количество частей сообщения' do
      pdu = PacketDataUnit.encode_ms('+71234567890', 'm' * 180, coding:2)
      expect(pdu[1].id_message).to be_an_instance_of(Fixnum)
      expect(pdu[1].all_parts).to eq(3)
      expect(pdu[1].part_number).to eq(2)
    end
    it 'Проверяем объект класса ServiceCenterAddress' do
      expect(@pdu.sca).to be_an_instance_of(ServiceCenterAddress)
      expect(@pdu.sca.get_hex).to eq('00')
    end
    it 'Проверяем объект класса PDUType' do
      expect(@pdu.pdu_type).to be_an_instance_of(PDUType)
      expect(@pdu.pdu_type.get_hex).to eq('01')
    end
    it 'Проверяем объект класса MessageReference' do
      expect(@pdu.mr).to be_an_instance_of(MessageReference)
      expect(@pdu.mr.get_hex).to eq('00')
    end
    it 'Проверяем объект класса DestinationAddress' do
      expect(@pdu.da).to be_an_instance_of(DestinationAddress)
      expect(@pdu.da.get_hex).to eq('0B911732547698F0')
    end
    it 'Проверяем объект класса ProtocolIdentifier' do
      expect(@pdu.pid).to be_an_instance_of(ProtocolIdentifier)
      expect(@pdu.pid.get_hex).to eq('00')
    end
    it 'Проверяем объект класса DataCodingScheme' do
      expect(@pdu.dcs).to be_an_instance_of(DataCodingScheme)
      expect(@pdu.dcs.get_hex).to eq('08')
    end
    it 'Проверяем объект класса ValidityPeriod' do
      expect(@pdu.vp).to be_an_instance_of(ValidityPeriod)
      expect(@pdu.vp.get_hex).to eq('')
    end
    it 'Проверяем объект класса UserDataLength' do
      expect(@pdu.udl).to be_an_instance_of(UserDataLength)
      expect(@pdu.udl.get_hex).to eq('08')
    end
    it 'Проверяем объект класса UserData' do
      expect(@pdu.ud).to be_an_instance_of(UserData)
      expect(@pdu.ud.get_hex).to eq('0074006500730074')
    end
    after :each do
      @pdu = nil
    end
  end

  describe '.decode_ms' do
    before :each do
      @pdu = PacketDataUnit.decode_ms('07919701879999F901000B919721436587F9000812041F04400438043204350442002100210021')
    end
    it 'Проверяем объект класса ServiceCenterAddress' do
      expect(@pdu.sca).to be_an_instance_of(ServiceCenterAddress)
      expect(@pdu.sca.get_phone_number).to eq('+79107899999')
    end
    it 'Проверяем объект класса PDUType' do
      expect(@pdu.pdu_type).to be_an_instance_of(PDUType)
      expect(@pdu.pdu_type.get_hex).to eq('01')
    end
    it 'Проверяем объект класса MessageReference' do
      expect(@pdu.mr).to be_an_instance_of(MessageReference)
      expect(@pdu.mr.get_mr).to eq(0)
    end
    it 'Проверяем объект класса DestinationAddress' do
      expect(@pdu.da).to be_an_instance_of(DestinationAddress)
      expect(@pdu.da.get_phone_number).to eq('+79123456789')
    end
    it 'Проверяем объект класса ProtocolIdentifier' do
      expect(@pdu.pid).to be_an_instance_of(ProtocolIdentifier)
      expect(@pdu.pid.get_pid).to eq(0)
    end
    it 'Проверяем объект класса DataCodingScheme' do
      expect(@pdu.dcs).to be_an_instance_of(DataCodingScheme)
      expect(@pdu.dcs.get_hex).to eq('08')
    end
    it 'Проверяем объект класса ValidityPeriod' do
      expect(@pdu.vp).to be_an_instance_of(ValidityPeriod)
      expect(@pdu.vp.get_hex).to eq('')
    end
    it 'Проверяем объект класса UserDataLength' do
      expect(@pdu.udl).to be_an_instance_of(UserDataLength)
      expect(@pdu.udl.get_hex).to eq('12')
    end
    it 'Проверяем объект класса UserData' do
      expect(@pdu.ud).to be_an_instance_of(UserData)
      expect(@pdu.ud.get_message).to eq('Привет!!!')
    end
    after :each do
      @pdu = nil
    end
  end

  describe '.encode_sc' do
    it 'Создание объекта PDU пакета (Возвращается ввиде массива объектов)SC' do
      expect(PacketDataUnit.encode_sc('+71234567890', '+71234567890', 'test')).to be_an_instance_of(Array)
    end
    before :each do
      @pdu = PacketDataUnit.encode_sc('+71234567890', '+71234567890', 'test', scts:1327605005)[0]
    end
    it 'Проверяем объект класса ServiceCenterAddress' do
      expect(@pdu.sca).to be_an_instance_of(ServiceCenterAddress)
      expect(@pdu.sca.get_hex).to eq('07911732547698F0')
    end
    it 'Проверяем объект класса PDUType' do
      expect(@pdu.pdu_type).to be_an_instance_of(PDUType)
      expect(@pdu.pdu_type.get_hex).to eq('00')
    end
    it 'Проверяем объект класса OriginatingAddress' do
      expect(@pdu.oa).to be_an_instance_of(OriginatingAddress)
      expect(@pdu.oa.get_hex).to eq('0B911732547698F0')
    end
    it 'Проверяем объект класса ProtocolIdentifier' do
      expect(@pdu.pid).to be_an_instance_of(ProtocolIdentifier)
      expect(@pdu.pid.get_hex).to eq('00')
    end
    it 'Проверяем объект класса DataCodingScheme' do
      expect(@pdu.dcs).to be_an_instance_of(DataCodingScheme)
      expect(@pdu.dcs.get_hex).to eq('00')
    end
    it 'Проверяем объект класса ServiceCenterTimeStamp' do
      expect(@pdu.scts).to be_an_instance_of(ServiceCenterTimeStamp)
      expect(@pdu.scts.get_hex).to eq('21106232015061')
    end
    it 'Проверяем объект класса UserDataLength' do
      expect(@pdu.udl).to be_an_instance_of(UserDataLength)
      expect(@pdu.udl.get_hex).to eq('04')
    end
    it 'Проверяем объект класса UserData' do
      expect(@pdu.ud).to be_an_instance_of(UserData)
      expect(@pdu.ud.get_hex).to eq('F4F29C0E')
    end
    after :each do
      @pdu = nil
    end
  end

  describe '.decode_sc' do
    before :each do
      @pdu = PacketDataUnit.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')
    end
    it 'Проверяем объект класса ServiceCenterAddress' do
      expect(@pdu.sca).to be_an_instance_of(ServiceCenterAddress)
      expect(@pdu.sca.get_phone_number).to eq('+79168999100')
    end
    it 'Проверяем объект класса PDUType' do
      expect(@pdu.pdu_type).to be_an_instance_of(PDUType)
      expect(@pdu.pdu_type.get_hex).to eq('04')
    end
    it 'Проверяем объект класса ProtocolIdentifier' do
      expect(@pdu.pid).to be_an_instance_of(ProtocolIdentifier)
      expect(@pdu.pid.get_pid).to eq(0)
    end
    it 'Проверяем объект класса DataCodingScheme' do
      expect(@pdu.dcs).to be_an_instance_of(DataCodingScheme)
      expect(@pdu.dcs.get_hex).to eq('00')
    end
    it 'Проверяем объект класса ServiceCenterTimeStamp' do
      expect(@pdu.scts).to be_an_instance_of(ServiceCenterTimeStamp)
      expect(@pdu.scts.get_time).to eq(1327605005)
    end
    it 'Проверяем объект класса UserDataLength' do
      expect(@pdu.udl).to be_an_instance_of(UserDataLength)
      expect(@pdu.udl.get_hex).to eq('0C')
    end
    it 'Проверяем объект класса UserData' do
      expect(@pdu.ud).to be_an_instance_of(UserData)
      expect(@pdu.ud.get_message).to eq('Hello World!')
    end
    after :each do
      @pdu = nil
    end
  end

  describe '.decode' do
    it 'Проверяем входящее сообщение' do
      expect(PacketDataUnit.decode('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904').pdu_type.message_type_indicator_in?).to be_truthy
    end
    it 'Проверяем исходящее сообщение' do
      expect(PacketDataUnit.decode('0001000b919721436587F9000812041F04400438043204350442002100210021').pdu_type.message_type_indicator_out?).to be_truthy
    end
  end

  describe '.get_hex' do
    it 'Получаем Pdu' do
      expect(PacketDataUnit.encode_ms('+79123456789', 'Привет!!!')[0].get_hex).to eq('0001000B919721436587F9000812041F04400438043204350442002100210021')
    end
    it 'Получаем Pdu' do
      expect(PacketDataUnit.encode_sc('+79123456789','beeline', 'Привет!!!', scts:1)[0].get_hex).to eq('07919721436587F9000CD0E272999D76970100080710103000102112041F04400438043204350442002100210021')
    end
  end

end