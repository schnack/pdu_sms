require_relative '../../spec/spec_helper'

describe ServiceCenterAddress do

  describe '.initialize' do
    it 'Создание объекта по умолчанию' do
      expect(ServiceCenterAddress.new(:encode)).to be_an_instance_of ServiceCenterAddress
    end
  end

  describe '.encode_ms' do
    it 'Создаем объект с помощью фабрики кодирования (MS)' do
      expect(ServiceCenterAddress.encode_ms('+79851488398')).to be_an_instance_of ServiceCenterAddress
      expect(ServiceCenterAddress.encode_ms('+79851488398').frozen?).to be_truthy
    end
  end

  describe '.decode_ms' do
    it 'Создаем объект с помощью фабрики декодирования (MS)' do
      expect(ServiceCenterAddress.decode_ms('07919758418893F801020312301230213012031203120301230120301230120')).to be_an_instance_of ServiceCenterAddress
      expect(ServiceCenterAddress.decode_ms('07919758418893F801020312301230213012031203120301230120301230120').frozen?).to be_truthy
    end
  end

  describe '.decode_sc' do
    it 'Создаем объект с помощью фабрики декодирования (SС)' do
      expect(ServiceCenterAddress.decode_sc('07919758418893F801020312301230213012031203120301230120301230120')).to be_an_instance_of ServiceCenterAddress
      expect(ServiceCenterAddress.decode_sc('07919758418893F801020312301230213012031203120301230120301230120').frozen?).to be_truthy
    end
  end

  describe '.encode_sc' do
    it 'Создаем объект с помощью фабрики кодирования (SС)' do
      expect(ServiceCenterAddress.encode_sc('+79851488398')).to be_an_instance_of ServiceCenterAddress
      expect(ServiceCenterAddress.encode_sc('+79851488398').frozen?).to be_truthy
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверяем корректность выделение блока sca из pdu пакета' do
      expect(ServiceCenterAddress.cut_off_pdu('07919758418893F801020312301230213012031203120301230120301230120', :all)).to eq(['07919758418893F8', '01020312301230213012031203120301230120301230120'])
    end
    it 'Ошибка в PDU пакете' do
      expect(-> { ServiceCenterAddress.cut_off_pdu('00')} ).to raise_exception ArgumentError
    end
  end

  describe '.get_hex' do
    it 'Получаем PDU строку' do
      expect(ServiceCenterAddress.encode_ms('+79851488398').get_hex).to eq('07919758418893F8')
    end
    it 'Если номер SMS центра не задан' do
      expect(ServiceCenterAddress.new(:encode).get_hex).to eq('00')
    end
  end

  describe '.set_pdu_hex' do
    it 'Проверяем международный тип номера телефона' do
      expect(ServiceCenterAddress.new(:encode).send(:_set_pdu_hex, '07919758418893F8').get_phone_number).to eq('+79851488398')
    end
    it 'Проверяем местный тип номера' do
      expect(ServiceCenterAddress.new(:encode).send(:_set_pdu_hex, '07819758418893F8').get_phone_number).to eq('79851488398')
    end
    it 'Если номер СМС центра не указан' do
      expect(ServiceCenterAddress.new(:encode).send(:_set_pdu_hex, '00').get_phone_number).to eq('')
    end
  end

  describe '._address_length_hex' do
    it 'Определяем длину номера' do
      expect(ServiceCenterAddress.encode_ms('+79851488398').send(:_address_length_hex)).to eq('07')
    end
  end

end