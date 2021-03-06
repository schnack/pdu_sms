require_relative '../../spec/spec_helper'

include PduSms::Helpers

describe PduSms::Helpers do

  describe '.encode_bcd' do

    it 'Проверяем кодирование в BCD' do
      expect(Helpers.encode_bcd('123456')).to eq('214365')
    end

    it 'Не четное количество символов в строке' do
      expect(-> {Helpers.encode_bcd('12345')} ).to raise_exception ArgumentError
    end

    it 'Параметр не является строкой' do
      expect(-> {Helpers.encode_bcd(123456)} ).to raise_exception ArgumentError
    end

  end

  describe '.decode_bcd' do

    it 'Декодирование строки BCD' do
      expect(Helpers.decode_bcd('214365')).to eq('123456')
    end

    it 'Не четное количество символов в строке' do
      expect(-> {Helpers.decode_bcd('12345')} ).to raise_exception ArgumentError
    end

    it 'Параметр не является строкой' do
      expect(-> {Helpers.decode_bcd(123456)} ).to raise_exception ArgumentError
    end

  end

  describe '.decode_ucs2' do
    it 'Декодирование ucs2 строки' do
      expect(Helpers.decode_ucs2('041F04400438043204350442002100210021')).to eq('Привет!!!')
    end
  end

  describe '.encode_ucs2' do
    it 'Кодирование строки в usc2' do
      expect(Helpers.encode_ucs2('Привет!!!')).to eq('041F04400438043204350442002100210021')
    end
  end

  describe '.is_7bit?' do
    it 'Проверяем возможность кодирования строки в 7бит кодировку' do
      expect(Helpers.is_7bit?('Привет!!!')).to be_falsey
      expect(Helpers.is_7bit?('hello')).to be_truthy
    end
  end

  describe '.encode_7bit' do
    it 'Кодирование строки в 7бит формат' do
      expect(Helpers.encode_7bit('Hello!!!')).to eq('C8329BFD0E8542')
      expect(Helpers.encode_7bit('beeline')).to eq('E272999D769701')
    end
  end

  describe '.decode_7bit' do
    it 'Декодирование 7бит строки' do
      expect(Helpers.decode_7bit('C8329BFD0E8542')).to eq('Hello!!!')
      expect(Helpers.decode_7bit('E272999D769701')).to eq('beeline')
    end
  end

  describe '.encode_8bit' do
    it 'Кодирование строки в 8бит формат' do
      expect(Helpers.encode_8bit('Hello!!!')).to eq('48656C6C6F212121')
    end
  end

  describe '.decode_8bit' do
    it 'Декодирование 8бит строки' do
      expect(Helpers.decode_8bit('48656C6C6F212121')).to eq('Hello!!!')
    end
  end

  describe '.decode_7bit_fill_bits' do
    it 'Декодирование 7бит строки c битом заполнения' do
      expect(Helpers.decode_7bit_fill_bits('A8E5391D', '05')).to eq('Test')
    end
  end

  describe '.encode_7bit_fill_bits' do
    it 'Кодирование 7бит строки c битом заполнения' do
      expect(Helpers.encode_7bit_fill_bits('Test', '05')).to eq('A8E5391D')
    end
  end

end