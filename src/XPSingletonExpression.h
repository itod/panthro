//
//  XPSingletonExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetExpression.h"
#import "XPNodeInfo.h"

@interface XPSingletonExpression : XPNodeSetExpression
- (id <XPNodeInfo>)nodeInContext:(XPContext *)ctx;
@end
