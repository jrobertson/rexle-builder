#!/usr/bin/env ruby

# file: rexle-builder.rb


class RexleArray < Array
  
  def initialize(raw_a)
    a = raw_a.first.is_a?(Array) ? raw_a : [raw_a]
    super(a)
  end
end


class RexleBuilder

  def self.build(debug: false)

    yield(self.new(debug: debug))

  end
  
  def initialize(obj=nil, root: 'root', debug: false)
    
    @debug = debug
    @a = []
    @current_a = @a
    @namespace = nil
    
    if obj.is_a? Hash then
      
      key = obj.keys.first      
      
      if obj.length > 1 or obj[key].is_a?(Array) or obj[key].is_a?(String) then
        self.send(root.to_sym) { buildx obj} 
      else
        self.send(key.to_sym) {buildx obj[key]}
      end

    end
  end

  def [](s)
    @namespace = s
    self
  end

  def to_a
    @a.first
  end

  def method_missing(sym, *args)
    
    puts 'args: ' + args.inspect if @debug
    
    value = args.shift if args.first.is_a? String    
    
    # The obj is an optional Hash object used to build nested XML 
    # after the current element
    attributes, obj = args
    
    if value =~ /^<.*>$/ then
      
      a = [
        sym.to_s, 
        attributes, 
        *Rexle.new("<root>%s</root>" % value, debug: @debug).to_a[2..-1]
      ]
      
    end
    
    if @debug then
      puts 'sym: ' + sym.inspect
      puts 'args: ' + args.inspect
    end
    
    # reserved keywords are masked with ._ e.g. ._method_missing
    a ||= [sym.to_s.sub(/^(?:\._|_)/,'').sub(/^cdata!$/,'![')\
         .sub(/^comment!$/, '!-'), attributes || {}, value || '']
    
    a.concat RexleBuilder.new(obj, debug: false).to_a[3..-1] if obj

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
  def buildx( h)

    h.each_pair do |key, value|

      if value.is_a? Hash then
        
        self.send(key.to_sym) do 
          buildx value
        end
        
      elsif value.is_a? Array  
        
        self.send(key.to_sym) do
          
          if value.first.is_a? Hash then
            value.map {|x| buildx x} 
          else
            RexleArray.new value
          end
          
        end
        
      else
        
        self.send(key.to_sym,  value.to_s)
        
      end
    end

  end  

end
