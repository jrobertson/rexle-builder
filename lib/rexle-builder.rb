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

    value = args.find {|x| x.is_a? String} || ''
    attributes, obj = args.select {|x| x.is_a? Hash}

    # The obj is an optional Hash object used to build nested XML
    # after the current element

    if value =~ /^<.*>$/ then

      a = [
        sym.to_s,
        attributes,
        *Rexle.new("<root>%s</root>" % value, debug: @debug).to_a[2..-1]
      ]

    end


    # reserved keywords are masked with ._ e.g. ._method_missing
    a ||= [sym.to_s.sub(/^(?:\._|_)/,'').sub(/^cdata!$/,'![')\
         .sub(/^comment!$/, '!-'), attributes || {}, value || '']
    if @debug then
      puts 'sym: ' + sym.inspect
      puts 'args: ' + args.inspect
      puts 'obj: ' + obj.inspect
      puts 'a: ' + a.inspect
    end

    a.concat RexleBuilder.new(obj, debug: false).to_a[3..-1] if obj

    if @namespace then
      a.first.prepend(@namespace + ':')
      @namespace = nil
    end

    @current_a << a
    puts '@current_a, before block_given : ' + @current_a.inspect if @debug

    if block_given? then

      prev_a = @current_a
      @current_a = a

      r = yield()

      if @debug then
        puts 'r: ' + r.inspect
        puts 'r.class: ' + r.class.inspect
      end

      return r if r == @a.first

      if r.is_a? Array then

        # only concat if r contains raw Rexle elements.
        if r.all? {|field, attributes, value| attributes.is_a? Hash} then
          @current_a.concat r
        end

      end
      puts '@current_a ' + @current_a.inspect if @debug
      @current_a = prev_a
      return @a.first

    end

    #@a.first
    nil
  end

  private

  # build from a Hash object
  #
  def buildx( h)

    puts 'buildx: ' + h.inspect if @debug
    # the following statement prevents duplicate elements where 1 key is
    # represented by a String and the other by a symbol.
    #
    h2 = h.map {|x| [x[0].to_sym, x[1]]}.to_h

    h2.each_pair do |key, value|

      if value.is_a? Hash then
        puts 'buildx found Hash' + value.inspect if @debug
        self.send(key.to_sym) do
          buildx value
          nil
        end

      elsif value.is_a?(Array) and value.first.is_a? Hash

        puts 'buildx found Array' + value.inspect if @debug
        puts 'key:' + key.inspect if @debug

        self.send(key.to_sym) do

          r2= []
          value.each do |x|

            if x.is_a? Hash then
              puts 'x:' + x.inspect if @debug
              buildx x
              nil
            else
              puts 'x2:' + x.inspect if @debug
               r2 << x
            end

          end

          r2
        end

      else

        puts 'buildx found other' + value.inspect  if @debug
        if value.is_a? String then
          self.send(key.to_sym,  value.to_s)
        else
           self.send(key.to_sym) {[value]}
        end

      end
    end

  end

end
