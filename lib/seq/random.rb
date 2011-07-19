require 'seq'

class Seq

  # A Random seq chooses items from the list randomly.
  #
  # @example
  #
  #   s = Seq::Random.new([1,2,3,4,5])
  #   s.take(6) #=> [1, 4, 5, 3, 1, 2] 
  #
  class Random < Seq
  
    # Creates a new Random seq instance.
    #
    # @param list [Array] List of values to cycle over
    # @param items [Integer] Number of values to return
    # @param default [Object] Value to return when finished cycling
    def initialize(list=[], items=Float::INFINITY, default=nil)
      super(list, items, 0, default)
    end
    
    # @return Until ended it returns a randomly selected item from the list, when 
    #  ended it returns the default value.
    def next
      if ended?
        @default
      else
        @list[rand(@list.size).to_i].tap { inc }
      end
    end
  
  end
end
