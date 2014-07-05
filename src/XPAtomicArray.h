//
//  XPAtomicArray.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import <Panthro/XPExpression.h>
#import <Panthro/XPAtomicSequence.h>

@interface XPAtomicArray : XPExpression <XPAtomicSequence>
- (instancetype)initWithContent:(NSArray *)v;
@end
