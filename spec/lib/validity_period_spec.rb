require_relative '../../spec/spec_helper'

describe ValidityPeriod do

  describe '.instance' do
    it 'Создание объекта' do
      expect(ValidityPeriod.new(:encode_ms,  5, VALIDITY_PERIOD_FORMAT_10)).to be_an_instance_of ValidityPeriod
    end
    it 'Ошибочное создание объекта' do
      expect(-> { ValidityPeriod.new(:Error, 5,  VALIDITY_PERIOD_FORMAT_10) } ).to raise_exception ArgumentError
    end
    it 'Ошибочное создание объекта' do
      expect(-> { ValidityPeriod.new(:encode_ms, 5, :error) } ).to raise_exception ArgumentError
    end
    it 'Ошибочное создание объекта' do
      expect(-> { ValidityPeriod.new(:decode_ms, '12345') } ).to raise_exception ArgumentError
    end
  end

  describe '.encode_ms' do
    it 'Создание объекта с помощью фабрики' do
      expect(ValidityPeriod.encode_ms 5).to be_an_instance_of ValidityPeriod
    end
  end

  describe '.decode_ms' do
    it 'Создание объекта с помощью фабрики' do
      expect(ValidityPeriod.decode_ms '0011000b919721436587F900080012041F04400438043204350442002100210021').to be_an_instance_of ValidityPeriod
      expect(ValidityPeriod.decode_ms '0001000B919721436587F9000812041F04400438043204350442002100210021').to be_an_instance_of ValidityPeriod
      expect(ValidityPeriod.decode_ms '0019000b919721436587F900085101704140332112041F04400438043204350442002100210021').to be_an_instance_of ValidityPeriod
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверяем корректность выделение блока dcs из pdu пакета (MS)' do
      expect(ValidityPeriod.cut_off_pdu('0001000B919721436587F9000812041F04400438043204350442002100210021', :all, :ms)).to eq([false, '12041F04400438043204350442002100210021'])
    end
    it 'Проверяем корректность выделение блока dcs из pdu пакета (MS)' do
      expect(ValidityPeriod.cut_off_pdu('0011000b919721436587F900080012041F04400438043204350442002100210021', :all, :ms)).to eq(['00', '12041F04400438043204350442002100210021'])
    end
    it 'Проверяем корректность выделение блока dcs из pdu пакета (MS)' do
      expect(ValidityPeriod.cut_off_pdu('0019000b919721436587F900085101704140332112041F04400438043204350442002100210021', :all, :ms)).to eq(['51017041403321', '12041F04400438043204350442002100210021'])
    end
  end

  describe '.get_hex' do
    it 'Получаем pdu строку' do
      expect(ValidityPeriod.new(:encode_ms, 5).get_hex).to eq('00')
    end
    it 'Получаем pdu строку' do
      expect(ValidityPeriod.new(:encode_ms, 1442388200).get_hex).to eq('51906101320221')
    end
  end

  describe '.get_type_time' do
    it 'Проверяем тип номера относительный' do
      expect(ValidityPeriod.new(:encode_ms, 1442388200).get_type_time).to eq(VALIDITY_PERIOD_FORMAT_11)
    end
    it 'Проверяем тип номера абсолютный' do
      expect(ValidityPeriod.new(:encode_ms, 5).get_type_time).to eq(VALIDITY_PERIOD_FORMAT_10)
    end
    it 'Время не установленно' do
      expect(ValidityPeriod.new(:encode_ms, false).get_type_time).to be_falsey
    end
  end

  describe '.get_time' do
    it 'Проверяем тип номера относительный' do
      expect(ValidityPeriod.new(:encode_ms, 1442388200).get_time).to eq(1442388200)
    end
    it 'Проверяем тип номера абсолютный' do
      expect(ValidityPeriod.new(:encode_ms, 5).get_time).to eq(300)
    end
    it 'Проверяем тип номера абсолютный' do
      expect(ValidityPeriod.new(:encode_ms, false).get_time).to eq('')
    end
  end

  describe '.is_setup' do
    it 'Получаем тип формата' do
      expect(ValidityPeriod.new(:encode_ms, 5).is_setup).to eq(VALIDITY_PERIOD_FORMAT_10)
      expect(ValidityPeriod.new(:encode_ms, 6350403).is_setup).to eq(VALIDITY_PERIOD_FORMAT_11)
      expect(ValidityPeriod.new(:encode_ms, false).is_setup).to eq(VALIDITY_PERIOD_FORMAT_00)
    end
  end

  describe '._relative_seconds' do
    before :each do
      @vp = ValidityPeriod.new(:encode_ms,5)
    end
    it 'check boundary values 0 - 5 minutes' do
      expect(@vp.send(:_relative_seconds, 1*60)).to eq('00')
      expect(@vp.send(:_relative_seconds, 4*60)).to eq('00')
    end
    it 'check boundary values vp 0 to 143' do
      expect(@vp.send(:_relative_seconds, 5*60)).to eq('00')
      expect(@vp.send(:_relative_seconds, 9*60)).to eq('00')
      expect(@vp.send(:_relative_seconds, 719*60)).to eq('8e')
      expect(@vp.send(:_relative_seconds, 720*60)).to eq('8f')
    end
    it 'check check boundary values 721 - 749 minutes' do
      expect(@vp.send(:_relative_seconds, 721*60)).to eq('8f')
      expect(@vp.send(:_relative_seconds, 749*60)).to eq('8f')
    end
    it 'check boundary values vp 144 to 167' do
      expect(@vp.send(:_relative_seconds, 750*60)).to eq('90')
      expect(@vp.send(:_relative_seconds, 779*60)).to eq('90')
      expect(@vp.send(:_relative_seconds, 1439*60)).to eq('a6')
      expect(@vp.send(:_relative_seconds, 1440*60)).to eq('a7')
    end
    it 'check check boundary values 1441..2879 minutes' do
      expect(@vp.send(:_relative_seconds, 1441*60)).to eq('a7')
      expect(@vp.send(:_relative_seconds, 2879*60)).to eq('a7')
    end
    it 'check boundary values vp 168 to 196' do
      expect(@vp.send(:_relative_seconds, 2880*60)).to eq('a8')
      expect(@vp.send(:_relative_seconds, 2881*60)).to eq('a8')
      expect(@vp.send(:_relative_seconds, 43199*60)).to eq('c3')
      expect(@vp.send(:_relative_seconds, 43200*60)).to eq('c4')
    end
    it 'check check boundary values 43201..50399 minutes' do
      expect(@vp.send(:_relative_seconds, 43201*60)).to eq('c4')
      expect(@vp.send(:_relative_seconds, 50399*60)).to eq('c4')
    end
    it 'check boundary values vp 50400..635040' do
      expect(@vp.send(:_relative_seconds, 50400*60)).to eq('c5')
      expect(@vp.send(:_relative_seconds, 50401*60)).to eq('c5')
      expect(@vp.send(:_relative_seconds, 635039*60)).to eq('fe')
      expect(@vp.send(:_relative_seconds, 635040*60)).to eq('ff')
    end
  end

  describe '._relative_pdu' do
    before :each do
      @vp = ValidityPeriod.new(:encode_ms, 5)
    end
    it 'check 0..143' do
      expect(@vp.send(:_relative_pdu, '00')).to eq(5*60)
      expect(@vp.send(:_relative_pdu, '8f')).to eq(720*60)
    end
    it 'check 144..167' do
      expect(@vp.send(:_relative_pdu, '90')).to eq(750*60)
      expect(@vp.send(:_relative_pdu, 'a7')).to eq(1440*60)
    end
    it 'check 168..196' do
      expect(@vp.send(:_relative_pdu, 'a8')).to eq(2880*60)
      expect(@vp.send(:_relative_pdu, 'c4')).to eq(43200*60)
    end
    it 'check 197..255' do
      expect(@vp.send(:_relative_pdu, 'c5')).to eq(50400*60)
      expect(@vp.send(:_relative_pdu, 'ff')).to eq(635040*60)
    end
    it 'Прочее' do
      expect(-> { @vp.send(:_relative_pdu, '-1') } ).to raise_exception ArgumentError
      expect(-> { @vp.send(:_relative_pdu, '100') } ).to raise_exception ArgumentError
    end
  end

  describe '._absolute_timestamp' do
    before :each do
      @vp = ValidityPeriod.new(:encode_ms, 5)
    end
    it 'check absolute date'do
      expect(@vp.send(:_absolute_timestamp, 1442388200)).to eq('51906101320221')
    end
  end

  describe '._absolute_pdu' do
    before :each do
      @vp = ValidityPeriod.new(:encode_ms, 5)
    end
    it 'check' do
      expect(@vp.send(:_absolute_pdu, '51906101320221')).to eq(1442388200)
    end
  end

end