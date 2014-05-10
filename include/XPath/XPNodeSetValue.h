//
//  XPNodeSetValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPValue.h>
#import "XPSortable.h"

@protocol XPNodeOrderComparer;
@protocol XPNodeEnumeration;
@protocol XPNodeInfo;

@interface XPNodeSetValue : XPValue <XPSortable>

- (instancetype)initWithNodes:(NSArray *)nodes comparer:(id <XPNodeOrderComparer>)comparer;
- (instancetype)initWithEnumeration:(id <XPNodeEnumeration>)enm comparer:(id <XPNodeOrderComparer>)comparer;

- (id <XPNodeEnumeration>)enumerate;

- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

- (NSUInteger)count;
- (XPNodeSetValue *)sort;
- (id <XPNodeInfo>)firstNode;

@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@property (nonatomic, assign, readonly, getter=isSorted) BOOL sorted;
@property (nonatomic, assign, readonly, getter=isReverseSorted) BOOL reverseSorted;
@end
