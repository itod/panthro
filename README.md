###Panthro - XPath 1.0 written in Cocoa, for use in Cocoa

Panthro is an implementation of XPath 1.0 in Objective-C with decent unit test coverage, and intended for use on Apple's iOS and OS X platforms.

Panthro is a mostly a port of the excellent [Saxon](http://saxonica.com) 6.5 (Java) by Michael Kay.

The XPath 1.0 parser is based on [PEGKit](http://www.github.com/itod/pegkit). The PEGKit dependency is managed via [git externals](http://nopugs.com/ext-tutorial).

What's done?

* Almost everything!

What's missing?

* The `following`, `following-sibling`, `preceding`, `preceding-sibling`, and `namespace` axes are not yet implemented.
* Variable expressions are not yet complete.
* Namespace-aware QName testing in `NameTest`s is currently dodgy (but can be fixed).
* Namepsace prefix wildcards (`*:local-name`) are NOT yet implemented. But plain-ole name wildcards (`*`) ARE.

Some example expressions that currently work (i.e. they are parsed, execute, and return a correct result):

    boolean(false() != true())

    not(string-length('foo') = 1)

    substring('12345', 2, 3)

    substring-before('1999/04/01', '/')

    /

    .

    .. 

    chapter

    chapter/title

    *[@id]

    //para

    chapter[@id='c1' or @id='c3']

    .|/|(//para)[2]

    (//para)[1]|//chapter/@id[string(.)='c1']

    ancestor-or-self::node()

    chapter/@id != chapter[2]/@id

###Objective-C API

XPath works on a tree-like representation of an XML document. So Panthro needs a tree-based XML API available (in C, C++, or ObjC) on Apple platforms. The most commonly-used XML tree APIs on these platforms are:

* [NSXML](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/NSXML_Concepts/Articles/NSXMLFeatures.html) (OS X, ObjC, closed-source)
* [WebKit's DOM](http://www.webkit.org/) (OS X, ObjC, open source)
* [libxml](http://xmlsoft.org/) (iOS, OS X, C, open source)
* [Iconara DOM](http://www.iconara.net/developer/products/DOM/) (OS X, ObjC, open source)

Panthro is designed to work with any XML tree API, but requires a small adapter layer for each (an implementation of the `XPNodeInfo` and `XPDocumentInfo` protocols). Panthro currently only has an adapter for Apple's NSXML API. I plan on adding a libxml adapter soon (this is relatively easy to do).

To use Panthro with NSXML on OS X:

    NSString *str = …
    NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithXMLString:str options:0 error:nil] autorelease];
    
    XPStandaloneContext *env = [XPStandaloneContext standaloneContext];

    NSError *err = nil;
    NSString ch1Title = [env evalutate:@"book/chapter[@id='ch1']/title" withNSXMLContextNode:doc error:&err];
    