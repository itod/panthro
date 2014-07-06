//
//  XPSequenceExtent.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPSequenceValue.h"

@interface XPSequenceExtent : XPSequenceValue

- (instancetype)initWithContent:(NSArray *)v;

- (XPValue *)itemAt:(NSUInteger)i;
- (NSUInteger)count;
@end
