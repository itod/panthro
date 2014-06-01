###Panthro - XPath 1.0 written in Cocoa, for use in Cocoa

Panthro is an implementation of XPath 1.0 in Objective-C with decent unit test coverage, and intended for use on Apple's iOS and OS X platforms.

Panthro is a mostly a port of the excellent [Saxon](http://saxonica.com) 6.5 (Java) by Michael Kay.

The XPath 1.0 parser is based on [PEGKit](http://www.github.com/itod/pegkit). The PEGKit dependency is managed via [git externals](http://nopugs.com/ext-tutorial).

What's done?

* Everything! Panthro should implement the entire XPath 1.0 spec. If you find any missing features, please let me know via an Issue on this GitHub project.

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

    chapter[3]/preceding-sibling::*[2]/title

    //chapter[1]/@*[namespace-uri(.)='bar']/..

    id('c2 c1')[2]/title

###Non-standard Additions

Panthro departs from the XPath 1.0 spec in the following known ways:

1. Some functions from XPath 2.0 are incuded: `abs()`, `compare()`, `ends-with()`, `lower-case()`, `matches()`, `normalize-unicode()` `replace()`, and `upper-case()`.
1. Other functions of my own design is incuded in the default function namespace: `title-case()`, and `trim-space()`.
1. Scientific notation (exponents) are allowed in number literals.

###XML Tree Model Bindings

XPath works on a tree-like representation of an XML document. So Panthro needs a tree-based XML API available (in C, C++, or ObjC) on Apple platforms. The most commonly-used XML tree APIs on these platforms are:

* [libxml](http://xmlsoft.org/) (iOS, OS X, C, open source)
* [NSXML](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/NSXML_Concepts/Articles/NSXMLFeatures.html) (OS X, ObjC, closed-source)
* [WebKit's DOM](http://www.webkit.org/) (OS X, ObjC, open source)
* [Iconara DOM](http://www.iconara.net/developer/products/DOM/) (OS X, ObjC, open source)

Panthro is designed to work with any XML tree API, but requires a small adapter layer for each (an implementation of the `XPNodeInfo` and `XPDocumentInfo` protocols). Panthro currently includes an adapter layer for libxml and NSXML.

###Objective-C API

To use Panthro with NSXML on OS X:

    // Build XML doc with NSXML
    NSString *str = …
    NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithXMLString:str options:0 error:nil] autorelease];
    
    // Wrap NSXML doc in Panthro adapter (id <XPNodeInfo>)
    id <XPNodeInfo>ctxNode = [[[XPNodeInfoNSXMLImpl alloc] initWithNode:doc] autorelease];
    
    // Create a Panthro stand-alone XPath context
    XPStandaloneContext *env = [XPStandaloneContext standaloneContext];

The Panthro API allows you to first compile your XPath string into an intermediate tree representation (Abstract Syntax Tree, or AST), which can then be evaluated multiple times. The type of the AST is `XPExpression`. The API keywords for this are `compile` and `evalutate`:

    // compile first…
    NSError *err = nil;
    XPExpression *expr = [env compile:@"book/chapter[@id='ch1']/title" error:&err];
    
    // …then evaluate later
    NSString ch1Title = [env evaluate:expr withContextNode:ctxNode error:&err];

Alternatively, the Panthro API also allows you to complile and evaluate an XPath string all in one go. The API keyword for this combined action is `execute`:

    // compile and evaluate together (AKA `execute`)
    NSError *err = nil;
    NSString ch1Title = [env execute:@"book/chapter[@id='ch1']/title" withContextNode:ctxNode error:&err];
