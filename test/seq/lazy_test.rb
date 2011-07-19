$: << File.dirname(__FILE__) + '/..'
require 'helper'

class LazySeqTest < MiniTest::Unit::TestCase

  def setup
    @seq = Seq::Lazy.new([1, 1]) {|l| l[-1] + l[-2] }
  end
  
  def test_defines_next
    assert_equal 1, @seq.next
    assert_equal 1, @seq.next
    assert_equal 2, @seq.next
    assert_equal 3, @seq.next
    assert_equal 5, @seq.next
    assert_equal 8, @seq.next
    assert_equal 13, @seq.next
  end
  
  def test_offset_works
    s = Seq::Lazy.new([1], 1.0/0, 5) {|l| l.last + 1 }
    assert_equal 6, s.next
  end

end