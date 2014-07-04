//
//  XPContext.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPContext.h"
#import "XPStaticContext.h"
#import "XPNodeInfo.h"

@interface XPContext ()
@property (nonatomic, assign) id <XPStaticContext>staticContext;
@end

@implementation XPContext {
    NSUInteger _last;
    id <XPItem>_stepContextNode;
}

- (instancetype)init {
    self = [self initWithStaticContext:nil];
    return self;
}


/**
 * Constructor should only be called by the Controller, which acts as a Context factory.
 */
- (instancetype)initWithStaticContext:(id<XPStaticContext>)env {
    NSParameterAssert(env);
    self = [super init];
    if (self) {
        self.staticContext = env;
        self.lastPositionFinder = self;
    }
    return self;
}


- (void)dealloc {
    self.staticContext = nil;
    self.contextNode = nil;
    self.currentNode = nil;
    self.lastPositionFinder = nil;
    [super dealloc];
}


/**
 * Construct a new context as a copy of another
 */

- (id)copyWithZone:(NSZone *)zone {
    XPContext *c = [[XPContext alloc] initWithStaticContext:_staticContext];
    c.contextNode = _contextNode;
    c.position = _position;
    c.last = _last;
    c.currentNode = _currentNode;
    c.lastPositionFinder = _lastPositionFinder;
//    c.currentTemplate = _currentTemplate;
//    //c.bindery = bindery;
//    c.groupActivationStack = _groupActivationStack;
//    c.lastRememberedNode = _lastRememberedNode;
//    c.lastRememberedNumber = _lastRememberedNumber;
//    c.returnValue = nil;
    return c;
}


- (void)setLast:(NSUInteger)last {
    _last = last;
    self.lastPositionFinder = self;
}


- (NSUInteger)last {
    XPAssert(_lastPositionFinder);
    return [_lastPositionFinder lastPosition];
}


- (NSUInteger)contextPosition {
    return _position;
}


- (NSUInteger)contextSize {
    @try {
        return self.last;
    } @catch (NSException *err) {
        // The XSLTContext interfaces doesn't allow us to throw any exceptions.
        // We'll pick it up on return from the extension function.
        //setException(err);
        return [self contextPosition];    // for want of anything better
    }
}


#pragma mark -
#pragma mark XPLastPositionFinder

- (NSUInteger)lastPosition {
    return _last;
}

@end
