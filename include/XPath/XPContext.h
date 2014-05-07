//
//  XPContext.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XPath/XPLastPositionFinder.h>

@class XPController;
@protocol XPStaticContext;
@protocol XPLastPositionFinder;
@protocol XPNodeInfo;

typedef enum {
    XPDependenciesVariables = 1,
    XPDependenciesCurrentNode = 4,
    XPDependenciesContextNode = 8,
    XPDependenciesContextPosition = 16,
    XPDependenciesLast = 32,
    XPDependenciesController = 64,
    XPDependenciesContextDocument = 128,
    //  containing the context node
    XPDependenciesNone = 0,
    XPDependenciesAll = 255,
    XPDependenciesXSLTContext = 64 | 1 | 4
} XPDependencies;

@interface XPContext : NSObject <XPLastPositionFinder>

- (instancetype)initWithController:(XPController *)c;

- (XPContext *)newContext; // +1

@property (nonatomic, retain) XPController *controller;
@property (nonatomic, retain) id <XPLastPositionFinder>lastPositionFinder; // ????????????????? assign
@property (nonatomic, retain) id <XPStaticContext>staticContext;

// focus
@property (nonatomic, retain) id <XPNodeInfo>contextNode;
@property (nonatomic, assign) NSUInteger last;
@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, retain) id <XPNodeInfo>currentNode;
@end
