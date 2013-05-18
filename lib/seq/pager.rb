require 'seq'

class Seq

  # Takes a list of items and returns them in pages. This can be thought of as
  # doing the opposite of {Seq::Paged}.
  #
  # @example
  #
  #   pages = Seq::Paged.new(5, 1..100)
  #
  #   pages.next     #=> [1,2,3,4,5]
  #   pages.next     #=> [6,7,8,9,10]
  #   pages.prev     #=> [1,2,3,4,5]
  #   pages.page     #=> 0
  #   pages.first?   #=> true
  #   pages.last     #=> [96,97,98,99,100]
  #
  class Pager < Seq

    # Creates a new instance of Pager.
    #
    # @param page_size [Integer] Size of page to use
    # @param start_page [Integer] Page to start at
    # @param elements [Enumerable] Items to initialize with
    def initialize(page_size, start_page=nil, elements)
      @pages = elements.each_slice(page_size).to_a
      @curr  = start_page || 0
    end

    # Sets the current page. If the number passed is out of range, it will be
    # set to within the bound of available pages.
    #
    # @param num [#to_i]
    def page=(num)
      unless num.respond_to?(:to_i)
        raise ArgumentError.new("cannot call #to_i on argument")
      end

      num = num.to_i
      num = 0           if num < 0
      num = pages - 1   if num >= pages

      @curr = num
    end

    # @return [Integer] The index of the current page.
    def page
      @curr
    end

    # @return [Integer] The total number of pages.
    def pages
      @pages.size
    end

    # @return Whether currently at the first page.
    def first?
      page == 0
    end

    # Moves to the first page.
    #
    # @return [Seq::Pager]
    def first!
      @curr = 0
      self
    end

    # Moves to the first page, and returns it.
    #
    # @return [Array]
    def first
      @curr = 0
      curr
    end

    # @return Whether currently at the last page.
    def last?
      page == pages - 1
    end

    # Moves to the last page.
    #
    # @return [Seq::Pager]
    def last!
      @curr = 0
      self
    end

    # Moves to the last page, and returns it.
    #
    # @return [Array]
    def last
      @curr = pages - 1
      curr
    end

    # @return [Array] Returns the current page without modifying the
    #   current position.
    def curr
      @pages[@curr]
    end

    # Moves the next page, and returns the {Pager} object itself. If at the last
    # page it simply returns +self+.
    #
    # @return [Seq::Pager]
    def next!
      @curr += 1 unless last?
      self
    end

    # Moves to, and returns the next page. If at the last page it returns +nil+.
    #
    # @return [Array, nil]
    def next
      return if last?

      @curr += 1
      curr
    end

    # Moves to the previous page, and returns the {Pager} object itself. If at
    # the first page it simply returns +self+.
    #
    # @return [Seq::Pager]
    def prev!
      @curr -= 1 unless first?
      self
    end

    # Moves to, and returns, the previous page. If at the first page it returns
    # +nil+.
    #
    # @return [Array, nil]
    def prev
      return if first?

      @curr -= 1
      curr
    end

    # Provides a list of page numbers, useful for populating a page selector. It
    # returns an array containing three arrays, some of which may be empty.
    #
    # @param left [Integer] Maximum number of elements for the left-most array
    # @param middle [Integer] Maximum number of elements for either side of the
    #   current page
    # @param right [Integer] Maximum number of elemengts for the right-most array
    #
    # @example
    #
    #   s = Seq::Pager.new(10, 1..1000)
    #
    #   s.range(2, 2, 2)
    #   #=> [[0, 1, 2, 3, 4, 5, 6, 7], [], [98, 99]]
    #
    #   s.page = 10
    #   s.range(2, 2, 2)
    #   #=> [[0, 1, 2], [48, 49, 50, 51, 52], [98, 99]]
    #
    def range(left, middle, right)
      width = 2 * middle + 1

      if pages < left + width + right
        return [(0..pages-1).to_a, [], []]
      end

      if page < left + middle + 1
        left   = (0..left+width-1).to_a
        middle = []
        right  = (pages-right..pages-1).to_a

      elsif page > (pages - 1) - right - middle - 1
        left   = (0..left-1).to_a
        middle = []
        right  = (pages-right-width..pages-1).to_a

      else
        left   = (0..left-1).to_a
        middle = (page-middle..page+middle).to_a
        right  = (pages-right..pages-1).to_a
      end

      [left, middle, right]
    end

  end
end
