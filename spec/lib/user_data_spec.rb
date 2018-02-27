require_relative '../../spec/spec_helper'

describe UserData do

  describe '._check_message' do
    before :each do
      @ud = UserData.new('test', ALPHABET_7BIT)
    end
    it 'Ошибка проверки на тип строки и кодировку' do
      expect(-> { @ud.send(:_check_message, 123, ALPHABET_7BIT) } ).to raise_exception ArgumentError
      expect(-> { @ud.send(:_check_message, '123'.encode(Encoding::ISO_8859_1), ALPHABET_7BIT) } ).to raise_exception ArgumentError
    end
    it 'Ошибка сообщение слишком длинное' do
      expect(-> { @ud.send(:_check_message, '1234567890'*17, ALPHABET_7BIT) } ).to raise_exception ArgumentError
      expect(-> { @ud.send(:_check_message, '1234567890'*15, ALPHABET_8BIT) } ).to raise_exception ArgumentError
      expect(-> { @ud.send(:_check_message, '1234567890'*8, ALPHABET_16BIT) } ).to raise_exception ArgumentError
    end
    it 'Ошибка сообщение слишком длинное для нескольких смс' do
      expect(-> { @ud.send(:_check_message, '1234567890'*16, ALPHABET_7BIT, 1) } ).to raise_exception ArgumentError
      expect(-> { @ud.send(:_check_message, '1234567890'*14, ALPHABET_8BIT, 1) } ).to raise_exception ArgumentError
      expect(-> { @ud.send(:_check_message, '1234567890'*7, ALPHABET_16BIT, 1) } ).to raise_exception ArgumentError
    end
    it 'Ошибка не корректная кодировка' do
      expect(-> { @ud.send(:_check_message, '1234567890', -1, 1) } ).to raise_exception ArgumentError
    end
    it 'Нормальная работа' do
      expect(@ud.send(:_check_message, '1234567890', ALPHABET_7BIT)).to eq('1234567890')
      expect(@ud.send(:_check_message, '1234567890', ALPHABET_8BIT)).to eq('1234567890')
      expect(@ud.send(:_check_message, '1234567890', ALPHABET_16BIT)).to eq('1234567890')
      expect(@ud.send(:_check_message, '1234567890', ALPHABET_7BIT, 1)).to eq('1234567890')
      expect(@ud.send(:_check_message, '1234567890', ALPHABET_8BIT, 1)).to eq('1234567890')
      expect(@ud.send(:_check_message, '1234567890', ALPHABET_16BIT, 1)).to eq('1234567890')
    end
  end

  describe '._check_coding' do
    before :each do
      @ud = UserData.new('test', ALPHABET_7BIT)
    end
    it 'Ошибка кодировка указана не верно' do
      expect(-> { @ud.send(:_check_coding, -1) } ).to raise_exception ArgumentError
      expect(-> { @ud.send(:_check_coding, 3) } ).to raise_exception ArgumentError
    end
    it 'Нормальная работа' do
      expect(@ud.send(:_check_coding, ALPHABET_7BIT)).to eq(0)
      expect(@ud.send(:_check_coding, ALPHABET_8BIT)).to eq(1)
      expect(@ud.send(:_check_coding, ALPHABET_16BIT)).to eq(2)
    end
  end

  describe '._check_ied1' do
    before :each do
      @ud = UserData.new('test', ALPHABET_7BIT)
    end
    it 'Ошибка слишком большое значение' do
      expect(->{ @ud.send(:_check_ied1, 'FFFF1')}).to raise_exception ArgumentError
    end
    it 'Нормальная работа' do
      expect(@ud.send(:_check_ied1, 'FFFF')).to eq('FFFF')
    end
  end

  describe '._check_ied2' do
    before :each do
      @ud = UserData.new('test', ALPHABET_7BIT)
    end
    it 'Ошибка слишком большое значение для заданной кодировки' do
      expect(->{ @ud.send(:_check_ied2, -1) }).to raise_exception ArgumentError
      expect(->{ @ud.send(:_check_ied2, 256) }).to raise_exception ArgumentError
    end
    it 'Нормальная работа' do
      expect(@ud.send(:_check_ied2, 0)).to eq(0)
      expect(@ud.send(:_check_ied2, 255)).to eq(255)
      expect(@ud.send(:_check_ied2, false)).to be_falsey
    end
  end

  describe '._check_ied3' do
    before :each do
      @ud = UserData.new('test', ALPHABET_7BIT)
    end
    it 'Ошибка слишком большое значение для заданной кодировки' do
      expect(->{ @ud.send(:_check_ied3, -1) }).to raise_exception ArgumentError
      expect(->{ @ud.send(:_check_ied3, 256) }).to raise_exception ArgumentError
    end
    it 'Нормальная работа' do
      expect(@ud.send(:_check_ied3, 0)).to eq(0)
      expect(@ud.send(:_check_ied3, 255)).to eq(255)
      expect(@ud.send(:_check_ied3, false)).to be_falsey
    end
  end

  describe '._check_udhl' do
    before :each do
      @ud = UserData.new('test', ALPHABET_7BIT)
    end
    it 'Получаем Udhl' do
      expect(@ud.send(:_check_udhl, 'FF01')).to eq(6)
      expect(@ud.send(:_check_udhl, '01')).to eq(5)
      expect(@ud.send(:_check_udhl, false)).to be_falsey
    end
  end

  describe '._check_iei' do
    before :each do
      @ud = UserData.new('test', ALPHABET_7BIT)
    end
    it 'Получаем iei' do
      expect(@ud.send(:_check_iei, 'FFFF')).to eq(8)
      expect(@ud.send(:_check_iei, 'FF')).to eq(0)
      expect(@ud.send(:_check_iei, false)).to be_falsey
    end
  end

  describe '._check_iedl' do
    before :each do
      @ud = UserData.new('test', ALPHABET_7BIT)
    end
    it 'Получаем iei' do
      expect(@ud.send(:_check_iedl, 'FFFF')).to eq(4)
      expect(@ud.send(:_check_iedl, 'FF')).to eq(3)
      expect(@ud.send(:_check_iedl, false)).to be_falsey
    end
  end

  describe '.initialize' do
    it 'Получаем объект по умолчанию' do
      expect(UserData.new('hello', ALPHABET_7BIT)).to be_an_instance_of UserData
    end
  end

  describe '.get_message' do
    it 'Получаем сообщение' do
      expect(UserData.new('Привет', ALPHABET_16BIT).get_message).to eq('Привет')
    end
  end

  describe '.get_coding' do
    it 'Получаем кодировку' do
      expect(UserData.new('Привет', ALPHABET_16BIT).get_coding).to eq(ALPHABET_16BIT)
    end
  end

  describe '.get_hex' do
    it 'Получаем одиночное без заголовков' do
      expect(UserData.new('Hello!!!', ALPHABET_7BIT).get_hex).to eq('C8329BFD0E8542')
      expect(UserData.new('Hello!!!', ALPHABET_8BIT).get_hex).to eq('48656C6C6F212121')
      expect(UserData.new('Hello!!!', ALPHABET_16BIT).get_hex).to eq('00480065006C006C006F002100210021')
    end
    it 'Получаем а теперь группа сообщений с заголовками' do
      expect(UserData.new('Hello!!!', ALPHABET_7BIT, ied1:'007B', ied2:2, ied3:1).get_hex).to eq('060804007B0201C8329BFD0E8542')
      expect(UserData.new('Hello!!!', ALPHABET_8BIT, ied1:'007B', ied2:2, ied3:1).get_hex).to eq('060804007B020148656C6C6F212121')
      expect(UserData.new('Hello!!!', ALPHABET_16BIT, ied1:'7B', ied2:2, ied3:1).get_hex).to eq('0500037B020100480065006C006C006F002100210021')
    end
  end

  describe '.encode_ms' do
    it 'Создаем короткое сообщение без заголовков' do
      ud = UserData.encode_ms('Hello!!!')
      expect(ud).to be_an_instance_of Array
      expect(ud.length).to eq(1)
      expect(ud[0].get_coding).to eq(ALPHABET_7BIT)
      expect(ud[0].get_hex).to eq('C8329BFD0E8542')
      expect(ud[0].frozen?).to be_truthy
    end
    it 'Создание нескольких смс автоопределение кодировки' do
      ud = UserData.encode_ms('1234567890'*22)
      expect(ud.length).to eq(2)
      expect(ud[0].get_ied2).to eq('02')
      expect(ud[1].get_ied2).to eq('02')
      expect(ud[0].get_ied3).to eq('01')
      expect(ud[1].get_ied3).to eq('02')
    end
    it 'Создаем объекты в разных кодировках' do
      expect(UserData.encode_ms('Hello'*30, ALPHABET_7BIT).length).to eq(1)
      expect(UserData.encode_ms('Hello'*30, ALPHABET_8BIT).length).to eq(2)
      expect(UserData.encode_ms('Hello'*30, ALPHABET_16BIT).length).to eq(3)
    end
    it 'Ошибка при некорректно указаной кодировке' do
      expect(->{ UserData.encode_ms('hello', -1)}).to raise_exception ArgumentError
    end
  end

  describe '.cut_off_pdu' do
    it 'Сообщение без пользовательского заголовка' do
      expect(UserData.cut_off_pdu('0001000B919721436587F9000812041F04400438043204350442002100210021', :all, :ms)).to eq(['', '041F04400438043204350442002100210021'])
    end
    it 'Длинное сообщение с пользовательским заголовком' do
      expect(UserData.cut_off_pdu('0041030b919758418893F80000840608048f840404653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFD0B', :all, :ms)).to eq(['0608048f840404', '653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFD0B'])
    end
  end

  describe '.decode_ms' do
    it 'Перекодируем сообщение' do
      ud = UserData.decode_ms('07919701879999F901000B919721436587F9000812041F04400438043204350442002100210021')
      expect(ud.get_coding).to eq(ALPHABET_16BIT)
      expect(ud.get_message).to eq('Привет!!!')
      expect(ud.frozen?).to be_truthy
    end
    it 'Определение нескольких сообщений' do
      ud = UserData.decode_ms('0041030b919758418893F80000840608048f840404653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFDFBA596E7747A194FFF7EA9E5399D5EC6D3BF5F6A794EA797F1F4EF975A9ED3E9653CFD0B')
      expect(ud.get_coding).to eq(ALPHABET_7BIT)
      expect(ud.get_message).to eq('ext__Testtext__Testtext__Testtext__Testtext__Testtext__Testtext__Testtext__Testtext__Testtext__Testtext__Testtext__Testtext_')
      expect(ud.get_ied2).to eq('04')
      expect(ud.get_ied3).to eq('04')
    end
  end

  describe '.encode_sc' do
    it 'Создаемм короткое сообщение без заголовков' do
      ud = UserData.encode_sc('Hello!!!')
      expect(ud).to be_an_instance_of Array
      expect(ud.length).to eq(1)
      expect(ud[0].get_coding).to eq(ALPHABET_7BIT)
      expect(ud[0].get_hex).to eq('C8329BFD0E8542')
      expect(ud[0].frozen?).to be_truthy
    end
    it 'Создание нескольких смс автоопределение кодировки' do
      ud = UserData.encode_sc('1234567890'*22)
      expect(ud.length).to eq(2)
      expect(ud[0].get_ied2).to eq('02')
      expect(ud[1].get_ied2).to eq('02')
      expect(ud[0].get_ied3).to eq('01')
      expect(ud[1].get_ied3).to eq('02')
    end
    it 'Создаем объекты в разных кодировках' do
      expect(UserData.encode_sc('Hello'*30, ALPHABET_7BIT).length).to eq(1)
      expect(UserData.encode_sc('Hello'*30, ALPHABET_8BIT).length).to eq(2)
      expect(UserData.encode_sc('Hello'*30, ALPHABET_16BIT).length).to eq(3)
    end
    it 'Ошибка при некорректно указанной кодировке' do
      expect(->{ UserData.encode_sc('hello', -1)}).to raise_exception ArgumentError
    end
  end

  describe '.decode_sc' do
    it 'Перекодируем сообщение' do
      ud = UserData.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')
      expect(ud.get_coding).to eq(ALPHABET_7BIT)
      expect(ud.get_message).to eq('Hello World!')
      expect(ud.frozen?).to be_truthy
    end
  end

  describe '.get_ied1' do
    it 'Получаем все значения' do
      expect(UserData.new('Hello', ALPHABET_7BIT).get_ied1).to eq('')
      expect(UserData.new('Hello', ALPHABET_7BIT, ied1:'FFFF', ied2:2, ied3:1).get_ied1).to eq('FFFF')
      expect(UserData.new('Hello', ALPHABET_8BIT, ied1:'FF', ied2:2, ied3:1).get_ied1).to eq('FF')
      expect(UserData.new('Hello', ALPHABET_16BIT, ied1:'FF', ied2:2, ied3:1).get_ied1).to eq('FF')
    end
  end

  describe '.get_ied2' do
    it 'Получаем все значения' do
      expect(UserData.new('Hello', ALPHABET_7BIT).get_ied2).to eq('')
      expect(UserData.new('Hello', ALPHABET_8BIT, ied1:'FF', ied2:2, ied3:1).get_ied2).to eq('02')

    end
  end

  describe '.get_ied3' do
    it 'Получаем все значения' do
      expect(UserData.new('Hello', ALPHABET_7BIT).get_ied3).to eq('')
      expect(UserData.new('Hello', ALPHABET_8BIT, ied1:'FF', ied2:2, ied3:1).get_ied3).to eq('01')
    end
  end

  describe '.get_udhl' do
    it 'Получаем все значения' do
      expect(UserData.new('Hello', ALPHABET_7BIT).get_udhl).to eq('')
      expect(UserData.new('Hello', ALPHABET_8BIT, ied1:'FFFF', ied2:2, ied3:1).get_udhl).to eq('06')
    end
  end

  describe '.get_iei' do
    it 'Получаем все значения' do
      expect(UserData.new('Hello', ALPHABET_7BIT).get_iei).to eq('')
      expect(UserData.new('Hello', ALPHABET_8BIT, ied1:'FFFF', ied2:2, ied3:1).get_iei).to eq('08')
    end
  end

  describe '.get_iedl' do
    it 'Получаем все значения' do
      expect(UserData.new('Hello', ALPHABET_7BIT).get_iedl).to eq('')
      expect(UserData.new('Hello', ALPHABET_8BIT, ied1:'FFFF', ied2:2, ied3:1).get_iedl).to eq('04')
    end
  end

  describe '.is_udh?' do
    it 'Проверям был ли установлен заголовок или нет' do
      expect(UserData.new('Hello', ALPHABET_7BIT).is_udh?).to be_falsey
      expect(UserData.new('Hello', ALPHABET_8BIT, ied1:'FF', ied2:2, ied3:1).is_udh?).to be_truthy
    end
  end

  describe '.get_udh' do
    it 'Проверяем не установленный заголовок' do
      expect(UserData.new('Hello', ALPHABET_7BIT).get_udh).to eq(USER_DATA_HEADER_INCLUDED_0)
    end
    it 'Проверяем установленный заголовок' do
      expect(UserData.new('Hello', ALPHABET_7BIT, ied1:'FF', ied2:2, ied3:1).get_udh).to eq(USER_DATA_HEADER_INCLUDED_1)
    end
  end

end