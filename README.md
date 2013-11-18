# Introducing the rexle-builder gem

    xml = RexleBuilder.new
    a = xml.root do
      xml.fun do
        xml.tree({country: 'Canada'}, 'mahogany')
      end
      xml.green 'leaves'
    end

    Rexle.new(a).xml
    #=> <?xml version='1.0' encoding='UTF-8'?>\n<root><fun><tree country='Canada'>mahogany</tree></fun><green>leaves</green></root></pre>

The rexle-builder gem accepts builder style markup and returns a
nested array suitable for parsing by Rexle.

## Resources: 

* [jrobertson/rexle-builder](https://github.com/jrobertson/rexle-builder)

builder gem rexlebuilder ruby xml
