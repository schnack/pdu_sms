require_relative '../../spec/spec_helper'

describe PDUType do

  before :each  do
    @pdu_type = PDUType.encode
  end

  describe '.initialize' do
    it 'default' do
      expect(@pdu_type).to be_an_instance_of(PDUType)
    end
    it 'rp' do
      expect(PDUType.new(:encode, rp: 0, mti:00, sri:0, mms:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, rp: 1, mti:00, sri:0, mms:0)).to be_an_instance_of(PDUType)
      expect(->{ PDUType.new(:encode, rp: -1, mti:00, sri:0, mms:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, rp: 2, mti:00, sri:0, mms:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, rp: false, mti:00, sri:0, mms:0)}).to raise_exception ArgumentError
    end
    it 'udhi' do
      expect(PDUType.new(:encode, udhi: 0, mti:00, sri:0, mms:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, udhi: 1, mti:00, sri:0, mms:0)).to be_an_instance_of(PDUType)
      expect(->{ PDUType.new(:encode, udhi: -1, mti:00, sri:0, mms:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, udhi: 2, mti:00, sri:0, mms:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, udhi: false, mti:00, sri:0, mms:0)}).to raise_exception ArgumentError
    end
    it 'srr' do
      expect(PDUType.new(:encode, srr:0, vpf:00, rd:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, srr:1, vpf:00, rd:0)).to be_an_instance_of(PDUType)
      expect(->{ PDUType.new(:encode, srr:-1, vpf:00, rd:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, srr:2, vpf:00, rd:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, srr:false, vpf:00, rd:0)}).to raise_exception ArgumentError
    end
    it 'vpf' do
      expect(PDUType.new(:encode, vpf:0, srr:0, rd:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, vpf:1, srr:0, rd:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, vpf:2, srr:0, rd:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, vpf:3, srr:0, rd:0)).to be_an_instance_of(PDUType)
      expect(->{ PDUType.new(:encode, vpf:-1, srr:0, rd:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, vpf:4, srr:0, rd:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, vpf:false, srr:0, rd:0)}).to raise_exception ArgumentError
    end
    it 'rd' do
      expect(PDUType.new(:encode, rd:0, srr:0, vpf:00)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, rd:1, srr:1, vpf:00)).to be_an_instance_of(PDUType)
      expect(->{ PDUType.new(:encode, rd:-1, srr:0, vpf:00)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, rd:2, srr:0, vpf:00)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, rd:false, srr:0, vpf:00)}).to raise_exception ArgumentError
    end
    it 'mti' do
      expect(PDUType.new(:encode, mti:0, sri:0, mms:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, mti:1, srr:0, rd:0, vpf:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, mti:2)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, mti:3)).to be_an_instance_of(PDUType)
      expect(->{ PDUType.new(:encode, mti:-1)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, mti:4)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, mti:false)}).to raise_exception ArgumentError
    end
    it 'sri' do
      expect(PDUType.new(:encode, sri: 0, mti:00, mms:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, sri: 1, mti:00, mms:0)).to be_an_instance_of(PDUType)
      expect(->{ PDUType.new(:encode, sri: -1, mti:00, mms:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, sri: 2, mti:00, mms:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, sri: false, mti:00, mms:0)}).to raise_exception ArgumentError
    end
    it 'mms' do
      expect(PDUType.new(:encode, mms: 0, mti:00, sri:0)).to be_an_instance_of(PDUType)
      expect(PDUType.new(:encode, mms: 1, mti:00, sri:0)).to be_an_instance_of(PDUType)
      expect(->{ PDUType.new(:encode, mms: -1, mti:00, sri:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, mms: 2, mti:00, sri:0)}).to raise_exception ArgumentError
      expect(->{ PDUType.new(:encode, mms: false, mti:00, sri:0)}).to raise_exception ArgumentError
    end
  end

  describe '.encode' do
    it 'Создание объекта с помощью фабрики кодирования' do
      expect(PDUType.encode).to be_an_instance_of PDUType
      expect(PDUType.encode.frozen?).to be_truthy
    end
  end

  describe '.decode' do
    it 'Создание объекта с помощью фабрики декодирования' do
      expect(PDUType.decode('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')).to be_an_instance_of PDUType
      expect(PDUType.decode('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904').frozen?).to be_truthy
    end
  end

  describe '.encode_ms' do
    it 'Создаем объект кодируя для MS' do
      expect(PDUType.encode_ms).to be_an_instance_of PDUType
      expect(PDUType.encode_ms.frozen?).to be_truthy
    end
  end

  describe '.decode_ms' do
    it 'Декодирование PDU и создание объекта SC' do
      expect(PDUType.decode_ms('0001000b919721436587F9000812041F04400438043204350442002100210021')).to be_an_instance_of PDUType
      expect(PDUType.decode_ms('0001000b919721436587F9000812041F04400438043204350442002100210021').frozen?).to be_truthy
    end
    it 'Ошибка если не верный тип PDU' do
      expect(-> { PDUType.decode_ms('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')}).to raise_exception ArgumentError
    end
  end

  describe '.encode_sc' do
    it 'Создаем объект кодируя для SC' do
      expect(PDUType.encode_sc).to be_an_instance_of PDUType
      expect(PDUType.encode_sc.frozen?).to be_truthy
    end
  end

  describe '.decode_sc' do
    it 'Декодирование PDU и создание объекта SC' do
      expect(PDUType.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904')).to be_an_instance_of PDUType
      expect(PDUType.decode_sc('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904').frozen?).to be_truthy
    end
    it 'Ошибка если не правильный тип PDU' do
      expect(-> { PDUType.decode_sc('0001000b919721436587F9000812041F04400438043204350442002100210021')}).to raise_exception ArgumentError
    end
  end

  describe '.cut_off_pdu' do
    it 'Проверяем корректность выделение блока pdu_type из pdu пакета' do
      expect(PDUType.cut_off_pdu('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904', :all)).to eq(['04', '0B919701119905F80000211062320150610CC8329BFD065DDF72363904'])
      expect(PDUType.cut_off_pdu('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904', :current)).to eq('04')
      expect(PDUType.cut_off_pdu('07919761989901F0040B919701119905F80000211062320150610CC8329BFD065DDF72363904', :tail)).to eq('0B919701119905F80000211062320150610CC8329BFD065DDF72363904')
    end
  end

  describe '.reply_path?' do
    it 'check reply_path' do
      expect(PDUType.encode(rp:0).reply_path?).to be_falsey
      expect(PDUType.encode(rp:1).reply_path?).to be_truthy
    end
  end

  describe '.user_data_header_included?' do
    it 'check user_data_header_included' do
      expect(PDUType.encode(udhi:0).user_data_header_included?).to be_falsey
      expect(PDUType.encode(udhi:1).user_data_header_included?).to be_truthy
    end
  end

  describe '.status_report_request?' do
    it 'check status_report_request' do
      expect(PDUType.encode(srr:0).status_report_request?).to be_falsey
      expect(PDUType.encode(srr:1).status_report_request?).to be_truthy
    end
  end

  describe '.validity_period_format_off?' do
    it 'check validity_period_format_off' do
      expect(PDUType.encode(vpf:0).validity_period_format_off?).to be_truthy
      expect(PDUType.encode(vpf:1).validity_period_format_off?).to be_falsey
      expect(PDUType.encode(vpf:2).validity_period_format_off?).to be_falsey
      expect(PDUType.encode(vpf:3).validity_period_format_off?).to be_falsey
    end
  end

  describe '.validity_period_format_reserve?' do
    it 'check validity_period_format_reserve' do
      expect(PDUType.encode(vpf:0).validity_period_format_reserve?).to be_falsey
      expect(PDUType.encode(vpf:1).validity_period_format_reserve?).to be_truthy
      expect(PDUType.encode(vpf:2).validity_period_format_reserve?).to be_falsey
      expect(PDUType.encode(vpf:3).validity_period_format_reserve?).to be_falsey
    end
  end

  describe '.validity_period_format_relative?' do
    it 'check validity_period_format_relative' do
      expect(PDUType.encode(vpf:0).validity_period_format_relative?).to be_falsey
      expect(PDUType.encode(vpf:1).validity_period_format_relative?).to be_falsey
      expect(PDUType.encode(vpf:2).validity_period_format_relative?).to be_truthy
      expect(PDUType.encode(vpf:3).validity_period_format_relative?).to be_falsey
    end
  end

  describe '.validity_period_format_relative?' do
    it 'check validity_period_format_relative' do
      expect(PDUType.encode(vpf:0).validity_period_format_relative?).to be_falsey
      expect(PDUType.encode(vpf:1).validity_period_format_relative?).to be_falsey
      expect(PDUType.encode(vpf:2).validity_period_format_relative?).to be_truthy
      expect(PDUType.encode(vpf:3).validity_period_format_relative?).to be_falsey
    end
  end

  describe '.validity_period_format_absolute?' do
    it 'check validity_period_format_absolute' do
      expect(PDUType.encode(vpf:0).validity_period_format_absolute?).to be_falsey
      expect(PDUType.encode(vpf:1).validity_period_format_absolute?).to be_falsey
      expect(PDUType.encode(vpf:2).validity_period_format_absolute?).to be_falsey
      expect(PDUType.encode(vpf:3).validity_period_format_absolute?).to be_truthy
    end
  end

  describe '.reject_duplicates?' do
    it 'check reject_duplicates' do
      expect(PDUType.encode(rd:0).reject_duplicates?).to be_falsey
      expect(PDUType.encode(rd:1).reject_duplicates?).to be_truthy
    end
  end

  describe '.message_type_indicator_in?' do
    it 'check message_type_indicator_in' do
      expect(PDUType.encode(mti:0).message_type_indicator_in?).to be_truthy
      expect(PDUType.encode(mti:1).message_type_indicator_in?).to be_falsey
      expect(PDUType.new(:encode, mti:2).message_type_indicator_in?).to be_falsey
      expect(PDUType.new(:encode, mti:3).message_type_indicator_in?).to be_falsey
    end
  end

  describe '.message_type_indicator_out?' do
    it 'check message_type_indicator_out' do
      expect(PDUType.encode(mti:0).message_type_indicator_out?).to be_falsey
      expect(PDUType.encode(mti:1).message_type_indicator_out?).to be_truthy
      expect(PDUType.new(:encode, mti:2).message_type_indicator_out?).to be_falsey
      expect(PDUType.new(:encode, mti:3).message_type_indicator_out?).to be_falsey
    end
  end

  describe '.message_type_indicator_report?' do
    it 'check message_type_indicator_report' do
      expect(PDUType.encode(mti:0).message_type_indicator_report?).to be_falsey
      expect(PDUType.encode(mti:1).message_type_indicator_report?).to be_falsey
      expect(PDUType.new(:encode, mti:2).message_type_indicator_report?).to be_truthy
      expect(PDUType.new(:encode, mti:3).message_type_indicator_report?).to be_falsey
    end
  end

  describe '.message_type_indicator_reserve?' do
    it 'check message_type_indicator_reserve' do
      expect(PDUType.encode(mti:0).message_type_indicator_reserve?).to be_falsey
      expect(PDUType.encode(mti:1).message_type_indicator_reserve?).to be_falsey
      expect(PDUType.new(:encode, mti:2).message_type_indicator_reserve?).to be_falsey
      expect(PDUType.new(:encode, mti:3).message_type_indicator_reserve?).to be_truthy
    end
  end

  describe '.more_messages_to_send?' do
    it 'check more_messages_to_send' do
      expect(PDUType.encode(mti:0, mms:1).more_messages_to_send?).to be_truthy
      expect(PDUType.encode(mti:0, mms:0).more_messages_to_send?).to be_falsey
    end
  end

  describe '.status_report_indication?' do
    it 'check status_report_indication' do
      expect(PDUType.encode(mti:0, sri:1).status_report_indication?).to be_truthy
      expect(PDUType.encode(mti:0, sri:0).status_report_indication?).to be_falsey
    end
  end

  describe '.get_reply_path' do
    it 'get reply_path' do
      expect(@pdu_type.get_reply_path).to eq('0')
    end
  end

  describe '.user_data_header_included' do
    it 'get user_data_header_included' do
      expect(@pdu_type.get_user_data_header_included).to eq('0')
    end
  end

  describe '.get_status_report_request' do
    it 'get status_report_request' do
      expect(@pdu_type.get_status_report_request).to eq('0')
    end
  end

  describe '.get_validity_period_format' do
    it 'get validity_period_format' do
      expect(@pdu_type.get_validity_period_format).to eq('00')
    end
  end

  describe '.get_reject_duplicates' do
    it 'get reject_duplicates' do
      expect(@pdu_type.get_reject_duplicates).to eq('0')
    end
  end

  describe '.get_message_type_indicator' do
    it 'get message_type_indicator' do
      expect(@pdu_type.get_message_type_indicator).to eq('01')
    end
  end

  describe '.get_status_report_indication' do
    it 'get status_report_indication' do
      expect(PDUType.encode(mti:0, sri:1).get_status_report_indication).to eq('1')
    end
  end

  describe '.get_more_messages_to_send' do
    it 'get more_messages_to_send' do
      expect(PDUType.encode(mti:0, mms:1).get_more_messages_to_send).to eq('1')
    end
  end

  describe '.get_hex' do
    it 'Получаем PDU кодированную строку' do
      expect(@pdu_type.get_hex).to eq('01')
    end
    it 'Получаем PDU кодированную строку' do
      expect(PDUType.encode(mti:0).get_hex).to eq('00')
    end
  end

end