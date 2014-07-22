###Panthro - XPath/XQuery 3.0-ish written in Cocoa, for use in Cocoa

Panthro is an implementation of XPath in Objective-C with decent unit test coverage, and intended for use on Apple's iOS and OS X platforms with bindings for **libxml** and NSXML included.

Panthro is mostly a port of the XPath 1.0 portions of the excellent [Saxon](http://saxonica.com) 6.5 Java library by Michael Kay with my own additions.

Panthro supports all of XPath 1.0 and many of the most interesting features of 2.0 and even some of XPath 3.0 and XQuery. Here are some of the features supported by Panthro:

#####From XPath 1.0:
* Evertything (I think)

#####From XPath 2.0:
* Support for **sequences** (`('a', 'b', 'c')` or `()`)
* Steps in Path expressions may be arbitrary sub-expressions (`book/(chapter|appendix)/*`)
* `for` looping expressions
* `if` conditional expressions
* `some` and `every` quantified expressions
* Range expressions (`for $i in 1 to 10`)
* The `intersect`, `except`, and `union` operators
* NameTest wildcard ***prefixes*** such as `*:div` are supported
* Many of the XPath 2.0 functions are supported including **regex** support in `matches()` and `replace()`
* Scientific notation (exponents) are allowed in number literals

#####From XQuery 1.0:
* Support for **FLWOR** (For, Let, Where, Order by, Return) expressions
* Function declarations
* Variable declarations

#####From XPath 3.0:
* First-class inline functions (`let $func := function() { … }`)
* Anonymous functions (`$map((1,2,3), function($n) { $n*$n })`)
* String concatenation operator (`'foo' || 'bar'` produces `'foobar'`)
* Simple mapping operator (`/book/section ! count(chapter)`)

#####From XQuery 3.0:
* Switch expressions (`switch (1) case 1 return 'one' case 2 return 'two' default return 'unknown'`)

I think most people familiar with XPath and XQuery will agree these are the most usefull and interesting features beyond XPath 1.0, and Panthro has them all. Most of what is "missing" from XPath 2.0 in Panthro is related to the overly-complex and unpopular XML Schema-inspired static type system. Currently, implementing that portion of XPath 2.0 is not planned, and is probably a non-goal in the long term.

####Data Model
Panthro's current data model lies somewhere in between XPath 1.0 and 2.0. Panthro's type system has the simple, dynamic flavor and small number of types from XPath 1.0 plus the pervasive addition of Sequences from XPath 2.0.

The types are basically `item` (think base class), `string`, `number`, `boolean`, `node`, and `sequence`. As in XPath 2.0, every `item` is also a `sequence` of length 1. Any XPath or XQuery features related to explicit static types (e.g. `as xs:integer`) and casts (e.g. `cast as xs:string`, `treat as xs:double`, `instance of xs:dateTime`) are **not** currently supported, and will cause a syntax error.

The XPath parser is based on [PEGKit](http://www.github.com/itod/pegkit). The PEGKit dependency is managed via [git externals](http://nopugs.com/ext-tutorial).

If you find any missing features you would like, please let me know via an Issue on this GitHub project.

####Applications

Panthro currently powers two of my applications:

1. [Pathology](http://celestialteapot.com/pathology/) - XPath Debugger and Visualizer for OS X
1. [Pathological](http://celestialteapot.com/pathological/) - Search the OS X Finder with extreme precision using XPath

####Examples

Some example expressions that currently work (i.e. they are parsed, execute, and return a correct result):
```xquery
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

book/(chapter|appendix)/*

book/(chapter[position()=last()]|appendix[1])/text()
```
```xquery
let $map := function ($f, $seq) {
    for $item in $seq
        return $f($item)
}
return $map(function($arg) {$arg * $arg}, (1,2,3,4))
```
```xquery
declare function mysum($v) {
    let $head := $v[1],
        $tail := subsequence($v, 2)
            return 
                if (count($v) = 1) then 
                    $head 
                else 
                    $head + mysum($tail)
};
mysum((1,2,3))
```
####Non-standard Additions

1. Other functions of my own design are incuded in the default function namespace: `head()`, `tail()`, `title-case()`, and `trim-space()`.

####XML Tree Model Bindings

XPath works on a tree-like representation of an XML document. So Panthro needs a tree-based XML API available (in C, C++, or ObjC) on Apple platforms. The most commonly-used XML tree APIs on these platforms are:

* [libxml](http://xmlsoft.org/) (iOS, OS X, C, open source)
* [NSXML](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/NSXML_Concepts/Articles/NSXMLFeatures.html) (OS X, ObjC, closed-source)
* [WebKit's DOM](http://www.webkit.org/) (OS X, ObjC, open source)
* [Iconara DOM](http://www.iconara.net/developer/products/DOM/) (OS X, ObjC, open source)

Panthro is designed to work with any XML tree API, but requires a small adapter layer for each (an implementation of the `XPNodeInfo` and `XPDocumentInfo` protocols). Panthro currently includes an adapter layer for libxml (for iOS and OS X) and NSXML (for OS X only).

####Objective-C API

To use Panthro with NSXML on OS X:

```objc
// Build XML doc with NSXML
NSString *str = …
NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithXMLString:str options:0 error:nil] autorelease];

// Wrap NSXML doc in Panthro adapter (id <XPNodeInfo>)
id <XPNodeInfo>ctxNode = [[[XPNSXMLDocumentImpl alloc] initWithNode:doc] autorelease];

// Create a Panthro stand-alone XPath context
XPStandaloneContext *env = [XPStandaloneContext standaloneContext];
```
The Panthro API allows you to first compile your XPath string into an intermediate tree representation (Abstract Syntax Tree, or AST), which can then be evaluated multiple times. The type of the AST is `XPExpression`. The API keywords for this are `compile` and `evaluate`:

```objc
// compile first…
NSError *err = nil;
XPExpression *expr = [env compile:@"book/chapter[@id='ch1']/title" error:&err];

// …then evaluate (possibly multiple times) later
NSString *ch1Title = [env evaluate:expr withContextNode:ctxNode error:&err];
```

Alternatively, the Panthro API allows you to complile and evaluate an XPath string all in one go. The API keyword for this combined action is `execute`:

```objc
// compile and evaluate together (AKA `execute`)
NSError *err = nil;
NSString *ch1Title = [env execute:@"book/chapter[@id='ch1']/title" withContextNode:ctxNode error:&err];
```