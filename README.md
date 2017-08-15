# PduSms

## Description

## Installation

Add this line to your application's Gemfile:

    ruby gem 'pdu_sms'


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdu_sms

## Usage
    
    require 'pdu_sms'
    
    include PduSms
    
    # MS(Mobile Station) => SC(SMS Center)
    encode_pdu_ms = PacketDataUnit.encode_ms('+71234567890', 'Hello!!!')
    encode_pdu_ms[0].get_hex            #=> "0001000B911732547698F0000008C8329BFD0E8542"
    encode_pdu_ms[0].get_message        #=> "Hello!!!"
    encode_pdu_ms[0].get_phone_number   #=> "+71234567890"
    encode_pdu_ms[0].length             #=> 20
    encode_pdu_ms[0].id_message         #=> nil
    encode_pdu_ms[0].all_parts          #=> 0
    encode_pdu_ms[0].part_number        #=> 0
    
    decode_pdu_ms = PacketDataUnit.decode('0001000B911732547698F0000008C8329BFD0E8542')
    decode_pdu_ms.get_hex               #=> "0001000B911732547698F0000008C8329BFD0E8542"
    decode_pdu_ms.get_message           #=> "Hello!!!"
    decode_pdu_ms.get_phone_number      #=> "+71234567890"
    
    # SC => MS
    encode_pdu_sc = PacketDataUnit.encode_sc('+71234567890', 'Tele2', 'hello!!!')
    encode_pdu_sc[0].get_hex            #=> "07911732547698F00009D0D432BB2C0300005111713115142108E8329BFD0E8542"
    encode_pdu_sc[0].get_message        #=> "hello!!!"
    encode_pdu_sc[0].get_phone_number   #=> "Tele2"
    
    decode_pdu_sc = PacketDataUnit.decode('07911732547698F00009D0D432BB2C0300005111713115142108E8329BFD0E8542')
    decode_pdu_sc.get_hex               #=> "07911732547698F00009D0D432BB2C0300005111713115142108E8329BFD0E8542"
    decode_pdu_sc.get_message           #=> "hello!!!"
    decode_pdu_sc.get_phone_number      #=> "Tele2"
    
    
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/schnack/pdu_sms.

## License

MTI

## Authors

* Mikhail Stolyarov <schnack.desu@gmail.com>
