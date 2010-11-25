
require 'test/unit'

require 'csvobj'

class TestHeaderToAttr < Test::Unit::TestCase

  def test_lowercase
    assert_equal(:header, CSVobj.header_to_attr('HEADER'))
  end

  def test_remove_leading_whitespace
    assert_equal(:header, CSVobj.header_to_attr(' header'))
  end

  def test_remove_trailing_whitespace
    assert_equal(:header, CSVobj.header_to_attr('header '))
  end

  def test_substitute_underscore_for_non_word_char
    assert_equal(:_hea_der_, CSVobj.header_to_attr('^hea&der('))
  end

  def test_no_repeated_adjacent_underscores
    assert_equal(:hea_der, CSVobj.header_to_attr('hea^&*der'))
  end

  def test_leading_digit
    assert_equal(:_9header, CSVobj.header_to_attr('9header'))
  end

end

