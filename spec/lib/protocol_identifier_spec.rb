require_relative '../../spec/spec_helper'

describe ProtocolIdentifier do

  describe '.initialize' do
    it 'true' do
      expect(ProtocolIdentifier.new(0)).to be_an_instance_of ProtocolIdentifier
    end
    it 'true' do
      expect(ProtocolIdentifier.new(255)).to be_an_instance_of ProtocolIdentifier
    end
    it 'error' do
      expect(-> {ProtocolIdentifier.new(-1)}).to raise_exception ArgumentError
    end
    it 'error' do
      expect(-> {ProtocolIdentifier.new(256)}).to raise_exception ArgumentError
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверяем корректность выделение блока pid из pdu пакета MS' do
      expect(ProtocolIdentifier.cut_off_pdu('0001000B919721436587F9000812041F04400438043204350442002100210021', :all, :ms)).to eq(['00', '0812041F04400438043204350442002100210021'])
    end
    it 'Проверяем корректность выделение блока pid из pdu пакета SC' do
      expect(ProtocolIdentifier.cut_off_pdu('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904', :all, :sc)).to eq(['00', '00211062320150610CC8329BFD065DDF72363904'])
    end
    it 'Ошибка при не корректно передаче последнго параметра' do
      expect(->{ProtocolIdentifier.cut_off_pdu('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904', :all, :error)}).to raise_exception ArgumentError
    end
  end

  describe '.encode_ms' do
    it 'Создание объекта с помощью фабрики кодирования MS' do
      expect(ProtocolIdentifier.encode_ms(0)).to be_an_instance_of(ProtocolIdentifier)
      expect(ProtocolIdentifier.encode_ms.frozen?).to be_truthy
    end
  end

  describe '.decode_ms' do
    it 'Создание объекта с помощью фабрики декодирования MS' do
      expect(ProtocolIdentifier.decode_ms('0001000B919721436587F9000812041F04400438043204350442002100210021')).to be_an_instance_of ProtocolIdentifier
      expect(ProtocolIdentifier.decode_ms('0001000B919721436587F9000812041F04400438043204350442002100210021').frozen?).to be_truthy
    end
  end

  describe '.encode_sc' do
    it 'Создание объекта с помощью фабрики кодирования SC' do
      expect(ProtocolIdentifier.encode_sc(0)).to be_an_instance_of(ProtocolIdentifier)
      expect(ProtocolIdentifier.encode_sc.frozen?).to be_truthy
    end
  end

  describe '.decode_sc' do
    it 'Создание объекта с помощью фабрики декодирования SC' do
      expect(ProtocolIdentifier.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')).to be_an_instance_of ProtocolIdentifier
      expect(ProtocolIdentifier.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904').frozen?).to be_truthy
    end
  end

  describe '.get_hex' do
    it 'Получаем строку в формате PDU' do
      expect(ProtocolIdentifier.encode_ms.get_hex).to eq('00')
    end
  end

  describe '.get_pid' do
    it 'получаем значение pid' do
      expect(ProtocolIdentifier.encode_ms.get_pid).to eq(0)
    end
  end

end