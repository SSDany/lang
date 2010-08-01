module Lang #:nodoc:
  module Tag

    module PATTERN

      #--
      # RFC 5646, sec. 2.2.2:
      # Although the ABNF production 'extlang' permits up to three
      # extended language tags in the language tag, extended language
      # subtags MUST NOT include another extended language subtag in
      # their 'Prefix'. That is, the second and third extended language
      # subtag positions in a language tag are permanently reserved and
      # tags that include those subtags in that position are, and will
      # always remain, invalid.
      #++

      LANGUAGE            = "[a-z]{2,3}(?:-[a-z]{3})?|[a-z]{4,8}"
      LOOSE_LANGUAGE      = "[a-z]{2,3}(?:-[a-z]{3}){0,3}|[a-z]{4,8}"
      SCRIPT              = "[a-z]{4}"
      REGION              = "[a-z]{2}|\\d{3}"
      VARIANT             = "[a-z\\d]{5,8}|\\d[a-z\\d]{3}"
      VARIANT_SEQUENCE    = "(?:-[a-z\\d]{5,8}|-\\d[a-z\\d]{3})"
      SINGLETON           = "[a-wy-z\\d]"
      EXTENSION_SEQUENCE  = "(?:-#{SINGLETON}(?:-[a-z\\d]{2,8})+)"
      PRIVATEUSE          = "x(?:-[a-z\\d]{1,8})+"

    end
  end
end

# EOF