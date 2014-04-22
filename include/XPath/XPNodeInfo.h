//
//  XPNodeInfo.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPNodeInfo <NSObject>

- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other;

@end
