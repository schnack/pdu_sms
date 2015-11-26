require_relative '../../spec/spec_helper'

describe OriginatingAddress do

  describe '.initialize' do
    it 'Создание объекта c значениями по умолчанию' do
      expect(OriginatingAddress.new).to be_an_instance_of OriginatingAddress
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверяем корректность выделение блока oa из pdu пакета (SС) 11 значный номер' do
      expect(OriginatingAddress.cut_off_pdu('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')).to eq(['0B919701119905F8', '0000211062320150610CC8329BFD065DDF72363904'])
    end
    it 'Проверяем корректность выделение блока oa из pdu пакета (SС) текстовый номер' do
      expect(OriginatingAddress.cut_off_pdu('07919761989901F00409D0D432BB2C030000211062320150610CC8329BFD065DDF72363904')).to eq(['09D0D432BB2C03', '0000211062320150610CC8329BFD065DDF72363904'])
    end
    it 'Проверяем корректность выделение блока oa из pdu пакета (SС) 10 значный номер' do
      expect(OriginatingAddress.cut_off_pdu('07919761989901F0040A9197011199050000211062320150610CC8329BFD065DDF72363904')).to eq(['0A919701119905', '0000211062320150610CC8329BFD065DDF72363904'])
    end
  end

  describe '.encode_sc' do
    it 'Кодируем телефонный номер в международном формате' do
      expect(OriginatingAddress.encode_sc('+79101199508').get_hex).to eq('0b919701119905F8')
    end
    it 'Кодируем номер в местном формате' do
      expect(OriginatingAddress.encode_sc('79101199508',ID_UNKNOWN).get_hex).to eq('0b819701119905F8')
    end
    it 'Кодируем тестовый номер' do
      expect(OriginatingAddress.encode_sc('Tele2',ID_ALPHANUMERIC, TP_UNKNOWN).get_hex).to eq('09d0D432BB2C03')
    end
  end

  describe '.decode_sc' do
    it 'Декодируем телефонный номер в международном формате' do
      expect(OriginatingAddress.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904').get_phone_number).to eq('+79101199508')
    end
    it 'Декодируем текстовый телефонный номер' do
      expect(OriginatingAddress.decode_sc('07919761989901F00409D0D432BB2C030000211062320150610CC8329BFD065DDF72363904').get_phone_number).to eq('Tele2')
    end
    it 'Декодируем местный номер телефона' do
      expect(OriginatingAddress.decode_sc('07919761989901F0040A8197011199050000211062320150610CC8329BFD065DDF72363904').get_phone_number).to eq('7910119950')
    end
  end
end