//
//  XPSequenceValue.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValue.h"

@interface XPSequenceValue : XPValue

- (NSUInteger)count;

- (XPSequenceValue *)sort;
@property (nonatomic, assign, getter=isSorted) BOOL sorted;
@property (nonatomic, assign, getter=isReverseSorted) BOOL reverseSorted;
@end
