# encoding: utf-8
require 'minitest/autorun'
require_relative '../lib/regexp_m17n'

class RegexpTest < MiniTest::Unit::TestCase
  def test_non_empty_string
    Encoding.list.each do |enc|
      next if enc.dummy?
      assert(RegexpM17N.non_empty?('.'.encode(enc)))
      assert(RegexpM17N.non_empty?("\n.\n".encode(enc)))
    end
  end

  def test_empty_string
    Encoding.list.each do |enc|
      next if enc.dummy?
      assert(!RegexpM17N.non_empty?(''.encode(enc)))
      assert(!RegexpM17N.non_empty?("\n\n".encode(enc)))
    end
  end

  def test_non_empty_string_dummy_encoding
    # ISO-2022-JP-2: http://www.faqs.org/rfcs/rfc1554.html
    # ASCII is a subset of ISO-2022-JP-2.
    assert(RegexpM17N.non_empty?('.'.force_encoding(Encoding::ISO_2022_JP_2)))

    # dot as encoded byte
    # Ref http://www.fileformat.info/info/charset/UTF-16/list.htm
    assert(RegexpM17N.non_empty?("\xfe\xff\x00\x2e".force_encoding(Encoding::UTF_16)))
  end

  def test_empty_string_dummy_encoding
    # ISO-2022-JP-2: http://www.faqs.org/rfcs/rfc1554.html
    # ASCII is a subset of ISO-2022-JP-2.
    assert(!RegexpM17N.non_empty?(''.force_encoding(Encoding::ISO_2022_JP_2)))
    assert(!RegexpM17N.non_empty?("\n\n".force_encoding(Encoding::ISO_2022_JP_2)))

    # Ref http://www.fileformat.info/info/charset/UTF-16/list.htm
    assert(!RegexpM17N.non_empty?(''.force_encoding(Encoding::UTF_16)))
    # two LF
    assert(!RegexpM17N.non_empty?(("\xfe\xff\x00\x0a" * 2).force_encoding('UTF-16').force_encoding(Encoding::UTF_16)))
  end
end
