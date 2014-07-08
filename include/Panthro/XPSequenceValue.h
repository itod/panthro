//
//  XPSequenceValue.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValue.h"

@protocol XPNodeOrderComparer;
@protocol XPSequenceEnumeration;
@protocol XPNodeInfo;

@interface XPSequenceValue : XPValue

- (id <XPSequenceEnumeration>)enumerate;
- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

- (NSUInteger)count;
- (XPSequenceValue *)sort;
- (XPValue *)firstValue;

@property (nonatomic, assign, getter=isSorted) BOOL sorted;
@property (nonatomic, assign, getter=isReverseSorted) BOOL reverseSorted;
@end
