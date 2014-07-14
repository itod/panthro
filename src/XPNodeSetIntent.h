//
//  XPNodeSetIntent.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Panthro/XPNodeSetValue.h>

@protocol XPNodeOrderComparer;
@class XPNodeSetExpression;

@interface XPNodeSetIntent : XPNodeSetValue

- (instancetype)initWithNodeSetExpression:(XPNodeSetExpression *)expr comparer:(id <XPNodeOrderComparer>)comparer;

@property (nonatomic, retain) XPNodeSetExpression *nodeSetExpression;
@end
