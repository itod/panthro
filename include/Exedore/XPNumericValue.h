//
//  XPNumericValue.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPValue.h>

@interface XPNumericValue : XPValue {
    double value;
}

+ (id)numericValueWithString:(NSString *)s;
+ (id)numericValueWithNumber:(double)n;

- (id)initWithString:(NSString *)s;
- (id)initWithNumber:(double)n;

@end
