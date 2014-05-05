//
//  XPNodeSetValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPValue.h>

@class XPNodeEnumeration;

@interface XPNodeSetValue : XPValue

- (XPNodeEnumeration *)enumerate;

- (XPNodeEnumeration *)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

- (NSUInteger)count;
- (XPNodeSetValue *)sort;
- (id)firstNode;

@property (nonatomic, getter=isSorted) BOOL sorted;
@end
