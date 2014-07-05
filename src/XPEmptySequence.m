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
        sInstance = [[[XPEmptySequence alloc] init] autorelease];
    }
    return sInstance;
}


- (NSString *)description {
    return @"()";
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


- (XPSequenceValue *)sort {
    return self;
}


#pragma mark -
#pragma mark XPSequence

- (id <XPItem>)head {
    return nil;
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
