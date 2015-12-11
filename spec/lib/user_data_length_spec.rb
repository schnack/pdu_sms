require_relative '../../spec/spec_helper'

describe UserDataLength do

  describe '.initialize' do
    it 'Создаем объект' do
      expect(UserDataLength.new(:encode_ms, UserData.encode_ms('hello')[0])).to be_an_instance_of UserDataLength
    end
  end

  describe '.encode_ms' do
    it 'Создаем объект с помощью фабрики' do
      expect(UserDataLength.encode_ms(UserData.encode_ms('hello')[0])).to be_an_instance_of UserDataLength
      expect(UserDataLength.encode_ms(UserData.encode_ms('hello')[0]).frozen?).to be_truthy
    end
  end

  describe '.decode_ms' do
    it 'Создаем объект с помощью фабрики' do
      expect(UserDataLength.decode_ms('0001000B919721436587F9000812041F04400438043204350442002100210021')).to be_an_instance_of UserDataLength
      expect(UserDataLength.decode_ms('0001000B919721436587F9000812041F04400438043204350442002100210021').frozen?).to be_truthy
    end
  end

  describe '.encode_sс' do
    it 'Создаем объект с помощью фабрики' do
      expect(UserDataLength.encode_sc(UserData.encode_ms('hello')[0])).to be_an_instance_of UserDataLength
      expect(UserDataLength.encode_sc(UserData.encode_ms('hello')[0]).frozen?).to be_truthy
    end
  end

  describe '.decode_sс' do
    it 'Создаем объект с помощью фабрики' do
      expect(UserDataLength.decode_sc('0041030b919758418893F80000840608048f840404653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFD0B')).to be_an_instance_of UserDataLength
      expect(UserDataLength.decode_sc('0041030b919758418893F80000840608048f840404653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFD0B').frozen?).to be_truthy
    end
  end

  describe '.cut_off_pdu' do
    it 'Выделяем udl из пакета pdu MS' do
      expect(ProtocolIdentifier.cut_off_pdu('0001000B919721436587F9000812041F04400438043204350442002100210021', :all, :ms)).to eq(['00', '0812041F04400438043204350442002100210021'])
    end
    it 'Выделяем udl из пакета pdu SC' do
      expect(ProtocolIdentifier.cut_off_pdu('0041030b919758418893F80000840608048f840404653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFD0B', :all, :sc)).to eq(['58', '418893F80000840608048f840404653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFD0B'])
    end
    it 'Ошибка создания' do
      expect(->{ProtocolIdentifier.cut_off_pdu('0041030b919758418893F80000840608048f840404653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFD0B', :all, :error)}).to raise_exception ArgumentError
    end
  end

  describe '._count_message' do
    it '7bit' do
      expect(UserDataLength.new(:encode_ms, UserData.encode_ms('hello')[0]).send(:_count_message, UserData.encode_ms('hello', ALPHABET_7BIT)[0])).to eq('05')
    end
    it '8bit' do
      expect(UserDataLength.new(:encode_ms, UserData.encode_ms('hello')[0]).send(:_count_message, UserData.encode_ms('hello', ALPHABET_8BIT)[0])).to eq('05')
    end
    it '16bit' do
      expect(UserDataLength.new(:encode_ms, UserData.encode_ms('hello')[0]).send(:_count_message, UserData.encode_ms('hello', ALPHABET_16BIT)[0])).to eq('0A')
    end
    it '7bit long_sms' do
      expect(UserDataLength.new(:encode_ms, UserData.encode_ms('hello')[0]).send(:_count_message, UserData.encode_ms('hello'*40, ALPHABET_7BIT)[0])).to eq('A0')
    end
    it '8bit long_sms' do
      expect(UserDataLength.new(:encode_ms, UserData.encode_ms('hello')[0]).send(:_count_message, UserData.encode_ms('hello'*40, ALPHABET_8BIT)[0])).to eq('8B')
    end
    it '16bit long_sms' do
      expect(UserDataLength.new(:encode_ms, UserData.encode_ms('hello')[0]).send(:_count_message, UserData.encode_ms('hello'*40, ALPHABET_16BIT)[0])).to eq('8C')
    end
  end

  describe '.get_hex' do
    it 'sss' do
      expect(UserDataLength.encode_ms(UserData.encode_ms('hello')[0]).get_hex).to eq('05')
    end
  end

end