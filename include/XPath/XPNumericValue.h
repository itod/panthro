//
//  XPNumericValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValue.h"

@interface XPNumericValue : XPValue

+ (instancetype)numericValueWithString:(NSString *)s;
+ (instancetype)numericValueWithNumber:(double)n;

- (instancetype)initWithString:(NSString *)s;
- (instancetype)initWithNumber:(double)n;

@end
