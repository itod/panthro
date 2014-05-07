//
//  XPContext.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPContext.h>
#import <XPath/XPStaticContext.h>

@interface XPContext ()
@property (nonatomic, retain) id <XPStaticContext>staticContext;
@end

@implementation XPContext

- (instancetype)init {
    self = [self initWithStaticContext:nil];
    return self;
}


/**
 * Constructor should only be called by the Controller, which acts as a Context factory.
 */
- (instancetype)initWithStaticContext:(id<XPStaticContext>)staticContext {
    self = [super init];
    if (self) {
        self.staticContext = staticContext;
    }
    return self;
}


- (void)dealloc {
    self.staticContext = nil;
    self.contextNode = nil;
    self.currentNode = nil;
    [super dealloc];
}


/**
 * Construct a new context as a copy of another
 */

- (id)copyWithZone:(NSZone *)zone {
    XPContext *c = [[XPContext alloc] initWithStaticContext:_staticContext];
    c.currentNode = _currentNode;
    c.contextNode = _contextNode;
    c.position = _position;
    c.last = _last;
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
