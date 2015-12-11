require_relative '../../spec/spec_helper'

describe DestinationAddress do

  describe '.initialize' do
    it 'Создание объекта c параметрами по умолчанию' do
      expect(DestinationAddress.new).to be_an_instance_of DestinationAddress
    end
  end

  describe '.encode_ms' do
    it 'Создание объекта с помощью фабрики кодирования' do
      expect(DestinationAddress.encode_ms('+71234567890')).to be_an_instance_of(DestinationAddress)
    end
    it 'Если номер телефона задан не верно' do
      expect(-> {DestinationAddress.encode_ms('ошибка')} ).to raise_exception PacketDataUnitError
    end
    it 'Объект заморожен' do
      expect(DestinationAddress.encode_ms('+79851488398').frozen?).to be_truthy
    end
  end

  describe '.decode_ms' do
    it 'Создание объекта с помощью фабрики декодирования' do
      expect(DestinationAddress.decode_ms('0001000b919721436587F9000812041F04400438043204350442002100210021')).to be_an_instance_of DestinationAddress
    end
    it 'Проверяем корректность декодирования' do
      expect(DestinationAddress.decode_ms('0001000b919721436587F9000812041F04400438043204350442002100210021').frozen?).to be_truthy
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверяем корректность выделение блока da из pdu пакета (MS)' do
      expect(DestinationAddress.cut_off_pdu('0001000b919721436587F9000812041F04400438043204350442002100210021')).to eq(['0b919721436587F9', '000812041F04400438043204350442002100210021'])
    end
  end

  describe '.get_hex' do
    it 'Получаем PDU кодированную строку' do
      expect(DestinationAddress.encode_ms('+79851488398').get_hex).to eq('0B919758418893F8')
    end
  end

  describe '._address_length' do
    it 'Длина номера в международном формате' do
      expect(DestinationAddress.encode_ms('+71234567890').send(:_address_length)).to eq('0B')
    end
    it 'Длина номера в местном формате ' do
      expect(DestinationAddress.encode_ms('81234567890').send(:_address_length)).to eq('0B')
    end
  end

  describe '._set_pdu_hex' do
    it 'Проверяем корректность декодирования PDU пакета' do
      expect(DestinationAddress.new.send(:_set_pdu_hex, '0b919721436587F9').get_phone_number).to eq('+79123456789')
    end
  end
end