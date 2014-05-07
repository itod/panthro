//
//  XPContext.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPContext.h>
#import <XPath/XPController.h>
#import <XPath/XPStaticContext.h>
#import "XPLastPositionFinder.h"

@implementation XPContext

/**
 * The default constructor is not used within Saxon itself, but is available to
 * applications (and is used in some samples). Because some expressions (for example
 * union expressions) cannot execute without a Controller, a system default Controller
 * is created. This is a quick fix, but is not entirely satisfactory, because it's
 * not thread-safe. Applications are encouraged to create a Controller explicitly and
 * use it only within a single thread.
 */
- (instancetype)init {
    self = [self initWithController:[[[XPController alloc] init] autorelease]];
    return self;
}


/**
 * Constructor should only be called by the Controller, which acts as a Context factory.
 */
- (instancetype)initWithController:(XPController *)c {
    self = [super init];
    if (self) {
        self.controller = c;
        _lastPositionFinder = self;
    }
    return self;
}


- (void)dealloc {
    self.controller = nil;
    if (_lastPositionFinder != self) {
        self.lastPositionFinder = nil;
    }
    self.staticContext = nil;
    self.contextNode = nil;
    self.currentNode = nil;
    [super dealloc];
}


- (NSUInteger)last {
    if (!_lastPositionFinder) return 1;
    return [_lastPositionFinder lastPosition];
}


- (NSUInteger)lastPosition {
    return [self last];
}


/**
 * Construct a new context as a copy of another
 */

- (XPContext *)newContext {
    XPContext *c = [[[XPContext alloc] initWithController:self.controller] autorelease];
    c.staticContext = _staticContext;
    c.currentNode = _currentNode;
    c.contextNode = _contextNode;
    c.position = _position;
    c.last = _last;
    c.lastPositionFinder = _lastPositionFinder;
//    c.currentMode = _currentMode;
//    c.currentTemplate = _currentTemplate;
//    //c.bindery = bindery;
//    c.groupActivationStack = _groupActivationStack;
//    c.lastRememberedNode = _lastRememberedNode;
//    c.lastRememberedNumber = _lastRememberedNumber;
//    c.returnValue = nil;
    return c;
}

@end
