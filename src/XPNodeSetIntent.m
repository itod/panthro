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
        self.comparer = comparer ? comparer : [XPLocalOrderComparer instance];
        self.sorted = NO;

        if ([_nodeSetExpression dependencies]) {
            NSAssert2(0, @"Cannot create intentional node-set with context dependencies: %@:%lu", [expr class], [expr dependencies]);
        }
        
        [self fix]; // TODO We are totally working around Intents here, and always falling back to Extents
    }
    return self;
}


- (void)dealloc {
    self.nodeSetExpression = nil;
    self.comparer = nil;
    [super dealloc];
}


- (XPContext *)makeContext {
    XPContext *ctx = [[[XPContext alloc] initWithStaticContext:[_nodeSetExpression staticContext]] autorelease];
    return ctx;
}


- (void)setSorted:(BOOL)isSorted {
    _sorted = isSorted;
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
            id <XPNodeInfo>node = [enm nextObject];
            if (!first || [_comparer compare:node to:first] < 0) {
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
