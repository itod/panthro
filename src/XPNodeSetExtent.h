//
//  XPNodeSetExtent.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetValue.h"
#import "XPSortable.h"

@protocol XPNodeEnumeration;
@protocol XPNodeOrderComparer;

@interface XPNodeSetExtent : XPNodeSetValue <XPSortable>

- (instancetype)initWithNodes:(NSArray *)nodes comparer:(id <XPNodeOrderComparer>)comparer;
- (instancetype)initWithEnumeration:(id <XPNodeEnumeration>)enm comparer:(id <XPNodeOrderComparer>)comparer;

@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@property (nonatomic, assign, getter=isSorted) BOOL sorted;
@property (nonatomic, assign, getter=isReverseSorted) BOOL reverseSorted;
@end
