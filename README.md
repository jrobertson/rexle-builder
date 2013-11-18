# Introducing the rexle-builder gem

    xml = RexleBuilder.new
    a = xml.root do
      xml.fun do
        xml.tree({country: 'Canada'}, 'mahogany')
      end
      xml.green 'leaves'
    end

    Rexle.new(a).xml
    #=&gt; &lt;?xml version='1.0' encoding='UTF-8'?&gt;\n&lt;root&gt;&lt;fun&gt;&lt;tree country='Canada'&gt;mahogany&lt;/tree&gt;&lt;/fun&gt;&lt;green&gt;leaves&lt;/green&gt;&lt;/root&gt;&lt;/pre&gt;

The rexle-builder gem accepts builder style markup and returns a
nested array suitable for parsing by Rexle.

## Resources: 

* [jrobertson/rexle-builder](https://github.com/jrobertson/rexle-builder)

builder gem rexlebuilder ruby xml
