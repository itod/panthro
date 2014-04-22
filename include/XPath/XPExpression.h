//
//  XPExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPStaticContext;
@class XPContext;
@class XPValue;
@class XPNodeSetValue;
@class XPNodeEnumerator;

typedef enum {
    XPDataTypeBoolean,
    XPDataTypeNumber,
    XPDataTypeString,
    XPDataTypeNodeSet,
//    XPDataTypeFragment,
    XPDataTypeObject,
    XPDataTypeAny
} XPDataType;

@interface XPExpression : NSObject

+ (XPExpression *)expressionFromString:(NSString *)exprStr inContext:(id <XPStaticContext>)env error:(NSError **)outErr;

- (XPValue *)evaluateInContext:(XPContext *)ctx;
- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx;
- (double)evaluateAsNumberInContext:(XPContext *)ctx;
- (NSString *)evaluateAsStringInContext:(XPContext *)ctx;
- (XPNodeSetValue *)evaluateAsNodeSetInContext:(XPContext *)ctx;

- (XPNodeEnumerator *)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

- (BOOL)isValue;
- (BOOL)isContextDocumentNodeSet;
- (BOOL)usesCurrent;
- (BOOL)containsReferences;

- (XPExpression *)simplify;
- (NSUInteger)dependencies;
- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx;

- (NSInteger)dataType;

- (void)display:(NSInteger)level;

@property (nonatomic, readonly, retain) id <XPStaticContext>staticContext;
@end
