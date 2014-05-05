//
//  XPSingletonNodeSet.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPNodeSetValue.h>

@protocol XPNodeInfo;

@interface XPSingletonNodeSet : XPNodeSetValue

- (instancetype)initWithNode:(id <XPNodeInfo>)node;
@end
