//
//  XPExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Panthro/XPUtils.h>

@protocol XPStaticContext;
@protocol XPSequenceEnumeration;

@class XPContext;
@class XPValue;
@class XPNodeSetValue;
@class XPFunction;

extern NSString * const XPathErrorDomain;

extern const NSUInteger XPathErrorCodeCompiletime;
extern const NSUInteger XPathErrorCodeRuntime;

typedef NS_ENUM(NSUInteger, XPDataType) {
    XPDataTypeBoolean,
    XPDataTypeNumber,
    XPDataTypeString,
    XPDataTypeNodeSet,
    XPDataTypeObject,
    XPDataTypeAny
};

typedef NS_ENUM(NSUInteger, XPDependencies) {
    XPDependenciesInvalid = NSNotFound,
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
};

@interface XPExpression : NSObject

+ (XPExpression *)expressionFromString:(NSString *)exprStr inContext:(id <XPStaticContext>)env error:(NSError **)outErr;
+ (XPExpression *)expressionFromString:(NSString *)exprStr inContext:(id <XPStaticContext>)env simplify:(BOOL)simplify error:(NSError **)outErr;

- (XPValue *)evaluateInContext:(XPContext *)ctx;
- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx;
- (double)evaluateAsNumberInContext:(XPContext *)ctx;
- (NSString *)evaluateAsStringInContext:(XPContext *)ctx;
- (XPNodeSetValue *)evaluateAsNodeSetInContext:(XPContext *)ctx;

- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

- (BOOL)isValue;
- (BOOL)isContextDocumentNodeSet;
- (BOOL)usesCurrent;
- (BOOL)containsReferences;

- (XPExpression *)simplify;
- (XPDependencies)dependencies;
- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx;

- (XPDataType)dataType;

@property (nonatomic, assign) NSRange range;
@property (nonatomic, retain) id <XPStaticContext>staticContext;
@end
