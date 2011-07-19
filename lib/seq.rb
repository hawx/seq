unless defined?(Float::INFINITY)
  # Define Float::INFINITY if not previously defined
  Float::INFINITY = 1.0/0
end

# A Seq will cycle over a list returning a certain number of items.
#
# @example With number of items to return
#
#   s = Seq.new([1, 2], 4)
#   s.next #=> 1
#   s.next #=> 2
#   s.next #=> 1
#   s.next #=> 2
#   s.next #=> nil
#
# @example With an offset
#
#   s = Seq.new([1, 2, 3, 4, 5], 5, 3)
#   s.next #=> 4
#   s.next #=> 5
#   s.next #=> 1
#   # etc
#
# @example With default value
#
#   s = Seq.new([1, 2], 2, 0, 2)
#   s.next #=> 1
#   s.next #=> 2
#   s.next #=> 2
#   s.next #=> 2
#
class Seq

  # Creates a new instance of Seq.
  #
  # @param list [Array] List of values to cycle over
  # @param items [Integer] Number of values to return
  # @param offset [Integer] Index of item in +list+ to start at
  # @param default [Object] Value to return when finished cycling
  def initialize(list=[], items=Float::INFINITY, offset=0, default=nil)
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
  
  # @return Until ended it returns the next item from the list, when ended it returns 
  #  the default item.
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

  # @return [Array] The items that would be returned by repeated calls to #next
  #  until #ended?.
  # @raise [RangeError] If #infinite?, otherwise it creates an infinite loop!
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
  
  # @return Whether the Seq returns infinite items.
  def infinite?
    @items == Float::INFINITY
  end

  # @return Whether the Seq has returned enough items.
  def ended?
    @cycles >= @items
  end
  
  # Any method called on a Seq with ending with !, will be caught by method
  # missing, it will then attempt to call the non ! version but will not
  # alter the index or number of cycles completed. 
  def method_missing(sym, *args, &block)
    if sym.to_s[-1] == "!" && 
      self.respond_to?(sym.to_s[0..-2].to_sym) &&
      ! [:infinite?, :ended?, :to_a, :entries, :inc, :reset].include?(sym.to_s[0..-2].to_sym)
      
      begin
        i, c = @index, @cycles
        self.send(sym.to_s[0..-2].to_sym, *args, &block)
      ensure
        @index, @cycles = i, c
      end
    else
      super
    end
  end
end

require 'seq/lazy'
require 'seq/random'
require 'seq/version'
