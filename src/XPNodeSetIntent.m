//
//  XPNodeSetIntent.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPNodeSetIntent.h>
#import <Exedore/XPNodeSetExtent.h>
#import <Exedore/XPNodeSetExpression.h>
#import <Exedore/XPController.h>
#import <Exedore/XPContext.h>
#import <Exedore/XPLastPositionFinder.h>

@interface XPNodeSetIntent ()
- (void)fix;

@property (nonatomic, retain) XPController *controller;
@property (nonatomic, retain) XPNodeSetExtent *extent;
@end

@implementation XPNodeSetIntent

+ (id)intentWithNodeSetExpression:(XPNodeSetExpression *)expr controller:(XPController *)c {
    return [[[self alloc] initWithNodeSetExpression:expr controller:c] autorelease];
}


- (id)initWithNodeSetExpression:(XPNodeSetExpression *)expr controller:(XPController *)c {
    if (self = [super init]) {
        self.nodeSetExpression = expr;
        self.controller = c;

        if ([nodeSetExpression dependencies]) {
            [nodeSetExpression display:10];
            NSAssert2(0, @"Cannot create intentional node-set with context dependencies: %@:%@", [expr class], [expr dependencies]);
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
    [ctx setStaticContext:[nodeSetExpression staticContext]];
    return ctx;
}


- (BOOL)isSorted {
    return sorted || [[nodeSetExpression enumerateInContext:[self makeContext] sorted:NO] isSorted];
}


- (BOOL)isContextDocumentNodeSet {
    return [nodeSetExpression isContextDocumentNodeSet];
}


- (NSString *)asString {
    id first = [self firstNode];
    return first ? [first stringValue] : @"";
}


- (BOOL)asBoolean {
    return nil != [[self enumerate] nextObject];
}


- (NSUInteger)count {
    if (!extent) {
        XPNodeEnumerator *e = [nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
        if ([e conformsToProtocol:@protocol(XPLastPositionFinder)] && [e isSorted]) {
            return [(id <XPLastPositionFinder>)e lastPosition];
        }
        self.extent = [XPNodeSetExtent extentWithNodeEnumerator:e controller:controller];
    }
    return [extent count];
}


- (void)fix {
    if (!extent) {
        XPNodeEnumerator *e = [nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
        self.extent = [XPNodeSetExtent extentWithNodeEnumerator:e controller:controller];
    }
}


- (XPNodeSetValue *)sort {
    if (sorted) return self;
    [self fix];
    return [extent sort];
}


- (id)firstNode {
    if (extent) return [extent firstNode];
    
    XPNodeEnumerator *e = [nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
    if (sorted || [e isSorted]) {
        sorted = YES;
        return [e nextObject];
    } else {
        id first = nil;
        id node = nil;
        while (nil != (node = [e nextObject])) {
            if (!first || NSOrderedDescending == [controller compare:node to:first]) {
                first = node;
            }
        }
        return first;
    }
}


- (id)selectFirstInContext:(XPContext *)ctx {
    return [self firstNode];
}


- (XPNodeEnumerator *)enumerate {
    if (extent) {
        return [extent enumerate];
    } else {
        useCount++;
        // arbitrarily, we decide that the third time the expression is used,
        // we will allocate it some memory for faster access on future occasions.
        if (useCount < 3) {
            return [nodeSetExpression enumerateInContext:[self makeContext] sorted:NO];
        } else {
            [self fix];
            return [extent enumerate];
        }
    }
}

@synthesize nodeSetExpression;
@synthesize controller;
@synthesize extent;
@synthesize sorted;
@end
