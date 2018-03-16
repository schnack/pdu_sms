module PduSms

  module Helpers

    def self.encode_bcd(str)
      if String == str.class and str.length % 2 == 0
        str.split('').enum_for(:each_slice, 2).to_a.collect{|array| array[0], array[1] = array[1], array[0]}.join
      else
        raise ArgumentError, 'The number of characters must be even'
      end
    end

    def self.decode_bcd(str)
      encode_bcd(str)
    end

    def self.decode_ucs2(message)
      message.split('').enum_for(:each_slice,4).to_a.collect(&:join).collect {|o| o.to_i(16).chr(Encoding::UTF_8)}.join
    end

    def self.encode_ucs2(message)
      message.chars.to_a.collect {|char| '%04X' % char.ord}.join
    end

    def self.is_7bit?(message)
      result = true
      message.split('').each do |sym|
        result = false unless sym.ord >= 0 and sym.ord <= 127
      end
      result
    end

    def self.encode_7bit(string)
      string_encode = []
      string.chars.each_slice(8).each do |chars|
        chars.each_with_index do |char, i|
          bit_char = '%07b' % char.ord
          if i == 0
            string_encode << bit_char
          else
            string_encode[-1] = '%s%s' % [bit_char[-i..-1], string_encode[-1]]
            string_encode << bit_char[0..(-1-i)] if bit_char[0..(-1-i)] != ''
          end
        end
      end
      string_encode.collect {|x| '%02X' % x.to_i(2)}.join.upcase
    end

    def self.decode_7bit(string)
      text = ''
      string.split('').each_slice(2).collect {|s| '%08b' % s.join.to_i(16)}.each_slice(7) do |bytes|
        ending = ''
        bytes.each_with_index do |byte, i|
          text << ('0%s%s' % [byte[i+1..-1], ending]).to_i(2).chr
          ending = byte[0..i]
          text << ('0%s' % ending).to_i(2).chr if i == 6 and ending.to_i(2) != 0
        end
      end
      text
    end

    def self.decode_7bit_fill_bits(string, udhl)
      message = ''
      if udhl.to_i(16) == UDHL_SIZE_5
        message << ("0%08b" % string[0..1].to_i(16))[0..-2].to_i(2).chr
        message << self.decode_7bit(string[2..-1])
      else
        message << self.decode_7bit(string)
      end
      message
    end

    def self.encode_7bit_fill_bits(string, udhl)
      message = ''
      if udhl.to_i(16) == UDHL_SIZE_5
        message << '%02X' % ('%07b0' % string[0].ord).to_i(2)
        message << self.encode_7bit(string[1..-1])
      else
        message << self.encode_7bit(string)
      end
      message
    end

    def self.encode_8bit(string)
      string.chars.to_a.collect {|char| '%02X' % char.ord }.join
    end

    def self.decode_8bit(string)
      string.split('').enum_for(:each_slice, 2).to_a.collect(&:join).collect {|char| char.to_i(16).chr}.join
    end

  end
end


