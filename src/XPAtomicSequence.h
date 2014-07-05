//
//  XPAtomicSequence.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import <Panthro/XPValue.h>
#import <Panthro/XPSequence.h>

@interface XPAtomicSequence : XPValue <XPSequence>

- (instancetype)initWithContent:(NSArray *)v;

- (XPValue *)itemAt:(NSUInteger)i;
- (NSUInteger)count;
@end
