//
//  XPSortable.h
//  Exedore
//
//  Created by Todd Ditchendorf on 8/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPSortable <NSObject>
- (NSComparisonResult)compare:(NSInteger)a to:(NSInteger)b;
- (void)swap:(NSInteger)a with:(NSInteger)b;
@end
