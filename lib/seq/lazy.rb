require 'seq'

class Seq

  # Lazy seqs evaluate a block to determine the next value when needed,
  # this value is then saved.
  #
  # @example
  #
  #   s = Seq::Lazy.new([1]) { 1 }
  #   s.take(3) #=> [1, 1, 1]
  #
  #   ns = Seq::Lazy.new([1]) {|l| l[-1] + 1 }
  #   ns.take(5) #=> [1, 2, 3, 4, 5]
  #
  #   fibs = Seq::Lazy.new([1, 1]) {|l| l[-1] + l[-2] }
  #   fibs.take(7) #=> [1, 1, 2, 3, 5, 8, 13]
  #   fibs.take!(7) #=> [21, 34, 55, 89, 144, 233, 377]
  #   fibs.take!(2) #=> [21, 34]
  #
  class Lazy < Seq

    # Creates a new Lazy seq instance.
    #
    # @param list [Array] Starting values
    # @param items [Integer] Number of values to return
    # @param offset [Integer] Index of item to start at
    # @param default [Object] Value to return when finished cycling
    #
    # @yield [list] Block to be called which returns the next value in the list
    # @yieldparam list [Array] The list calculated up to the current point
    def initialize(list=[], items=Float::INFINITY, offset=0, default=nil, &block)
      @list    = list
      @items   = items
      @block   = block
      @offset  = offset
      @default = default

      self.reset
    end

    # Resets the state of the lazy seq. It also calculates any values
    # necessary to get to the offset.
    def reset
      @index  = @list.size
      @cycles = 0

      until @list.size >= @offset
        @list[@index] = @block.call(@list[0..@index-1])
        @index += 1
      end

      @index = @offset
    end

    # @return [Object]
    #  Until ended it returns the next item from +list+ if it exists or calculates
    #  it then stores it in +list+, if ended it returns the default value.
    def next
      if ended?
        @default
      else
        @index += 1
        if @index-1 < @list.size
          @list[@index-1]
        else
          @list[@index-1] = @block.call(@list)
        end
      end
    end

  end
end
