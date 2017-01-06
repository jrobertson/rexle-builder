#!/usr/bin/env ruby

# file: rexle-builder.rb


class RexleArray < Array
  
  def initialize(raw_a)
    a = raw_a.first.is_a?(Array) ? raw_a : [raw_a]
    super(a)
  end
end


class RexleBuilder

  def initialize(obj=nil)
    
    @a = []
    @current_a = @a
    @namespace = nil
    
    self.root { build obj} if obj.is_a? Hash
  end

  def [](s)
    @namespace = s
    self
  end

  def to_a
    @a.first
  end

  def method_missing(sym, *args)
    
    args << '' if args.last.is_a? Hash 
    value, attributes = args.reverse
    
    # reserved keywords are masked with ._ e.g. ._method_missing
    a = [sym.to_s.sub(/^\._/,'').sub(/^cdata!$/,'!['), attributes || {}, \
                                                                   value || '']

    if @namespace then 
      a.first.prepend(@namespace + ':')
      @namespace = nil 
    end

    @current_a << a
    
    if block_given? then
      
      prev_a = @current_a
      @current_a = a
      
      r = yield()     
      
      @current_a.concat r if r.class == RexleArray
      @current_a = prev_a      
      
    end
    
    @a.first
  end
  
  private
  
  # build from a Hash object
  #
  def build( h)

    h.each_pair do |key, value|

      if value.is_a? Hash then
        
        self.send(key.to_sym) do 
          build value
        end
        
      else
        
        self.send(key.to_sym,  value)
        
      end
    end

  end  

end