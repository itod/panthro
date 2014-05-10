//
//  XPNodeSetIntent.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPNodeSetIntent.h>
#import <XPath/XPNodeEnumeration.h>
#import <XPath/XPNodeSetExtent.h>
#import <XPath/XPNodeSetExpression.h>
#import <XPath/XPController.h>
#import <XPath/XPContext.h>
#import <XPath/XPLastPositionFinder.h>

@interface XPNodeSetIntent ()
- (void)fix;

@property (nonatomic, retain) XPController *controller;
@property (nonatomic, retain) XPNodeSetExtent *extent;
@end

@implementation XPNodeSetIntent {
    NSInteger _useCount;
}

+ (XPNodeSetIntent *)intentWithNodeSetExpression:(XPNodeSetExpression *)expr controller:(XPController *)c {
    return [[[self alloc] initWithNodeSetExpression:expr controller:c] autorelease];
}


- (instancetype)initWithNodeSetExpression:(XPNodeSetExpression *)expr controller:(XPController *)c {
    if (self = [super init]) {
        self.nodeSetExpression = expr;
        self.controller = c;

        if ([_nodeSetExpression dependencies]) {
            [_nodeSetExpression display:10];
            NSAssert2(0, @"Cannot create intentional node-set with context dependencies: %@:%lu", [expr class], [expr dependencies]);
        }
    }
    return self;
}


- (void)dealloc {
    self.nodeSetExpression = nil;
    self.controller = nil;
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
    id first = [self firstNode];
    return first ? [first stringValue] : @"";
}


- (BOOL)asBoolean {
    return nil != [[self enumerate] nextObject];
}


- (NSUInteger)count {
    if (!_extent) {
        id <XPNodeEnumeration>e = [_nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
        if ([e conformsToProtocol:@protocol(XPLastPositionFinder)] && [e isSorted]) {
            return [(id <XPLastPositionFinder>)e lastPosition];
        }
        self.extent = [XPNodeSetExtent extentWithNodeEnumeration:e controller:_controller];
    }
    return [_extent count];
}


- (void)fix {
    if (!_extent) {
        id <XPNodeEnumeration>e = [_nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
        self.extent = [XPNodeSetExtent extentWithNodeEnumeration:e controller:_controller];
    }
}


- (XPNodeSetValue *)sort {
    if (_sorted) return self;
    [self fix];
    return [_extent sort];
}


- (id <XPNodeInfo>)firstNode {
    if (_extent) return [_extent firstNode];
    
    id <XPNodeEnumeration>e = [_nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
    if (_sorted || [e isSorted]) {
        self.sorted = YES;
        return [e nextObject];
    } else {
        id first = nil;
        id node = nil;
        while (nil != (node = [e nextObject])) {
            if (!first || NSOrderedDescending == [_controller compare:node to:first]) {
                first = node;
            }
        }
        return first;
    }
}


- (id)selectFirstInContext:(XPContext *)ctx {
    return [self firstNode];
}


- (id <XPNodeEnumeration>)enumerate {
    if (_extent) {
        return [_extent enumerate];
    } else {
        _useCount++;
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
