//
//  XPSingletonNodeSet.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Panthro/XPNodeSetValue.h>

@protocol XPNodeInfo;

@interface XPSingletonNodeSet : XPNodeSetValue

+ (instancetype)singletonNodeSetWithNode:(id <XPNodeInfo>)node;
- (instancetype)initWithNode:(id <XPNodeInfo>)node;

/**
 * Allow general use as a node-set. This is required to lift the 1.0
 * restrictions on use of result tree fragments
 */
@property (nonatomic, assign, getter=isGeneralUseAllowed) BOOL generalUseAllowed;
@end
