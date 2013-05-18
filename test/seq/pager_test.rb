$: << File.dirname(__FILE__) + '/..'
require 'helper'

class PagerSeqTest < MiniTest::Unit::TestCase

  PAGE_COUNT = 10
  PAGE_SIZE  = 10


  def test_page_setting
    s = Seq::Pager.new(5, 1..100)
    s.page = 5
    assert_equal s.page, 5
  end

  def test_page_setting_error
    s = Seq::Pager.new(5, 1..100)

    assert_raises ArgumentError do
      s.page = Object.new
    end
  end

  def test_page
    s = Seq::Pager.new(5, 1..100)
    assert_equal s.page, 0
  end

  def test_first?
    s = Seq::Pager.new(5, 1..100)
    assert s.first?

    s.next
    refute s.first?
  end

  def test_last?
    s = Seq::Pager.new(5, 1..10)
    refute s.last?

    s.next
    assert s.last?
  end

  def test_pages
    s = Seq::Pager.new(5, 1..100)
    assert_equal s.pages, 20
  end

  def test_curr
    s = Seq::Pager.new(5, 1..100)
    assert_equal [1,2,3,4,5], s.curr
  end

  def test_next
    s = Seq::Pager.new(5, 1..100)
    assert_equal [6,7,8,9,10], s.next
  end

  def test_next!
    s = Seq::Pager.new(5, 1..100)
    s = s.next!
    assert_instance_of Seq::Pager, s
    assert_equal       s.page, 1
  end

  def test_prev
    s = Seq::Pager.new(5, 1..100)
    assert_equal [6,7,8,9,10], s.next!.next!.prev
  end

  def test_prev!
    s = Seq::Pager.new(5, 1..100)
    s = s.next!.next!.prev!
    assert_instance_of Seq::Pager, s
    assert_equal       s.page, 1
  end

  def test_range
    s = Seq::Pager.new(2, 1..100)
    assert_equal s.range(2, 2, 2), [[0, 1, 2, 3, 4, 5, 6], [], [48, 49]]

    s.page = 25
    assert_equal s.range(2, 2, 2), [[0, 1], [23, 24, 25, 26, 27], [48, 49]]

    s.last
    assert_equal s.range(2, 2, 2), [[0, 1], [], [43, 44, 45, 46, 47, 48, 49]]
  end

  def test_range_cases
    s = Seq::Pager.new(50, 1..100)
    assert_equal s.range(2, 2, 2), [[0, 1], [], []]

    s = Seq::Pager.new(2, 1..100)

    s.page = 4
    assert_equal s.range(2, 2, 2), [[0, 1, 2, 3, 4, 5, 6], [], [48, 49]]

    s.page = 5
    assert_equal s.range(2, 2, 2), [[0, 1], [3, 4, 5, 6, 7], [48, 49]]

    s.page = 44
    assert_equal s.range(2, 2, 2), [[0, 1], [42, 43, 44, 45, 46], [48, 49]]

    s.page = 45
    assert_equal s.range(2, 2, 2), [[0, 1], [], [43, 44, 45, 46, 47, 48, 49]]
  end

end
