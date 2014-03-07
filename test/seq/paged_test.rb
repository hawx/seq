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

  def test_defines_each
    s = Seq::Paged.new do |page|
      page == 3 ? [] : [1]
    end

    s.each do |n|
      assert_equal n, 1
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

  def test_offset
    s = Seq::Paged.new(5, &@block)

    5.upto(99) do |n|
      assert_equal n, s.next
    end

    assert_equal nil, s.next
  end

  def test_entries
    s = Seq::Paged.new do |page|
      case page
      when 0 then [1,2,3]
      when 1 then [4]
      when 2 then [5,6]
      when 3 then []
      when 4 then [100]
      end
    end

    assert_equal s.entries, [1,2,3,4,5,6]
  end
end
