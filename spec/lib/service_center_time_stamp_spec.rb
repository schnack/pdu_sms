require_relative '../../spec/spec_helper'

describe 'ServiceCenterTimeStamp' do

  describe '.instance' do
    it 'Создание объекта с корректными параметрами' do
      expect(ServiceCenterTimeStamp.new(:encode_sc,  1444220280)).to be_an_instance_of ServiceCenterTimeStamp
    end
    it 'Создание объекта с ошибочными параметрами' do
      expect(-> { ServiceCenterTimeStamp.new(:Error, 1444220280) } ).to raise_exception ArgumentError
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверяем корректное выделение для мобильной станции без времени' do
      expect(ServiceCenterTimeStamp.cut_off_pdu('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904', :all, :ms)).to eq(['21106232015061', '0CC8329BFD065DDF72363904'])
    end
  end

  describe '.encode_sc' do
    it 'Проверяем корректную кодировку от смс центра' do
      expect(ServiceCenterTimeStamp.encode_sc(1444220280)).to be_an_instance_of ServiceCenterTimeStamp
    end
  end

  describe '.encode_sc' do
    it 'Проверяем корректную кодировку от смс центра' do
      expect(ServiceCenterTimeStamp.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')).to be_an_instance_of ServiceCenterTimeStamp
    end
  end

  describe '._absolute_timestamp' do
    before :each do
      @scts = ServiceCenterTimeStamp.new(:encode_sc, 1444220280)
    end
    it 'check absolute date'do
      expect(@scts.send(:_absolute_timestamp, 1442388200)).to eq('51906101320221')
    end
  end

  describe '._absolute_pdu' do
    before :each do
      @scts = ServiceCenterTimeStamp.new(:encode_sc, 1444220280)
    end
    it 'check _absolute_pdu' do
      expect(@scts.send(:_absolute_pdu, '51906101320221')).to eq(1442388200)
    end
  end

  describe '.get_hex' do
    it 'Получаем pdu пакет' do
      expect(ServiceCenterTimeStamp.encode_sc(1444220280).get_hex).to eq('51017051810021')
    end
  end

  describe '.get_time' do
    it 'Получаем время из pdu пакета' do
      expect(ServiceCenterTimeStamp.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904').get_time).to eq(1327605005)
    end
  end

end