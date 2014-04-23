//
//  XPAxis.m
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <XPath/XPAxis.h>

extern NSUInteger XPAxisGetAxisNumber(NSString *name) {
    if ([name isEqualToString:@"ancestor"])                return XPAxisAncestor;
    if ([name isEqualToString:@"ancestor-or-self"])        return XPAxisAncestorOrSelf;
    if ([name isEqualToString:@"attribute"])               return XPAxisAttribute;
    if ([name isEqualToString:@"child"])                   return XPAxisChild;
    if ([name isEqualToString:@"descendant"])              return XPAxisDescendant;
    if ([name isEqualToString:@"descendant-or-self"])      return XPAxisDescendantOrSelf;
    if ([name isEqualToString:@"following"])               return XPAxisFollowing;
    if ([name isEqualToString:@"following-sibling"])       return XPAxisFollowingSibling;
    if ([name isEqualToString:@"namespace"])               return XPAxisNamespace;
    if ([name isEqualToString:@"parent"])                  return XPAxisParent;
    if ([name isEqualToString:@"preceding"])               return XPAxisPreceding;
    if ([name isEqualToString:@"preceding-sibling"])       return XPAxisPrecedingSibling;
    if ([name isEqualToString:@"self"])                    return XPAxisSelf;
    // preceding-or-ancestor cannot be used in an XPath expression
    [NSException raise:@"XPathException" format:@"Unknown axis name: %@", name];
    return 0;
}

