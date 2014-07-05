//
//  XPValue.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Panthro/XPExpression.h>
#import <Panthro/XPItem.h>

@class XPContext;

double XPNumberFromString(NSString *s);

@interface XPValue : XPExpression <XPItem>

- (NSString *)asString;
- (double)asNumber;
- (BOOL)asBoolean;

- (BOOL)isEqualToValue:(XPValue *)other;
- (BOOL)isNotEqualToValue:(XPValue *)other;

- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op;
- (NSInteger)inverseOperator:(NSInteger)op;
- (BOOL)compareNumber:(double)x toNumber:(double)y usingOperator:(NSInteger)op;

// convenience
- (BOOL)isBooleanValue;
- (BOOL)isNumericValue;
- (BOOL)isStringValue;
- (BOOL)isNodeSetValue;
- (BOOL)isObjectValue;
@end
