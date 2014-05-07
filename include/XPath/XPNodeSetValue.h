//
//  XPNodeSetValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPValue.h>

@protocol XPNodeEnumeration;

@interface XPNodeSetValue : XPValue

- (instancetype)initWithNodes:(NSArray *)nodes;
- (instancetype)initWithEnumeration:(id <XPNodeEnumeration>)enm;

- (id <XPNodeEnumeration>)enumerate;

- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

- (NSUInteger)count;
- (XPNodeSetValue *)sort;
- (id)firstNode;

@property (nonatomic, getter=isSorted) BOOL sorted;
@end
