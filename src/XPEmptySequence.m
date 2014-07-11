//
//  XPEmptySequence.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPEmptySequence.h"
#import "XPEmptyEnumeration.h"

@implementation XPEmptySequence

+ (instancetype)instance {
    static XPEmptySequence *sInstance = nil;
    if (!sInstance) {
        sInstance = [[XPEmptySequence alloc] init];
    }
    return sInstance;
}


#if !NDEBUG
- (instancetype)init {
    self = [super init];
    if (self) {
        static NSUInteger sInstanceCount = 0;
        XPAssert(sInstanceCount == 0);
        sInstanceCount++;
    }
    return self;
}
#endif


- (NSString *)description {
    return @"()";
}


- (BOOL)isAtomized {
    return YES;
}


#pragma mark -
#pragma mark XPExpression

- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)yn {
    return [self enumerate];
}


- (BOOL)isSorted {
    return NO;
}


- (BOOL)isReverseSorted {
    return NO;
}


- (void)setSorted:(BOOL)sorted {}
- (void)setReverseSorted:(BOOL)reverseSorted {}


- (NSString *)asString {
    return @"";
}


- (BOOL)asBoolean {
    return NO;
}


- (BOOL)isEqualToValue:(XPValue *)other {
    return NO;
}


- (BOOL)isNotEqualToValue:(XPValue *)other {
    return NO;
}


- (NSComparisonResult)compareToValue:(XPValue *)other {
    return NSOrderedAscending;
}


#pragma mark -
#pragma mark XPSequence

- (id <XPItem>)head {
    return self;
}


- (id <XPSequenceEnumeration>)enumerate {
    return [XPEmptyEnumeration instance];
}


#pragma mark -
#pragma mark XPSequenceExtent

- (XPValue *)itemAt:(NSUInteger)i {
    return nil;
}


- (NSUInteger)count {
    return 0;
}

@end
