//
//  XPNodeSetValue.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValue.h"

@protocol XPNodeOrderComparer;
@protocol XPNodeEnumeration;
@protocol XPNodeInfo;

@interface XPNodeSetValue : XPValue

- (id <XPNodeEnumeration>)enumerate;
- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

- (NSUInteger)count;
- (XPNodeSetValue *)sort;
- (id <XPNodeInfo>)firstNode;

@property (nonatomic, assign, getter=isSorted) BOOL sorted;
@property (nonatomic, assign, getter=isReverseSorted) BOOL reverseSorted;
@end
