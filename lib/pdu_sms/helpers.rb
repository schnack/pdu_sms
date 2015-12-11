module PduSms
  module Helpers

    def encode_bcd(str)
      if String == str.class and str.length % 2 == 0
        str.split('').enum_for(:each_slice, 2).to_a.collect{|array| array[0], array[1] = array[1], array[0]}.join
      else
        raise ArgumentError, 'The number of characters must be even'
      end
    end

    def decode_bcd(str)
      encode_bcd(str)
    end

    def decode_ucs2(message)
      message.split('').enum_for(:each_slice,4).to_a.collect(&:join).collect {|o| o.to_i(16).chr(Encoding::UTF_8)}.join
    end

    def encode_ucs2(message)
      message.chars.to_a.collect {|char| '%04X' % char.ord}.join
    end

    def is_7bit?(message)
      /^[A-Za-z0-9\@£\$¥èéùìòÇØøÅåΔ_ΦΓΛΩΠΨΣΘΞÆæßÉ\!\"#¤\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?¡¿ÄÖÑÜ§äöñüà\^\{\}\\\[~\]\|€]*$/ === message
    end

    def encode_7bit(string)
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

    def decode_7bit(string)
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

    def encode_8bit(string)
      string.chars.to_a.collect {|char| '%02X' % char.ord }.join
    end

    def decode_8bit(string)
      string.split('').enum_for(:each_slice, 2).to_a.collect(&:join).collect {|char| char.to_i(16).chr}.join
    end

  end
end

