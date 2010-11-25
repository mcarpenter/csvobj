
require 'test/unit'

require 'csvobj'

class TestToCsv < Test::Unit::TestCase

  def setup
    @parser = Class.new(CSVobj)
  end

  def teardown
    @parser = nil 
  end

  def test_one_object_sans_headers
    s = "foo,bar,baz\n1,2,3\n"
    objs = @parser.parse(s)
    assert_equal(1, objs.size)
    assert_equal("1,2,3\n", objs.first.to_s)
  end

  def test_one_object_with_headers
    s = "foo,bar,baz\n1,2,3\n"
    objs = @parser.parse(s)
    assert_equal(1, objs.size)
    assert_equal(s, objs.first.to_s_with_headers)
  end

end

