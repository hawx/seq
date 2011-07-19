class Seq

  Infinity = 1.0/0

  # Creates a new instance of Seq.
  #
  # @param list [Array] 
  #   List of values to cycle over
  # @param items [Integer] 
  #   Number of values to return
  # @param offset [Integer] 
  #   Index of item in +list+ to start at
  # @param default [Object]
  #   Value to return when finished cycling
  #
  def initialize(list=[], items=Infinity, offset=0, default=nil)
    @list    = list
    @items   = items
    @offset  = offset
    @default = default
    
    self.reset
  end
  
  # Resets the Seqs position to the same as when initialized.
  def reset
    @cycles = 0
    @index  = @offset
  end
  
  # @return [Object]
  #  Until ended returns the next item from the list, when ended it returns the
  #  default item.
  def next
    if ended?
      @default
    else
      @list[@index].tap { inc }
    end
  end
  
  # Increment the list index, the number of cycles completed and if at the end of 
  # the list returns to the first item.
  # 
  # @return [Integer] Number of items that have been returned.
  def inc
    if @index+1 == @list.size
      @index = 0 
    else
      @index += 1
    end
    @cycles += 1
  end
  
  # Iterates over each item as returned by #next until #ended?.
  def each
    until ended?
      yield self.next
    end
  end
  
  include Enumerable

  def entries
    raise RangeError if infinite?
  
    i, c = @index, @cycles
    r = super
    @index, @cycles = i, c
    r
  end

  # @return [Array] Returns the original list
  def to_a
    @list
  end
  
  def infinite?
    @items == Infinity
  end

  def ended?
    @cycles >= @items
  end
  
end
