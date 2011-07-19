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

end