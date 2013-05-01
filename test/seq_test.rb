$: << File.dirname(__FILE__)
require 'helper'

class SeqTest < MiniTest::Unit::TestCase

  def setup
    @empty = Seq.new
    @seq   = Seq.new([1, 2, 3, 4], 7, 1, "nope")
  end

  def test_can_become_array
    assert_equal [], @empty.to_a
    assert_equal [1, 2, 3, 4], @seq.to_a
  end

  def test_can_become_expanded_array
    assert_raises RangeError do
      @empty.entries
    end

    assert_equal [2, 3, 4, 1, 2, 3, 4], @seq.entries
  end

  def test_can_iterate
    @empty.each_with_index do |a,i|
      assert_equal a, nil
      break if i > 3
    end

    @seq.each_with_index do |a,i|
      assert_equal a, case i
        when 0 then 2
        when 1 then 3
        when 2 then 4
        when 3 then 1
        when 4 then 2
        when 5 then 3
        when 6 then 4
      end
    end
  end

  def test_gets_next_item
    assert_equal nil, @empty.next
    assert_equal nil, @empty.next

    assert_equal 2, @seq.next
    assert_equal 3, @seq.next
    assert_equal 4, @seq.next
    assert_equal 1, @seq.next
    assert_equal 2, @seq.next
    assert_equal 3, @seq.next
    assert_equal 4, @seq.next
    assert_equal "nope", @seq.next
    assert_equal "nope", @seq.next
  end

  def test_can_be_reset
    10.times { @seq.next }
    assert_equal "nope", @seq.next
    @seq.reset
    assert_equal 2, @seq.next
  end

end
