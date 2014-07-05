//
//  XPAtomicArray.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPAtomicArray.h"
#import "XPAtomicSequenceEnumeration.h"

@interface XPAtomicArray ()
@property (nonatomic, retain) NSArray *content;
@end

@implementation XPAtomicArray

- (instancetype)initWithContent:(NSArray *)v {
    XPAssert(v);
    self = [super init];
    if (self) {
        self.content = v;
    }
    return self;
}


- (void)dealloc {
    self.content = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark XPExpression

//- (XPExpression *)simplify {
//    XPExpression *result = self;
//    
//    if (0 == [self count]) {
//        result = [XPEmptyAtomicSequence instance];
//        
//    }
//    
//    return result;
//}


#pragma mark -
#pragma mark XPAtomicSequence

- (XPValue *)head {
    return [self itemAt:0];
}


- (id <XPSequenceEnumeration>)enumerate {
    id <XPSequenceEnumeration>enm = [[[XPAtomicSequenceEnumeration alloc] initWithAtomicSequence:self] autorelease];
    return enm;
}


- (XPValue *)itemAt:(NSUInteger)i {
    XPAssert(_content);
    return [_content objectAtIndex:i];
}


- (NSUInteger)count {
    XPAssert(_content);
    return [_content count];
}

@end
