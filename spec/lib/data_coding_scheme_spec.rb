require_relative '../../spec/spec_helper'

describe DataCodingScheme do

  describe '.initialize' do
    it 'Создание объекта с параметрами по умолчанию' do
      expect(DataCodingScheme.new(:decode_ms)).to be_an_instance_of(DataCodingScheme)
    end
    it 'Создание объекта с корректно заданным параметром "compressed"' do
      expect(DataCodingScheme.new(:decode_ms, compressed:0)).to be_an_instance_of(DataCodingScheme)
      expect(DataCodingScheme.new(:decode_ms, compressed:1)).to be_an_instance_of(DataCodingScheme)
    end
    it 'Создание объекта с некорректно заданным параметром "compressed"' do
      expect(-> {DataCodingScheme.new(:decode_ms, compressed:-1)}).to raise_exception ArgumentError
      expect(-> {DataCodingScheme.new(:decode_ms, compressed:2)}).to raise_exception ArgumentError
      expect(-> {DataCodingScheme.new(:decode_ms, compressed:false)}).to raise_exception ArgumentError
    end
    it 'Создание объекта с корректно заданным параметром "alphabet"' do
      expect(DataCodingScheme.new(:decode_ms, alphabet:0)).to be_an_instance_of(DataCodingScheme)
      expect(DataCodingScheme.new(:decode_ms, alphabet:1)).to be_an_instance_of(DataCodingScheme)
      expect(DataCodingScheme.new(:decode_ms, alphabet:2)).to be_an_instance_of(DataCodingScheme)
      expect(DataCodingScheme.new(:decode_ms, alphabet:3)).to be_an_instance_of(DataCodingScheme)
    end
    it 'Создание объекта с некорректно заданным параметром "alphabet"' do
      expect(-> {DataCodingScheme.new(:decode_ms, alphabet:-1)}).to raise_exception ArgumentError
      expect(-> {DataCodingScheme.new(:decode_ms, alphabet:4)}).to raise_exception ArgumentError
      expect(-> {DataCodingScheme.new(:decode_ms, alphabet:false)}).to raise_exception ArgumentError
    end
    it 'Создание объекта с корректно заданным параметром "message_class"' do
      expect(DataCodingScheme.new(:decode_ms, message_class:false)).to be_an_instance_of(DataCodingScheme)
      expect(DataCodingScheme.new(:decode_ms, message_class:0)).to be_an_instance_of(DataCodingScheme)
      expect(DataCodingScheme.new(:decode_ms, message_class:1)).to be_an_instance_of(DataCodingScheme)
      expect(DataCodingScheme.new(:decode_ms, message_class:2)).to be_an_instance_of(DataCodingScheme)
      expect(DataCodingScheme.new(:decode_ms, message_class:3)).to be_an_instance_of(DataCodingScheme)
    end
    it 'Создание объекта с некорректно заданным параметром "message_class"' do
      expect(-> {DataCodingScheme.new(:decode_ms, message_class:-1)}).to raise_exception ArgumentError
      expect(-> {DataCodingScheme.new(:decode_ms, message_class:4)}).to raise_exception ArgumentError
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверим корректность выделения блока dcs из pdu пакета (MS)' do
      expect(DataCodingScheme.cut_off_pdu('0001000B919721436587F9000812041F04400438043204350442002100210021', :all, :ms)).to eq(['08', '12041F04400438043204350442002100210021'])
    end
    it 'Проверим корректность выделение блока dcs из pdu пакета (SC)' do
      expect(DataCodingScheme.cut_off_pdu('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904', :all, :sc)).to eq(['00', '211062320150610CC8329BFD065DDF72363904'])
    end
  end

  describe '.encode_ms' do
    it 'Создание объекта при помощи фабрики кодирования PDU (MS)' do
      expect(DataCodingScheme.encode_ms).to be_an_instance_of DataCodingScheme
      expect(DataCodingScheme.encode_ms.frozen?).to be_truthy
    end
  end

  describe '.decode_ms' do
    it 'Создание объекта при помощи фабрики декодирования PDU (MS)' do
      expect(DataCodingScheme.decode_ms('0001000B919721436587F9000812041F04400438043204350442002100210021')).to be_an_instance_of DataCodingScheme
      expect(DataCodingScheme.decode_ms('0001000B919721436587F9000812041F04400438043204350442002100210021').frozen?).to be_truthy
    end
  end

  describe '.encode_sc' do
    it 'Создание объекта при помощи фабрики кодирования PDU (SC)' do
      expect(DataCodingScheme.encode_sc).to be_an_instance_of DataCodingScheme
      expect(DataCodingScheme.encode_sc.frozen?).to be_truthy
    end
  end

  describe '.decode_sc' do
    it 'Создание объекта при помощи фабрики декодирования PDU (SC)' do
      expect(DataCodingScheme.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')).to be_an_instance_of DataCodingScheme
      expect(DataCodingScheme.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904').frozen?).to be_truthy
    end
  end


  describe '.compressed?' do
    it 'Установлен параметр compressed' do
      expect(DataCodingScheme.encode_ms(compressed:0).compressed?).to be_falsey
      expect(DataCodingScheme.encode_ms(compressed:1).compressed?).to be_truthy
    end
  end

  describe '.alphabet_7bit?' do
    it 'Указана 7бит кодировка' do
      expect(DataCodingScheme.encode_ms(alphabet:0).alphabet_7bit?).to be_truthy
      expect(DataCodingScheme.encode_ms(alphabet:1).alphabet_7bit?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:2).alphabet_7bit?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:3).alphabet_7bit?).to be_falsey
    end
  end

  describe '.alphabet_8bit?' do
    it 'Указана 8бит кодировка' do
      expect(DataCodingScheme.encode_ms(alphabet:0).alphabet_8bit?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:1).alphabet_8bit?).to be_truthy
      expect(DataCodingScheme.encode_ms(alphabet:2).alphabet_8bit?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:3).alphabet_8bit?).to be_falsey
    end
  end

  describe '.alphabet_16bit?' do
    it 'Указана 16бит кодировка' do
      expect(DataCodingScheme.encode_ms(alphabet:0).alphabet_16bit?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:1).alphabet_16bit?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:2).alphabet_16bit?).to be_truthy
      expect(DataCodingScheme.encode_ms(alphabet:3).alphabet_16bit?).to be_falsey
    end
  end

  describe '.alphabet_reserved?' do
    it 'Зарезервированный параметр' do
      expect(DataCodingScheme.encode_ms(alphabet:0).alphabet_reserved?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:1).alphabet_reserved?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:2).alphabet_reserved?).to be_falsey
      expect(DataCodingScheme.encode_ms(alphabet:3).alphabet_reserved?).to be_truthy
    end
  end

  describe '.message_class?' do
    it 'Установлен параметр message_class' do
      expect(DataCodingScheme.encode_ms(message_class:false).message_class?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:0).message_class?).to be_truthy
      expect(DataCodingScheme.encode_ms(message_class:1).message_class?).to be_truthy
      expect(DataCodingScheme.encode_ms(message_class:2).message_class?).to be_truthy
      expect(DataCodingScheme.encode_ms(message_class:3).message_class?).to be_truthy
    end
  end

  describe '.message_class_immediate_display?' do
    it 'Установлен 0 класс сообщения' do
      expect(DataCodingScheme.encode_ms(message_class:false).message_class_immediate_display?).to be_truthy
      expect(DataCodingScheme.encode_ms(message_class:0).message_class_immediate_display?).to be_truthy
      expect(DataCodingScheme.encode_ms(message_class:1).message_class_immediate_display?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:2).message_class_immediate_display?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:3).message_class_immediate_display?).to be_falsey
    end
  end

  describe '.message_class_me?' do
    it 'Установлен 1 класс сообщения' do
      expect(DataCodingScheme.encode_ms(message_class:false).message_class_me?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:0).message_class_me?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:1).message_class_me?).to be_truthy
      expect(DataCodingScheme.encode_ms(message_class:2).message_class_me?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:3).message_class_me?).to be_falsey
    end
  end

  describe '.message_class_sim?' do
    it 'Установлен 2 класс собщения' do
      expect(DataCodingScheme.encode_ms(message_class:false).message_class_sim?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:0).message_class_sim?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:1).message_class_sim?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:2).message_class_sim?).to be_truthy
      expect(DataCodingScheme.encode_ms(message_class:3).message_class_sim?).to be_falsey
    end
  end

  describe '.message_class_te?' do
    it 'Установлен 3 класс сообщения' do
      expect(DataCodingScheme.encode_ms(message_class:false).message_class_te?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:0).message_class_te?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:1).message_class_te?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:2).message_class_te?).to be_falsey
      expect(DataCodingScheme.encode_ms(message_class:3).message_class_te?).to be_truthy
    end
  end

  describe '.get_compressed' do
    it 'Получаем значение параметра "compressed"' do
      expect(DataCodingScheme.encode_ms.get_compressed).to eq('0')
    end
  end

  describe '.get_alphabet' do
    it 'Получаем значение параметра "alphabet"' do
      expect(DataCodingScheme.encode_ms.get_alphabet).to eq('10')
    end
  end

  describe '.get_message_class_trigger' do
    it 'Получаем значение параметра "message_class"' do
      expect(DataCodingScheme.encode_ms.get_message_class_trigger).to eq('0')
    end
  end

  describe '.get_message_class' do
    it 'Получаем класс сообщения "message_class"' do
      expect(DataCodingScheme.encode_ms.get_message_class).to eq('00')
    end
  end

  describe '.get_hex' do
    it 'Получаем кодированную строку PDU' do
      expect(DataCodingScheme.encode_ms.get_hex).to eq('08')
    end
  end

  describe  '.get_bit0' do
    it 'Константа должны быть равна 00' do
      expect(DataCodingScheme.encode_ms.get_bit0).to eq('00')
    end

  end

end