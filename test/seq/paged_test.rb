$: << File.dirname(__FILE__) + '/..'
require 'helper'

class PagedSeqTest < MiniTest::Test

  PAGE_COUNT = 10
  PAGE_SIZE  = 10

  def setup
    @block = lambda do |page|
      return [] if page == PAGE_COUNT
      (page*PAGE_SIZE...page.succ*PAGE_SIZE).to_a
    end
  end

  def test_defines_next
    s = Seq::Paged.new(&@block)

    0.upto(99) do |n|
      assert_equal n, s.next
    end

    assert_equal nil, s.next
  end

  def test_defines_default
    s = Seq::Paged.new(0, "default", &@block)

    0.upto(99) do |n|
      assert_equal n, s.next
    end

    assert_equal "default", s.next
  end

  def test_offset_works
    s = Seq::Paged.new(5, &@block)

    5.upto(99) do |n|
      assert_equal n, s.next
    end

    assert_equal nil, s.next
  end

end
