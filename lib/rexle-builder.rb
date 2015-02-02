#!/usr/bin/env ruby

# file: rexle-builder.rb

class RexleBuilder

  def initialize()
    @a = []
    @current_a = @a
    @namespace = nil
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
      yield()
      @current_a = prev_a      
    end
    @a.first
  end

end
