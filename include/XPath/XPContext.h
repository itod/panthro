//
//  XPContext.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface XPContext : NSObject <NSCopying>

- (instancetype)initWithStaticContext:(id <XPStaticContext>)staticContext;

@property (nonatomic, retain, readonly) id <XPStaticContext>staticContext;

// focus
@property (nonatomic, retain) id <XPNodeInfo>contextNode;
@property (nonatomic, assign) NSUInteger last;
@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, retain) id <XPNodeInfo>currentNode;
@end
