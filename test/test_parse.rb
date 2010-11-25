
require 'test/unit'
require 'stringio'

require 'csvobj'

class TestParse < Test::Unit::TestCase

  def setup
    @parser = Class.new(CSVobj)
  end

  def teardown
    @parser = nil
  end

  def test_duplicate_header
    s = "foo,bar,bar,baz\n1,2,3,4\n"
    assert_raise CSVobjDuplicateHeader do
      @parser.parse(s)
    end
  end

  def test_one_obj_from_string
    s = "foo,bar,baz\n1,2,3\n"
    objs = @parser.parse(s)
    assert_equal(1, objs.size)
    assert_equal('1', objs[0].foo)
    assert_equal('2', objs[0].bar)
    assert_equal('3', objs[0].baz)
  end

  def test_two_objs_from_string
    s = "foo,bar,baz\n1,2,3\n4,5,6\n"
    objs = @parser.parse(s)
    assert_equal(2, objs.size)
    assert_equal('1', objs[0].foo)
    assert_equal('2', objs[0].bar)
    assert_equal('3', objs[0].baz)
    assert_equal('4', objs[1].foo)
    assert_equal('5', objs[1].bar)
    assert_equal('6', objs[1].baz)
  end

  def test_two_objs_from_file
    s = "foo,bar,baz\n1,2,3\n4,5,6\n"
    fileish = StringIO.new(s)
    objs = @parser.parse(fileish)
    assert_equal(2, objs.size)
    assert_equal('1', objs[0].foo)
    assert_equal('2', objs[0].bar)
    assert_equal('3', objs[0].baz)
    assert_equal('4', objs[1].foo)
    assert_equal('5', objs[1].bar)
    assert_equal('6', objs[1].baz)
  end

  def test_no_trailing_newline
    s = "foo,bar,baz\n1,2,3"
    objs = @parser.parse(s)
    assert_equal(1, objs.size)
    assert_equal('1', objs[0].foo)
    assert_equal('2', objs[0].bar)
    assert_equal('3', objs[0].baz)
  end

  def test_missing_data_cell
    s = "foo,bar,baz\n1,2\n4,5,6\n"
    objs = @parser.parse(s)
    assert_equal(2, objs.size)
    assert_equal('1', objs[0].foo)
    assert_equal('2', objs[0].bar)
    assert_equal(nil, objs[0].baz)
    assert_equal('4', objs[1].foo)
    assert_equal('5', objs[1].bar)
    assert_equal('6', objs[1].baz)
  end

  def test_missing_header_cell
    s = "foo,bar\n1,2,3\n"
    objs = @parser.parse(s)
    assert_equal(1, objs.size)
    assert_equal('1', objs[0].foo)
    assert_equal('2', objs[0].bar)
    assert_raise NoMethodError do
      objs[0].baz
    end
  end

  def test_missing_data
    s = "foo,bar,baz\n"
    objs = @parser.parse(s)
    assert_equal([], objs)
  end

  def test_empty
    objs = @parser.parse('')
    assert_equal([], objs)
  end

  def test_array
    a = [
      [ 'foo', 'bar', 'baz' ],
      [ '1', '2', '3' ],
      [ '4', '5', '6' ]
    ]
    objs = @parser.parse(a)
    assert_equal(2, objs.size)
    assert_equal('1', objs[0].foo)
    assert_equal('2', objs[0].bar)
    assert_equal('3', objs[0].baz)
    assert_equal('4', objs[1].foo)
    assert_equal('5', objs[1].bar)
    assert_equal('6', objs[1].baz)
  end

end

