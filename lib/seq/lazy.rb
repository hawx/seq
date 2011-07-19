class Seq

  class Lazy < Seq
    
    # @param list [Array] Starting values
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
    def initialize(list=[], &block)
      @list  = list
      @block = block
      @index = 0
    end
    
    def next
      @index += 1
      if @index-1 < @list.size
        @list[@index-1]
      else
        @list[@index-1] = @block.call(@list)
      end
    end
    
    def ended?
      false
    end
    
    def infinite?
      true
    end
  
  end
end
