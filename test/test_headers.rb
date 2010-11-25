
require 'test/unit'

require 'csvobj'

class TestHeaders < Test::Unit::TestCase

  def setup
    @parser = Class.new(CSVobj)
  end

  def teardown
    @parser = nil 
  end

  def test_simple
    s = 'foo,bar,baz'
    objs = @parser.parse(s)
    assert_equal(%w[ foo bar baz ], @parser.headers)
  end

  def test_not_mangled
    s = 'Header one,!Header two'
    objs = @parser.parse(s)
    assert_equal([ 'Header one', '!Header two' ], @parser.headers)
  end

end

