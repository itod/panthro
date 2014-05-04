//
//  XPStandaloneContext.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPStandaloneContext.h"
#import <XPath/XPUtils.h>
#import <XPath/XPExpression.h>
#import "NSError+XPAdditions.h"

NSString *XPNamespaceXML = @"http://www.w3.org/XML/1998/namespace";
NSString *XPNamespaceXSLT = @"http://www.w3.org/1999/XSL/Transform";
NSString *XPNamespaceAquaPath = @"http://celestialteapot.com/ns/aquapath";

@implementation XPStandaloneContext

- (instancetype)init {
    self = [super init];
    if (self) {
		[self declareNamespaceURI:XPNamespaceXML forPrefix:@"xml"];
		[self declareNamespaceURI:XPNamespaceXSLT forPrefix:@"xsl"];
		[self declareNamespaceURI:XPNamespaceAquaPath forPrefix:@"ap"];
        [self declareNamespaceURI:@"" forPrefix:@""];
    }
    return self;
}


- (void)dealloc {
    self.namespaces = nil;
    [super dealloc];
}

    
	/**
     * Declare a namespace whose prefix can be used in expressions
     */
    
- (void)declareNamespaceURI:(NSString *)uri forPrefix:(NSString *)prefix {
    NSParameterAssert(uri);
    NSParameterAssert(prefix);
    XPAssert(_namespaces);
    _namespaces[prefix] = uri;
}
    

    /**
     * Get the system ID of the container of the expression
     * @return "" always
     */
    
- (NSString *)systemId {
    return @"";
}

    /**
     * Get the Base URI of the stylesheet element, for resolving any relative URI's used
     * in the expression.
     * Used by the document() function.
     * @return "" always
     */
    
- (NSString *)baseURI {
    return @"";
}

    /**
     * Get the line number of the expression within that container
     * @return -1 always
     */
    
- (NSUInteger)lineNumber {
    return -1;
}
    
    /**
     * Get the URI for a prefix, using this Element as the context for namespace resolution
     * @param prefix The prefix
     * @throw XPathException if the prefix is not declared
     */
    
- (NSString *)namespaceURIForPrefix:(NSString *)prefix error:(NSError **)err {
    NSParameterAssert(prefix);
    XPAssert(_namespaces);
    
    NSString *uri = _namespaces[prefix];
    if (!uri) {
        if (err) {
            *err = [NSError XPathErrorWithCode:47 format:@"Prefix %@ has not been declared", prefix];
        }
    }

    return uri;
}
//
//    /**
//     * Make a NameCode, using this Element as the context for namespace resolution
//     * @param qname The name as written, in the form "[prefix:]localname"
//     * @boolean useDefault Defines the action when there is no prefix. If true, use
//     * the default namespace URI (as for element names). If false, use no namespace URI
//     * (as for attribute names).
//     */
//    
//    public final int makeNameCode(String qname, boolean useDefault) throws XPathException {
//		String prefix = Name.getPrefix(qname);
//		String localName = Name.getLocalName(qname);
//		String uri;
//		if (prefix.equals("") && useDefault) {
//			uri = "";
//		} else {
//			uri = getURIForPrefix(prefix);
//		}
//		return namePool.allocate(prefix, uri, localName);
//	}
//    
//    /**
//     * Make a fingerprint, using this Element as the context for namespace resolution
//     * @param qname The name as written, in the form "[prefix:]localname"
//     * @boolean useDefault Defines the action when there is no prefix. If true, use
//     * the default namespace URI (as for element names). If false, use no namespace URI
//     * (as for attribute names).
//     * @throw XPathException if the name is not already present in the namepool.
//     */
//    
//    public final int getFingerprint(String qname, boolean useDefault) throws XPathException {
//		String prefix = Name.getPrefix(qname);
//		String localName = Name.getLocalName(qname);
//		String uri;
//		if (prefix.equals("") && useDefault) {
//			uri = "";
//		} else {
//			uri = getURIForPrefix(prefix);
//		}
//		return namePool.getFingerprint(uri, localName);
//        
//	}
//
//
//	/**
//     * Make a NameTest, using this element as the context for namespace resolution
//     */
//    
//	public NameTest makeNameTest(short nodeType, String qname, boolean useDefault)
//    throws XPathException {
//		return new NameTest(nodeType, makeNameCode(qname, useDefault));
//	}
//    
//	/**
//     * Make a NamespaceTest, using this element as the context for namespace resolution
//     */
//    
//	public NamespaceTest makeNamespaceTest(short nodeType, String prefix)
//    throws XPathException {
//		return new NamespaceTest(namePool, nodeType, getURICodeForPrefix(prefix));
//	}
//    
//    /**
//     * Search the NamespaceList for a given prefix, returning the corresponding URI code.
//     * @param prefix The prefix to be matched. To find the default namespace, supply ""
//     * @return The URI code corresponding to this namespace. If it is an unnamed default namespace,
//     * return "".
//     * @throws XPathException if the prefix has not been declared on this element or a containing
//     * element.
//     */
//    
//    private short getURICodeForPrefix(String prefix) throws XPathException {
//		String uri = getURIForPrefix(prefix);
//		return namePool.getCodeForURI(uri);
//    }
//    
//    /**
//     * Bind a variable used in this element to the XSLVariable element in which it is declared
//     */
//    
//    public Binding bindVariable(int fingerprint) throws XPathException {
//        throw new XPathException("Variables are not allowed in a standalone expression");
//    }

    /**
     * Determine whether a given URI identifies an extension element namespace
     */
    
- (BOOL)isExtensionNamespace:(short)uriCode error:(NSError **)err {
    return NO;
}
    
    /**
     * Determine whether forwards-compatible mode is enabled
     */
    
- (BOOL)forwardsCompatibleModeIsEnabled:(NSError **)err {
    return false;
}
    
	/*
     * Get a Function declared using a saxon:function element in the stylesheet
     * @param fingerprint the fingerprint of the name of the function
     * @return the Function object represented by this saxon:function; or null if not found
     */
    
- (BOOL)getStyleSheetFunction:(NSInteger)fingerprint error:(NSError **)err {
    return nil;
}
    
    /**
     * Get an external Java class corresponding to a given namespace prefix, if there is
     * one.
     * @param uri The namespace URI corresponding to the prefix used in the function call.
     * @return the Java class name if a suitable class exists, otherwise return null. This
     * implementation always returns null.
     */
    
- (Class)externalCocoaClass:(NSString *)uri error:(NSError **)err {
    return nil;
}
    
    /**
     * Determine if an extension element is available
     */
    
- (BOOL)isElementAvailable:(NSString *)qname error:(NSError **)err {
    return NO;
}
    
    /**
     * Determine if a function is available
     */
    
- (BOOL)isFunctionAvailable:(NSString *)qname error:(NSError **)err {
    
    NSString *prefix = XPNameGetPrefix(qname);
    if (![prefix length]) {
        return nil != [XPExpression makeSystemFunction:qname];
    }
    
    return NO;   // no user functions allowed in standalone context.
}
    
	/**
     * Determine whether the key() function is permmitted in this context
     */
    
- (BOOL)allowsKeyFunction {
    return NO;
}
    
    /**
     * Get the effective XSLT version in this region of the stylesheet
     */

- (NSString *)version {
        return @"1.1";
}

@end
