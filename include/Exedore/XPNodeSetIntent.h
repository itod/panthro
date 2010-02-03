//
//  XPNodeSetIntent.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPNodeSetValue.h>

@class XPNodeSetExpression;
@class XPController;
@class XPNodeSetExtent;

@interface XPNodeSetIntent : XPNodeSetValue {
    XPNodeSetExpression *nodeSetExpression;
    XPController *controller;
    XPNodeSetExtent *extent;
    
    BOOL sorted;
    NSInteger useCount;
}

+ (id)intentWithNodeSetExpression:(XPNodeSetExpression *)expr controller:(XPController *)c;

- (id)initWithNodeSetExpression:(XPNodeSetExpression *)expr controller:(XPController *)c;

- (BOOL)isContextDocumentNodeSet;

@property (nonatomic, retain) XPNodeSetExpression *nodeSetExpression;
@property (nonatomic, getter=isSorted) BOOL sorted;
@end
