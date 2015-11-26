module PduSms

  class DataCodingScheme

    def initialize(type, compressed: UNCOMPRESSED, message_class: false, alphabet: ALPHABET_16BIT)
      raise ArgumentError, 'The "compresses" is incorrect' unless compressed and (UNCOMPRESSED..COMPRESSED).include?(compressed)
      raise ArgumentError, 'The "alphabet" is incorrect' unless alphabet and (ALPHABET_7BIT..RESERVED).include?(alphabet)
      @compressed = compressed
      @alphabet = alphabet
      if message_class
        if (CLASS_0_IMMEDIATE_DISPLAY..CLASS_3_TE_SPECIFIC).include?(message_class)
          @message_class_trigger = MESSAGE_CLASS_ON
          @message_class = message_class
        else
          raise ArgumentError, 'The "message_class" is incorrect'
        end
      else
        @message_class_trigger = MESSAGE_CLASS_OFF
        @message_class = 0b00
      end
    end

    def DataCodingScheme.encode_ms(compressed: UNCOMPRESSED, message_class: false, alphabet: ALPHABET_16BIT)
      new(:encode_ms, compressed:compressed, message_class:message_class, alphabet:alphabet).freeze
    end

    def DataCodingScheme.decode_ms(pdu_str)
      pdu = '%08b' % DataCodingScheme.cut_off_pdu(pdu_str, :current, :ms).to_i(16)
      message_class = (pdu[1].to_i == MESSAGE_CLASS_ON) ? pdu[6..7].to_i(2) : false
      new(:decode_ms, compressed:pdu[2].to_i(2), message_class:message_class, alphabet:pdu[4..5].to_i(2)).freeze
    end

    def DataCodingScheme.encode_sc(compressed: UNCOMPRESSED, message_class: false, alphabet: ALPHABET_16BIT)
      new(:encode_sc, compressed:compressed, message_class:message_class, alphabet:alphabet).freeze
    end

    def DataCodingScheme.decode_sc(pdu_str)
      pdu = '%08b' % DataCodingScheme.cut_off_pdu(pdu_str, :current, :sc).to_i(16)
      message_class = (pdu[1].to_i == MESSAGE_CLASS_ON) ? pdu[6..7].to_i(2) : false
      new(:decode_sc, compressed:pdu[2].to_i(2), message_class:message_class, alphabet:pdu[4..5].to_i(2)).freeze
    end

    def DataCodingScheme.cut_off_pdu(pdu, part=:all, type=:ms) # tail current
      part_pdu = ProtocolIdentifier.cut_off_pdu(pdu, :tail, type)
      raise ArgumentError, 'The "pdu" is incorrect' if part_pdu.length < 2
      current = part_pdu[0..1]
      tail = part_pdu[2..-1]
      case part
        when :current then current
        when :tail then tail
        else [current,tail]
      end
    end

    def compressed?
      @compressed == COMPRESSED
    end

    def alphabet_7bit?
      @alphabet == ALPHABET_7BIT
    end

    def alphabet_8bit?
      @alphabet == ALPHABET_8BIT
    end

    def alphabet_16bit?
      @alphabet == ALPHABET_16BIT
    end

    def alphabet_reserved?
      @alphabet == RESERVED
    end

    def message_class?
      @message_class_trigger == MESSAGE_CLASS_ON
    end

    def message_class_immediate_display?
      @message_class == CLASS_0_IMMEDIATE_DISPLAY
    end

    def message_class_me?
      @message_class == CLASS_1_ME_SPECIFIC
    end

    def message_class_sim?
      @message_class == CLASS_2_SIM_SPECIFIC
    end

    def message_class_te?
      @message_class == CLASS_3_TE_SPECIFIC
    end

    def get_compressed
      '%b' % @compressed
    end

    def get_alphabet
      '%02b' % @alphabet
    end

    def get_message_class_trigger
      '%b' % @message_class_trigger
    end

    def get_message_class
      '%02b' % @message_class
    end

    def get_bit0
      '%02b' % BIT0
    end

    def get_hex
      '%02x' % (get_bit0 << get_compressed << get_message_class_trigger << get_alphabet << get_message_class).to_i(2)
    end

  end
end
