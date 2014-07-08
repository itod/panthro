//
//  XPEmptyNodeSet.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPEmptyNodeSet.h"
#import "XPEmptyEnumeration.h"

@implementation XPEmptyNodeSet

+ (instancetype)instance {
    static XPEmptyNodeSet *sInstance = nil;
    if (!sInstance) {
        sInstance = [[XPEmptyNodeSet alloc] init];
    }
    return sInstance;
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return self;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    return self;
}


- (BOOL)isSorted {
    return YES;
}


- (void)setSorted:(BOOL)yn {}


- (NSString *)asString {
    return @"";
}


- (double)asNumber {
    return 0.0;
}


- (BOOL)asBoolean {
    return NO;
}


- (NSUInteger)count {
    return 0;
}


- (XPSequenceValue *)sort {
    return nil;
}


- (id <XPNodeInfo>)firstNode {
    return nil;
}


- (BOOL)isEqualToValue:(XPValue *)other {
    if ([other isBooleanValue]) {
        return ![other asBoolean];
    } else {
        return NO;
    }
}


- (BOOL)isNotEqualToValue:(XPValue *)other {
    if ([other isBooleanValue]) {
        return [other asBoolean];
    } else {
        return NO;
    }
}


/**
 * Determine, in the case of an expression whose data type is Value.NODESET,
 * whether all the nodes in the node-set are guaranteed to come from the same
 * document as the context node. Used for optimization.
 */

- (BOOL)isContextDocumentNodeSet {
    return YES;
}


/**
 * Return an enumeration of this nodeset value.
 */

- (id <XPSequenceEnumeration>)enumerate {
    return [XPEmptyEnumeration instance];
}

@end
