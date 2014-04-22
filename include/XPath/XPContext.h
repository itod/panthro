//
//  XPContext.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPController;
@protocol XPStaticContext;

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

@interface XPContext : NSObject

- (id)contextNodeInfo;
- (NSInteger)last;
- (NSInteger)contextPosition;

- (XPController *)controller;

@property (nonatomic, retain) id <XPStaticContext>staticContext;
@end
