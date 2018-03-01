require_relative '../../spec/spec_helper'

describe Phone do

  before :each  do
    @phone = Phone.new
  end

  describe '.get_phone_number' do
    it 'Получаем номер в человеческом виде' do
      @phone.send(:_set_phone_number, '+79851488398')
      expect(@phone.get_phone_number).to eq('+79851488398')
    end
  end

  describe '._auto_detect' do
    it 'Определение международного номера' do
      @phone.send(:_auto_detect, '+79851488398')
      expect(@phone.number_plan_identifier).to eq(ID_INTERNATIONAL)
      expect(@phone.type_number).to eq(TP_ISDN)
    end
    it 'Определение местного номера' do
      @phone.send(:_auto_detect, '89851488398')
      expect(@phone.number_plan_identifier).to eq(ID_UNKNOWN)
      expect(@phone.type_number).to eq(TP_ISDN)
    end
    it 'Определение буквено-цифрового номера' do
      @phone.send(:_auto_detect, 'tele2')
      expect(@phone.number_plan_identifier).to eq(ID_ALPHANUMERIC)
      expect(@phone.type_number).to eq(TP_UNKNOWN)
    end
  end

  describe '._check_phone?' do
    it 'Правильный номер телефона' do
      @phone.send(:_set_phone_number, '+79851488398')
      expect(@phone.send(:_check_phone?)).to be_truthy
    end
    it 'Правильный номер телефона местный' do
      @phone.send(:_set_phone_number, '89851488398')
      expect(@phone.send(:_check_phone?)).to be_truthy
    end
    it 'Правильный номер текстовый' do
      @phone.send(:_set_phone_number, 'tele2', ID_ALPHANUMERIC, TP_ISDN)
      expect(@phone.send(:_check_phone?)).to be_truthy
    end
    it 'Не корректный номер телефона' do
      expect(@phone.send(:_check_phone?)).to be_falsey
    end
    it 'Правильный номер текстовый' do
      @phone.send(:_set_phone_number, 'tele2 SP', ID_ALPHANUMERIC, TP_ISDN)
      expect(@phone.send(:_check_phone?)).to be_truthy
    end
  end

  describe '._get_hex_type_and_phone' do
    it 'Получаем номер в hex' do
      @phone.send(:_set_phone_number, '+79851488398')
      expect(@phone.send(:_get_hex_type_and_phone)).to eq('919758418893F8')
    end
  end

  describe '._set_phone_number' do
    it 'Устанавливаем номер телефона и он возвращает объект' do
      phone = Phone.new
      expect(phone.send(:_set_phone_number, '+79851488399')).to be_an_instance_of(Phone)
      expect(phone.get_phone_number).to eq('+79851488399')
    end
    it 'Устанавливаем номер местный телефона и он возвращает объект' do
      phone = Phone.new
      expect(phone.send(:_set_phone_number, '79851488399', ID_UNKNOWN, TP_ISDN)).to be_an_instance_of(Phone)
      expect(phone.get_phone_number).to eq('79851488399')
    end
    it 'Устанавливаем номер местный телефона и он возвращает объект' do
      phone = Phone.new
      expect(phone.send(:_set_phone_number, 'tele2', ID_ALPHANUMERIC, TP_ISDN)).to be_an_instance_of(Phone)
      expect(phone.get_phone_number).to eq('tele2')
    end
    it 'Устанавливаем не корректный номер телефона и получаем ошибку' do
      phone = Phone.new
      expect(-> { phone.send(:_set_phone_number, 'error_', ID_UNKNOWN, TP_ISDN) }).to raise_exception ArgumentError
      expect(phone.get_phone_number).to eq('')
    end
  end

  describe '._set_hex_type_and_phone' do
    it 'Интернациональный номер' do
      phone = Phone.new
      expect(phone.send(:_set_hex_type_and_phone, '919758418893F8').get_phone_number).to eq('+79851488398')
    end
    it 'Национальный номер' do
      phone = Phone.new
      expect(phone.send(:_set_hex_type_and_phone, '819758418893F8').get_phone_number).to eq('79851488398')
    end
    it 'Ошибка' do
      phone = Phone.new
      expect(-> { phone.send(:_set_hex_type_and_phone, '91975841AF93F8') }).to raise_exception ArgumentError
    end
  end

  describe '.convert_bcd_format' do
    it 'Bcd формат нечетный номер' do
      @phone.send(:_set_phone_number, '+79851488398')
      expect(@phone.send(:_convert_to_bcd_format)).to eq('9758418893F8')
    end
    it 'BCD формат четный номер' do
      phone = Phone.new.send(:_set_phone_number, '+798514883988')
      expect(phone.send(:_convert_to_bcd_format)).to eq('975841889388')
    end
  end

  describe '._convert_to_normal_format' do
    before :each do
      @phone = Phone.new
    end
    it 'очень короткая строка' do
      expect(-> {@phone.send(:_convert_to_normal_format, 'abs')}).to raise_exception ArgumentError
    end
    it 'нормальная строка интернациональный формат' do
      expect(@phone.send(:_convert_to_normal_format, '919758418893F8').get_phone_number).to eq('+79851488398')
    end
    it 'нормальная строка местный формат' do
      expect(@phone.send(:_convert_to_normal_format, '814824272010').get_phone_number).to eq('8442720201')
    end
    it 'нормальная строка буквенно цифровой номер' do
      expect(@phone.send(:_convert_to_normal_format, 'D0D432BB2C03').get_phone_number).to eq('Tele2')
    end
    it 'нормальная строка не верный формат телефона' do
      expect(-> {@phone.send(:_convert_to_normal_format, '214824272010')} ).to raise_exception ArgumentError
    end
  end

  describe '._type_of_address_hex' do
    it 'Международный формат' do
      @phone.send(:_set_phone_number, '+79851488398')
      expect(@phone.send(:_type_of_address_hex)).to eq('91')
    end
    it 'Национальный формат' do
      @phone.send(:_set_phone_number, '851488388', ID_UNKNOWN, TP_ISDN)
      expect(@phone.send(:_type_of_address_hex)).to eq('81')
    end
  end

end