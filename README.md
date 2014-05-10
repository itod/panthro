An implementation of XPath 1.0 in Objective-C/Cocoa with decent unit test coverage.

This is a mostly a port of Saxon 6.5 (Java) by Michael Kay.

The XPath 1.0 parser is based on [PEGKit](http://www.github.com/itod/pegkit).

What's done?

* Almost everything!

What's missing?

* The `following`, `following-sibling`, `preceding`, `preceding-sibling`, and `namespace` axes are not yet implemented.

* Variable expressions are not yet complete.

Some example expressions that currently work (i.e. they are parsed, execute, and return a result):

<pre>
boolean(false() != true())

not(string-length('foo') = 1)

substring('12345', 2, 3)

substring-before('1999/04/01', '/')

/

.

.. 

chapter

chapter/title

//para

chapter[@id='c1' or @id='c3']

.|/|(//para)[2]

(//para)[1]|//chapter/@id[string(.)='c1']

ancestor-or-self::node()

chapter/@id != chapter[2]/@id

</pre>