class Seq

  class Random < Seq
  
    def initialize(list=[], items=Infinity, default=nil)
      super(list, items, 0, default)
    end
    
    def next
      if ended?
        @default
      else
        @list[rand(@list.size).to_i].tap { inc }
      end
    end
  
  end
end