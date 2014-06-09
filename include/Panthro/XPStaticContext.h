//
//  XPStaticContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPExpression;
@class XPValue;
@class XPFunction;
@class XPNameTest;
@class XPNamespaceTest;

@protocol XPNodeInfo;

#define XPNamespaceXML @"http://www.w3.org/XML/1998/namespace"
#define XPNamespaceXSLT @"http://www.w3.org/1999/XSL/Transform"

@protocol XPStaticContext <NSObject>

- (NSString *)systemId;
- (NSUInteger)lineNumber;
- (NSString *)baseURI;

- (NSString *)namespaceURIForPrefix:(NSString *)prefix error:(NSError **)outErr;
- (void)declareNamespaceURI:(NSString *)uri forPrefix:(NSString *)prefix;

- (XPFunction *)makeSystemFunction:(NSString *)name error:(NSError **)outErr;

- (BOOL)isElementAvailable:(NSString *)qname;
- (BOOL)isFunctionAvailable:(NSString *)qname;

- (NSString *)version;

- (void)setValue:(XPValue *)val forVariable:(NSString *)name;
- (XPValue *)valueForVariable:(NSString *)name;

#if PAUSE_ENABLED
// Debugging
- (void)pauseFrom:(XPExpression *)expr withContextNode:(id <XPNodeInfo>)ctxNode result:(XPValue *)result range:(NSRange)range done:(BOOL)isDone;
@property (assign) BOOL debug;
#endif
@end
