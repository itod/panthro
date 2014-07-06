//
//  XPNodeSetExtent.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPSequenceValue.h"
#import "XPSortable.h"

@protocol XPSequenceEnumeration;
@protocol XPNodeOrderComparer;

@interface XPNodeSetExtent : XPSequenceValue <XPSortable>

- (instancetype)initWithNodes:(NSArray *)nodes comparer:(id <XPNodeOrderComparer>)comparer;
- (instancetype)initWithEnumeration:(id <XPSequenceEnumeration>)enm comparer:(id <XPNodeOrderComparer>)comparer;

@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@end
