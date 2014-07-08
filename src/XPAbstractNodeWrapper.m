//
//  XPAbstractNodeWrapper.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/4/14.
//
//

#import "XPAbstractNodeWrapper.h"

@implementation XPAbstractNodeWrapper

#pragma mark -
#pragma mark XPSequence

- (id <XPItem>)head {
    return self;
}


- (id <XPSequenceEnumeration>)enumerate {
    XPAssert(0);
    return nil;
    //return SingletonIterator.makeIterator((NodeInfo)this);
}


#pragma mark -
#pragma mark XPItem

- (NSString *)stringValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (BOOL)isAtomized {
    return NO;
}


- (BOOL)isAtomic {
    return NO;
}


#pragma mark -
#pragma mark XPNodeInfo

- (BOOL)isSameNodeInfo:(id <XPNodeInfo>)other {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (NSInteger)compareOrderTo:(id <XPNodeInfo>)other {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NSOrderedSame;
}


- (XPNodeType)nodeType {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return XPNodeTypeNone;
}


- (NSString *)name {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSString *)localName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSString *)prefix {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSString *)namespaceURI {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSString *)attributeValueForURI:(NSString *)nsURI localName:(NSString *)localName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSString *)namespaceURIForPrefix:(NSString *)prefix {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSRange)range {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NSMakeRange(NSNotFound, 0);
}


- (NSInteger)lineNumber {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return -1;
}


- (id <XPNodeInfo>)parent {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id <XPDocumentInfo>)documentRoot {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id <XPAxisEnumeration>)enumerationForAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}

@end
