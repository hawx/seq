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
  
  def reset
    @cycles = 0
    @index  = @offset
  end
  
  def next
    if ended?
      @default
    else
      @list[@index].tap { inc }
    end
  end
  
  def inc
    @index  += 1
    @cycles += 1
    @index   = 0 if @index == @list.size
  end
  
  def each
    until ended?
      yield self.next
    end
  end
  
  include Enumerable

  def to_a(expanded=false)
    if expanded
      raise RangeError if infinite?
      
      i, c = @index, @cycles
      r = self.entries
      @index, @cycles = i, c
      
      r
    else
      @list
    end
  end
  
  def infinite?
    @items == Infinity
  end

  def ended?
    @cycles >= @items
  end
  
end
