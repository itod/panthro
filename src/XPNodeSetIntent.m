//
//  XPNodeSetIntent.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetIntent.h"
#import "XPNodeEnumeration.h"
#import "XPNodeSetExtent.h"
#import "XPNodeSetExpression.h"
#import "XPLocalOrderComparer.h"
#import "XPContext.h"
#import "XPNodeInfo.h"
#import "XPLastPositionFinder.h"

@interface XPContext ()
@property (nonatomic, assign) id <XPStaticContext>staticContext;
@end

@interface XPNodeSetIntent ()
- (void)fix;

@property (nonatomic, retain) id <XPNodeOrderComparer>comparer;
@property (nonatomic, retain) XPNodeSetExtent *extent;
@property (nonatomic, assign) NSUInteger useCount;
@end

@implementation XPNodeSetIntent

- (instancetype)initWithNodeSetExpression:(XPNodeSetExpression *)expr comparer:(id <XPNodeOrderComparer>)comparer {
    if (self = [super init]) {
        self.nodeSetExpression = expr;
        self.comparer = comparer;

        if ([_nodeSetExpression dependencies]) {
            NSAssert2(0, @"Cannot create intentional node-set with context dependencies: %@:%lu", [expr class], [expr dependencies]);
        }
    }
    return self;
}


- (void)dealloc {
    self.nodeSetExpression = nil;
    self.comparer = nil;
    [super dealloc];
}


- (XPContext *)makeContext {
    XPContext *ctx = [[[XPContext alloc] init] autorelease];
    [ctx setStaticContext:[_nodeSetExpression staticContext]];
    return ctx;
}


- (BOOL)isSorted {
    return _sorted || [[_nodeSetExpression enumerateInContext:[self makeContext] sorted:NO] isSorted];
}


- (BOOL)isContextDocumentNodeSet {
    return [_nodeSetExpression isContextDocumentNodeSet];
}


- (NSString *)asString {
    id <XPNodeInfo>first = [self firstNode];
    return first ? [first stringValue] : @"";
}


- (BOOL)asBoolean {
    return [[self enumerate] hasMoreObjects];
}


- (NSUInteger)count {
    if (!_extent) {
        id <XPNodeEnumeration>enm = [_nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
        if ([enm conformsToProtocol:@protocol(XPLastPositionFinder)] && enm.isSorted) {
            return [(id <XPLastPositionFinder>)enm lastPosition];
        }
        self.extent = [[[XPNodeSetExtent alloc] initWithEnumeration:enm comparer:_comparer] autorelease];
    }
    return [_extent count];
}


- (void)fix {
    if (!_extent) {
        id <XPNodeEnumeration>enm = [_nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
        self.extent = [[[XPNodeSetExtent alloc] initWithEnumeration:enm comparer:_comparer] autorelease];
    }
}


- (XPNodeSetValue *)sort {
    if (_sorted) return self;
    [self fix];
    return [_extent sort];
}


- (id <XPNodeInfo>)firstNode {
    if (_extent) return [_extent firstNode];
    
    id <XPNodeEnumeration>enm = [_nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
    if (_sorted || [enm isSorted]) {
        self.sorted = YES;
        if ([enm hasMoreObjects]) {
            return [enm nextObject];
        } else {
            return nil;
        }
    } else {
        id <XPNodeInfo>first = nil;
        while ([enm hasMoreObjects]) {
            id <XPNodeInfo>node = nil;
            if (!first || NSOrderedDescending == [_comparer compare:node to:first]) {
                first = node;
            }
        }
        return first;
    }
}


- (id <XPNodeInfo>)selectFirstInContext:(XPContext *)ctx {
    return [self firstNode];
}


- (id <XPNodeEnumeration>)enumerate {
    if (_extent) {
        return [_extent enumerate];
    } else {
        self.useCount++;
        // arbitrarily, we decide that the third time the expression is used,
        // we will allocate it some memory for faster access on future occasions.
        if (_useCount < 3) {
            return [_nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
        } else {
            [self fix];
            return [_extent enumerate];
        }
    }
}

@synthesize sorted = _sorted;
@end
