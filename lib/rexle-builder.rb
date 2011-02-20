#!/usr/bin/ruby

# file: rexle-builder.rb

class RexleBuilder

  def initialize()
    @a = []
    @current_a = @a
  end

  def to_a
    @a.first
  end

  def method_missing(sym, *args)
    value, attributes = args.reverse
    a = [sym.to_s, value || '', attributes || {}]
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