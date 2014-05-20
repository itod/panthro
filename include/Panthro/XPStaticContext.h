//
//  XPStaticContext.h
//  Panthro
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPNameTest;
@class XPNamespaceTest;
@class XPValue;
@class XPSync;

@protocol XPStaticContext <NSObject>

- (NSString *)systemId;
- (NSUInteger)lineNumber;
- (NSString *)baseURI;

- (NSString *)namespaceURIForPrefix:(NSString *)prefix error:(NSError **)err;

- (BOOL)isElementAvailable:(NSString *)qname error:(NSError **)err;
- (BOOL)isFunctionAvailable:(NSString *)qname error:(NSError **)err;

- (NSString *)version;

- (void)setValue:(XPValue *)val forVariable:(NSString *)name;
- (XPValue *)valueForVariable:(NSString *)name;

@property (retain, readonly) XPSync *debugSync;
@property (assign) BOOL debug;
@property (copy) NSDictionary *debugInfo;

- (BOOL)pauseWithDebugInfo:(NSDictionary *)info;
//- (void)resume;
@end
