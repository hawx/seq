require 'seq'

class Seq

  # Paged seqs evaluate a block that returns a page (Array) of items that are
  # then returned one at a time. This is useful for working with web services
  # that return pages of results, when you need them as a list.
  #
  # @example
  #
  #   s = Seq::Paged.new {|page| [page, page+1, page+2] }
  #   s.take(10)  #=> [0, 1, 2,  1, 2, 3,  2, 3, 4,  3]
  #               #  extra spacing added to show pages
  #
  #
  #   require 'flickraw'
  #   # Authenticate FlickRaw...
  #
  #   f = Seq::Paged.new {|page|
  #     flickr.people.getPhotos(:user_id => 'me', :page => page).to_a
  #   }
  #   f.next #=> {"id"=>"8688497043", "owner"=>"75695140@N04", ...}
  #   f.take(100).map {|photo| photo['title'] }.grep(/DSC/)
  #   #=> ["DSC01485-edit", "DSC01485", "DSC01482-edit", "DSC01481", ...]
  #
  class Paged < Seq

    # Creates a new Paged seq instance.
    #
    # @param offset [Integer] Index of item to start at
    # @param default [Object] Value to return when finished
    #
    # @yield [page] Block to be called which returns the next page of items
    # @yieldparam page [Integer] Page to be returned, begins at 0
    def initialize(offset=0, default=nil, &block)
      @block   = block
      @offset  = offset
      @default = default

      self.reset
    end

    # Resets the state of the paged seq. It also calculates any values necessary
    # to get to the offset.
    def reset
      @index = 0
      @page  = 0
      @done  = false
      @items = []

      until @index >= @offset
        self.next
      end
    end

    # @return Whether the Paged seq has returned all of its items.
    def ended?
      @index >= @items.size && @done
    end

    # @return [Object] Until ended it return the next item in the paged list. If
    #  ended it returns the default value.
    def next
      return @default if ended?

      while @items.size <= @index
        loaded = @block.call(@page)
        @page += 1
        if loaded.empty?
          @done = true
          return @default
        end
        @items += loaded
      end

      item = @items[@index]
      @index += 1
      item
    end


  end
end
