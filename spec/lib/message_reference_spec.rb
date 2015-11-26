require_relative '../../spec/spec_helper'

describe MessageReference do

  describe '.initialize' do
    it 'Создание объекта' do
      expect(MessageReference.new(0)).to be_an_instance_of MessageReference
      expect(MessageReference.new(255)).to be_an_instance_of MessageReference
    end
    it 'Ошибка при создании объекта если указанно не верное значение' do
      expect(-> {MessageReference.new(-1)} ).to raise_exception ArgumentError
      expect(-> {MessageReference.new(256)} ).to raise_exception ArgumentError
    end
  end

  describe '.encode_ms' do
    it 'Создание объекта при помощи фабрики кодирования PDU (MS)' do
      expect(MessageReference.encode_ms(0)).to be_an_instance_of MessageReference
      expect(MessageReference.encode_ms(255)).to be_an_instance_of MessageReference
      expect(MessageReference.encode_ms(150).frozen?).to be_truthy
    end
  end

  describe '.decode_ms' do
    it 'Создание объекта при помощи фабрики декодирования PDU (MS)' do
      expect(MessageReference.decode_ms('07919701879999F901000B919721436587F9000812041F04400438043204350442002100210021')).to be_an_instance_of MessageReference
      expect(MessageReference.decode_ms('07919701879999F901000B919721436587F9000812041F04400438043204350442002100210021').frozen?).to be_truthy
      expect(MessageReference.decode_ms('07919701879999F901000B919721436587F9000812041F04400438043204350442002100210021').get_hex).to eq('00')
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверяем корректность выделение блока dcs из mr пакета' do
      expect(MessageReference.cut_off_pdu('07919701879999F901000B919721436587F9000812041F04400438043204350442002100210021', :all)).to eq(['00', '0B919721436587F9000812041F04400438043204350442002100210021'])
    end
  end

  describe '.get_hex' do
    it 'Получаем PDU  строку' do
      expect(MessageReference.encode_ms(0).get_hex).to eq('00')
      expect(MessageReference.encode_ms(255).get_hex).to eq('ff')
    end
  end

  describe '.get_mr' do
    it 'Получаем значение mr' do
      expect(MessageReference.encode_ms(0).get_mr).to eq(0)
    end
  end

end