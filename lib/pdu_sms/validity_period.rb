require 'date'

module PduSms
  class ValidityPeriod


    def initialize(type, times, type_time=false)
      @type_time = type_time
      return @vp = '' unless times
      if type == :encode_ms
        @type_time = (0..635040).include?(times) ? VALIDITY_PERIOD_FORMAT_10 : VALIDITY_PERIOD_FORMAT_11 unless @type_time
        if @type_time == VALIDITY_PERIOD_FORMAT_10
          @vp = _relative_seconds times
        elsif @type_time == VALIDITY_PERIOD_FORMAT_11
          @vp = _absolute_timestamp times
        else
          raise ArgumentError, 'The "type_time" is incorrect'
        end
      elsif type == :decode_ms
        if times.length == 2
          @type_time = VALIDITY_PERIOD_FORMAT_10
          @vp = times
        elsif times.length == 14
          @type_time = VALIDITY_PERIOD_FORMAT_11
          @vp = times
        else
          raise ArgumentError, 'The "times" is incorrect'
        end
      else
        raise ArgumentError, 'The "type" is incorrect'
      end
    end

    def ValidityPeriod.encode_ms(times, type_time=false)
      new(:encode_ms, times, type_time).freeze
    end

    def ValidityPeriod.decode_ms(pdu_str)
      vp = ValidityPeriod.cut_off_pdu(pdu_str, part=:current, :ms)
      new(:decode_ms, vp).freeze
    end

    def ValidityPeriod.cut_off_pdu(pdu, part=:all, type=:ms)
      part_pdu = DataCodingScheme.cut_off_pdu(pdu, :tail, :ms)
      pdu_type = PDUType.decode_ms(pdu)
      if pdu_type.validity_period_format_relative?
        raise ArgumentError, 'The "pdu" is incorrect' if part_pdu.length < 2
        current = part_pdu[0..1]
        tail = part_pdu[2..-1]
      elsif pdu_type.validity_period_format_absolute?
        raise ArgumentError, 'The "pdu" is incorrect' if part_pdu.length < 14
        current = part_pdu[0..13]
        tail = part_pdu[14..-1]
      else
        current = false
        tail = part_pdu
      end
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def get_type_time
      @type_time
    end

    def get_time
      if @type_time == VALIDITY_PERIOD_FORMAT_10
        _relative_pdu @vp
      elsif @type_time == VALIDITY_PERIOD_FORMAT_11
        _absolute_pdu @vp
      else
        ''
      end
    end

    def get_hex
      @vp
    end

    def is_setup
      if @vp.empty?
        VALIDITY_PERIOD_FORMAT_00
      elsif @vp.length == 2
        VALIDITY_PERIOD_FORMAT_10
      else
        VALIDITY_PERIOD_FORMAT_11
      end
    end

    private

    def _relative_seconds(seseconds)
     minutes = (seseconds.abs / 60).floor
      case minutes
        when 0..4
          @vp = 0x0
        when 5..720
          @vp = minutes / 5 - 1
        when 721..749
          @vp = 0x8f
        when 750..1440
          @vp = (minutes - 720) / 30 + 143
        when 1441..2879
          @vp = 0xa7
        when 2880..43200
          @vp = minutes / 1440 + 166
        when 43201..50399
          @vp = 0xc4
        when 50400..635040
          @vp = minutes / 10080 + 192
        else
          @vp = 0xff
      end
      @vp = '%02x' % @vp
    end

    def _relative_pdu(vp)
      vp_integer_16 = vp.to_i(16)
      case vp_integer_16
        when 0..143
          minutes = (vp_integer_16 + 1) * 5
        when 144..167
          minutes = 720 + (vp_integer_16 - 143) * 30
        when 168..196
          minutes = (vp_integer_16 - 166) * 1440
        when 197..255
          minutes = (vp_integer_16 - 192) * 10080
        else
          raise ArgumentError, 'The "vp" is incorrect'
      end
      minutes * 60
    end

    def _absolute_timestamp(timestamp)
      time = Time.at(timestamp).to_datetime
      date_time = time.strftime('%y%m%d%H%M%S')
      if time.strftime('%z').to_i >= 0
        date_time += ('%02X' % (4 * time.strftime('%z')[0..2].to_i + time.strftime('%z')[3..4].to_i / 15).to_s.to_i(16))
      else
        tz = '%08b' % ((4 * time.strftime('%z')[0..2].to_i.abs + time.strftime('%z')[3..4].to_i / 15).to_s.to_i(16))
        tz[0] = ?1
        date_time += '%02X' % tz.to_i(2)
      end
      @vp = Helpers.encode_bcd(date_time)
    end

    def _absolute_pdu(vp)
      ss = Helpers.decode_bcd(vp)
      year, month, day, hours, minutes, seconds, zone_quarter = Time.now.year.to_s[0..1] + ss[0..1], ss[2..3], ss[4..5], ss[6..7], ss[8..9], ss[10..11], ss[12..13]
      tz = '%08b' % zone_quarter
      if tz[0] == '1'
        tz[0] = ?0
        zone = '-'
      else
        zone = '+'
      end
      zone += '%02i:%02i' % [(tz.to_i(2) / 4), ((tz.to_i(2) % 4) * 15)]
      Time.new(year, month, day, hours, minutes, seconds, zone).to_i
    end

  end
end
