//
//  XPNodeSetIntent.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetValue.h"

@class XPNodeSetExpression;
@class XPController;
@class XPNodeSetExtent;

@interface XPNodeSetIntent : XPNodeSetValue

+ (XPNodeSetIntent *)intentWithNodeSetExpression:(XPNodeSetExpression *)expr controller:(XPController *)c;

- (instancetype)initWithNodeSetExpression:(XPNodeSetExpression *)expr controller:(XPController *)c;

- (BOOL)isContextDocumentNodeSet;

@property (nonatomic, retain) XPNodeSetExpression *nodeSetExpression;
@property (nonatomic, getter=isSorted) BOOL sorted;
@end
