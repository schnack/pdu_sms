require 'pdu_sms/helpers'
require 'pdu_sms/phone'
require 'pdu_sms/data_coding_scheme'
require 'pdu_sms/destination_address'
require 'pdu_sms/message_reference'
require 'pdu_sms/packet_data_unit'
require 'pdu_sms/pdu_type'
require 'pdu_sms/protocol_identifier'
require 'pdu_sms/service_center_address'
require 'pdu_sms/user_data'
require 'pdu_sms/user_data_length'
require 'pdu_sms/validity_period'
require 'pdu_sms/originating_address'
require 'pdu_sms/service_center_time_stamp'
require 'pdu_sms/packet_data_unit_error'
require 'pdu_sms/version'

module PduSms

  include Helpers
  ##
  # Type of number (TON):
  ID_UNKNOWN = 0b000                    # Unknown
  ID_INTERNATIONAL = 0b001              # International number
  ID_NATIONAL = 0b010                   # National number
  ID_NETWORK = 0b011                    # Network specific number
  ID_SUBSCRIBER = 0b100                 # Subscriber number
  ID_ALPHANUMERIC = 0b101               # Alphanumeric, (coded according to 3GPP TS 23.038 [9] GSM 7 bit default alphabet)
  ID_ABBREVIATED = 0b110                # Abbreviated number
  ID_RESERVED = 0b111                   # Reserved for extension

  ##
  # Numbering plan identification (NPI):
  TP_UNKNOWN = 0b0000                   # Unknown
  TP_ISDN = 0b0001                      # ISDN/telephone numbering plan (E.164/E.163)
  TP_DATA = 0b0011                      # Data numbering plan (X.121)
  TP_TELEX = 0b100                      # Telex numbering plan
  TP_SERVICE_CENTER_SPECIFIC1 = 0b0101  # Service Centre Specific plan 1)
  TP_SERVICE_CENTER_SPECIFIC2 = 0b0110  # Service Centre Specific plan 1)
  TP_NATIONAL = 0b1000                  # National numbering plan
  TP_PRIVATE = 0b1001                   # Private numbering plan
  TP_ERMES = 0b1010                     # ERMES numbering plan (ETSI DE/PS 3 01 3)
  TP_RESERVED = 0b1111                  # Reserved for extension

  ##
  # Protocol Identifier
  PROTOCOL_IDENTIFIER = 0x00            # Default store and forward short message

  ##
  # Data Coding Scheme
  #6,7 bit
  BIT0 = 0b00                           # Default
  COMPRESSED = 0b1                      # Indicates the text is compressed using the GSM standard compression algorithm
  UNCOMPRESSED = 0b0                    # Indicates the text is uncompressed
  MESSAGE_CLASS_OFF = 0b0               #
  MESSAGE_CLASS_ON= 0b1                 #
  ALPHABET_7BIT = 0b00                  # GSM 7 bit
  ALPHABET_8BIT = 0b01                  # 8 bit data
  ALPHABET_16BIT = 0b10                 # UCS2(16bit)
  RESERVED = 0b11                       # Reserved
  CLASS_0_IMMEDIATE_DISPLAY = 0b00      # Flash messages are received by a mobile phone even though it has full memory. They are not stored in the phone, they just displayed on the phone display.
  CLASS_1_ME_SPECIFIC = 0b01            # ME-specific
  CLASS_2_SIM_SPECIFIC = 0b10           # SIM / USIM specific
  CLASS_3_TE_SPECIFIC = 0b11            # TE-specific

  ##
  # PDU TYPE
  # @rp
  REPLY_PATH_0 = 0b0                    # Reply Path parameter is not set in this SMS-SUBMIT
  REPLY_PATH_1 = 0b1                    # Reply Path parameter is set in this SMS-SUBMIT
  # @udhi
  USER_DATA_HEADER_INCLUDED_0 = 0b0     # User Data field contains only the short message
  USER_DATA_HEADER_INCLUDED_1 = 0b1     # The beginning of the UD field contains a Header in addition to the short message
  # @srr
  STATUS_REPORT_REQUEST_0 = 0b0         # A status report is not requested
  STATUS_REPORT_REQUEST_1 = 0b1         # A status report is requested
  # @vpf
  VALIDITY_PERIOD_FORMAT_00 = 0b00      # Validity Period not present
  VALIDITY_PERIOD_FORMAT_01 = 0b01      # Validity Period present- relative format
  VALIDITY_PERIOD_FORMAT_10 = 0b10      # Validity Period present - enhanced format (reserved)
  VALIDITY_PERIOD_FORMAT_11 = 0b11      # Validity Period present - absolute format
  # @rd
  REJECT_DUPLICATES_0 = 0b0             # Instruct the SC to accept SMS-SUBMIT for a SM still held in the SC which has the same MR and the same DA as a previously submitted SM from the same OA
  REJECT_DUPLICATES_1 = 0b1             # Instruct the SC to reject an SMS-SUBMIT for an SM still held in the SC which has the same MR and the same DA as the previously submitted SM from the same OA. In this case an appropriate FCS value will be returned in the SMS-SUBMIT-REPORT
  # @mti
  MESSAGE_TYPE_INDICATOR_00 = 0b00      # SMS-DELIVER (in the direction SC to MS) SMS-DELIVER REPORT (in the direction MS to SC)
  MESSAGE_TYPE_INDICATOR_01 = 0b01      # SMS-STATUS-REPORT (in the direction SC to MS) SMS-COMMAND (in the direction MS to SC)
  MESSAGE_TYPE_INDICATOR_10 = 0b10      # SMS-SUBMIT (in the direction MS to SC) SMS-SUBMIT-REPORT (in the direction SC to MS)
  MESSAGE_TYPE_INDICATOR_11 = 0b11      # Reserved

  MORE_MESSAGES_TO_SEND_0 = 0b0         # More Message are waiting for the MS in the SMSC
  MORE_MESSAGES_TO_SEND_1 = 0b1         # No more Message are waiting for the MS in the SMSC

  STATUS_REPORT_INDICATION_0 = 0b0      # A status report will not be returned to the SME
  STATUS_REPORT_INDICATION_1 = 0b1      # A status report will be returned to the SME

end


