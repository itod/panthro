//
//  XPValue.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPExpression.h>

@class XPContext;

typedef enum {
    XPTokenTypeUnknown = -1,
	XPTokenTypeEOF = 0,
	XPTokenTypeName = 1,
	XPTokenTypeFunction = 2,
	XPTokenTypeLiteral = 3,
	XPTokenTypeVbar = 4,
	XPTokenTypeSlash = 5,
	XPTokenTypeAt = 6,
	XPTokenTypeLsqb = 7,
	XPTokenTypeRsqb = 8,
	XPTokenTypeLpar = 9,
	XPTokenTypeRpar = 10,
	XPTokenTypeEquals = 11,
	XPTokenTypeDot = 12,
	XPTokenTypeDotDot = 13,
	XPTokenTypeStar = 14,
	XPTokenTypeComma = 15,
	XPTokenTypeSlashSlash = 16,
	XPTokenTypePrefix = 17,
	XPTokenTypeOr = 18,
	XPTokenTypeAnd = 19,
	XPTokenTypeNumber = 20,
	XPTokenTypeGT = 21,
	XPTokenTypeLT = 22,
	XPTokenTypeGE = 23,
	XPTokenTypeLE = 24,
	XPTokenTypePlus = 25,
	XPTokenTypeMinus = 26,
	XPTokenTypeMult = 27,
	XPTokenTypeDiv = 28,
	XPTokenTypeMod = 29,
	XPTokenTypeDollar = 31,
	XPTokenTypeNodetype = 32,
	XPTokenTypeAxis = 33,
	XPTokenTypeNE = 34,

	XPTokenTypeNegate = 99    // unary minus: not actually a token, but we
                                // use token numbers to identify operators.
} XPTokenType;

double XPNumberFromString(NSString *s);

@interface XPValue : XPExpression {

}

- (NSString *)asString;

- (double)asNumber;

- (BOOL)asBoolean;

- (BOOL)isEqualToValue:(XPValue *)other;

- (BOOL)isNotEqualToValue:(XPValue *)other;

- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op;

- (NSInteger)inverseOperator:(NSInteger)op;
    
- (BOOL)compareNumber:(double)x toNumber:(double)y usingOperator:(NSInteger)op;

- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx;

// convenience
- (BOOL)isBooleanValue;
- (BOOL)isNumericValue;
- (BOOL)isStringValue;
- (BOOL)isNodeSetValue;
@end
