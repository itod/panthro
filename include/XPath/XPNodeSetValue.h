//
//  XPNodeSetValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPValue.h>

@class XPNodeEnumerator;

@interface XPNodeSetValue : XPValue

- (XPNodeEnumerator *)enumerate;

- (XPNodeEnumerator *)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

- (NSString *)asString;
- (double)asNumber;
- (BOOL)asBoolean;
- (NSUInteger)count;
- (XPNodeSetValue *)sort;
- (id)firstNode;

@property (nonatomic, getter=isSorted) BOOL sorted;
@end
