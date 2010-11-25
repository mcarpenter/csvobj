
require 'test/unit'

require 'csvobj'

class TestToA < Test::Unit::TestCase

  def setup
    @parser = Class.new(CSVobj)
  end

  def teardown
    @parser = nil 
  end

  def test_one_complete_object
    s = "foo,bar,baz\n1,2,3\n"
    objs = @parser.parse(s)
    assert_equal(1, objs.size)
    assert_equal(%w[ 1 2 3 ], objs[0].to_a)
  end

  def test_one_object_missing_data_cell
    s = "foo,bar,baz\n1,2\n"
    objs = @parser.parse(s)
    assert_equal(1, objs.size)
    assert_equal([ '1', '2', nil ], objs[0].to_a)
  end

  def test_one_object_missing_header
    s = "foo,bar\n1,2,3\n"
    objs = @parser.parse(s)
    assert_equal(1, objs.size)
    assert_equal(%w[ 1 2 ], objs[0].to_a)
  end

end

