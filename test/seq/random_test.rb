$: << File.dirname(__FILE__) + '/..'
require 'helper'

class RandomSeqTest < MiniTest::Test

  def setup
    @seq = Seq::Random.new([1, 2, 3], 6)
  end

  def test_defines_next
    assert_includes [1,2,3], @seq.next
    assert_includes [1,2,3], @seq.next
    assert_includes [1,2,3], @seq.next
    assert_includes [1,2,3], @seq.next
    assert_includes [1,2,3], @seq.next
    assert_includes [1,2,3], @seq.next
    assert_equal nil, @seq.next
  end

  def test_cycles_correct_times
    assert_equal 6, @seq.entries.size
  end

end
