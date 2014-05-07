//
//  XPUtils.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPUtils.h"

const NSString *XPNodeTypeName[] = {
    @"node",
    @"element",
    @"attribute",
    @"text",
    @"processing-instruction",
    @"comment",
    @"root",
    @"namespace",
    @"number-of-types",
    @"none",
};


static BOOL XPCharIsNCNameStart(unichar ch) {
    static NSMutableCharacterSet *set = nil;
    if (!set) {
        set = [[NSMutableCharacterSet characterSetWithCharactersInString:@"_"] retain]; // ?
        [set formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    }
    return [set characterIsMember:ch];
}


static BOOL XPCharIsNCName(unichar ch) {
    static NSMutableCharacterSet *set = nil;
    if (!set) {
        set = [[NSMutableCharacterSet characterSetWithCharactersInString:@"_-"] retain];
        [set formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
    }
    return [set characterIsMember:ch];
}


    /**
     * Validate whether a given string constitutes a valid NCName, as defined in XML Namespaces
     */
    
BOOL XPNameIsNCName(NSString *name) {
    NSUInteger len = [name length];
    if (0 == len) return NO;

    unichar ch = [name characterAtIndex:0];
    if (!XPCharIsNCNameStart(ch)) return NO;
    
    for (NSUInteger i = 1; i < len; i++ ) {
        ch = [name characterAtIndex:i];
            if (!XPCharIsNCName(ch)) {
            return NO;
        }
    }
    return YES;
}
    
    /**
     * Validate whether a given string constitutes a valid QName, as defined in XML Namespaces
     */

BOOL XPNameIsQName(NSString *name) {
    NSUInteger colon = [name rangeOfString:@":"].location;
    if (NSNotFound == colon) return XPNameIsNCName(name);
    if (colon==0 || colon==[name length]-1) return NO;
    if (!XPNameIsNCName([name substringToIndex:colon])) return NO;
    if (!XPNameIsNCName([name substringFromIndex:(colon+1)])) return NO;
    return YES;
}
    
	/**
     * Extract the prefix from a QName. Note, the QName is assumed to be valid.
     */
    
BOOL XPNameGetPrefix(NSString *qname) {
    NSUInteger colon = [qname rangeOfString:@":"].location;
    if (NSNotFound == colon) {
        return @"";
    }
    return [qname substringToIndex:colon];
}
    
	/**
     * Extract the local name from a QName. The QName is assumed to be valid.
     */
    
BOOL XPNameGetLocalName(NSString *qname) {
    NSUInteger colon = [qname rangeOfString:@":"].location;
    if (NSNotFound == colon) {
        return @"";
    }
    return [qname substringFromIndex:(colon+1)];
}
