require 'date'

module PduSms

  class ServiceCenterTimeStamp

    def initialize(type, data)
      if type == :encode_sc
        @scts = _absolute_timestamp data
      elsif type == :decode_sc
        @scts = data
      else
        raise ArgumentError, 'The "type" is incorrect'
      end
    end

    def ServiceCenterTimeStamp.encode_sc(times)
      new(:encode_sc, times).freeze
    end

    def ServiceCenterTimeStamp.decode_sc(pdu_str)
      scts = ServiceCenterTimeStamp.cut_off_pdu(pdu_str, part=:current, :sс)
      new(:decode_sc, scts).freeze
    end

    def ServiceCenterTimeStamp.cut_off_pdu(pdu, part=:all, type=:sс) # tail current
      part_pdu = DataCodingScheme.cut_off_pdu(pdu, :tail, :sc)
      raise ArgumentError, 'The "pdu" is incorrect' if part_pdu.length < 14
      current = part_pdu[0..13]
      tail = part_pdu[14..-1]
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def get_hex
      @scts
    end

    def get_time
      _absolute_pdu @scts
    end

    private

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
      @scts = Helpers.encode_bcd(date_time)
    end

    def _absolute_pdu(vp)
      ss = Helpers.decode_bcd(vp)
      year, month, day, hours, minutes, seconds, zone_quarter = Time.now.year.to_s[0..1] + ss[0..1], ss[2..3], ss[4..5], ss[6..7], ss[8..9], ss[10..11], ss[12..13]
      tz = '%08b' % zone_quarter.to_i()
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
