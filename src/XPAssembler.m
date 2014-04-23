//
//  XPAssembler.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPAssembler.h>
#import <XPath/XPath.h>
#import <PEGKit/PEGKit.h>

@interface XPAssembler ()
@property (nonatomic, retain) NSDictionary *funcTable;
@property (nonatomic, retain) PKToken *paren;
@property (nonatomic, retain) NSCharacterSet *singleQuoteCharacterSet;
@property (nonatomic, retain) NSCharacterSet *doubleQuoteCharacterSet;
@end

@implementation XPAssembler

- (id)init {
    if (self = [super init]) {
        self.paren = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
        self.singleQuoteCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"'"];
        self.doubleQuoteCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
        
        self.funcTable = [NSDictionary dictionaryWithObjectsAndKeys:
                          [FNBoolean class], @"boolean",
                          [FNCeiling class], @"ceiling",
                          [FNConcat class], @"concat",
                          [FNContains class], @"contains",
                          [FNCount class], @"count",
                          [FNEndsWith class], @"ends-with",
                          [FNFloor class], @"floor",
                          [FNNot class], @"not",
                          [FNNumber class], @"number",
                          [FNRound class], @"round",
                          [FNStartsWith class], @"starts-with",
                          [FNString class], @"string",
                          [FNStringLength class], @"string-length",
                          [FNSubstring class], @"substring",
                          [FNSubstringAfter class], @"substring-after",
                          [FNSubstringBefore class], @"substring-before",
                          [FNSum class], @"sum",
                          nil];
}
    return self;
}


- (void)dealloc {
    self.paren = nil;
    self.singleQuoteCharacterSet = nil;
    self.doubleQuoteCharacterSet = nil;
    self.funcTable = nil;
    [super dealloc];
}


- (void)parser:(PKParser *)p didMatchOrAndExpr:(PKAssembly *)a { [self parser:p didMatchAnyBooleanExpr:a]; }
- (void)parser:(PKParser *)p didMatchAndEqualityExpr:(PKAssembly *)a { [self parser:p didMatchAnyBooleanExpr:a]; }

- (void)parser:(PKParser *)p didMatchAnyBooleanExpr:(PKAssembly *)a {
    XPValue *v2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *v1 = [a pop];

    NSInteger op = XPTokenTypeAnd;

    if ([@"or" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeOr;
    }

    [a push:[XPBooleanExpression booleanExpressionWithOperand:v1 operator:op operand:v2]];
}


- (void)parser:(PKParser *)p didMatchCompareAdditiveExpr:(PKAssembly *)a { [self parser:p didMatchAnyRelationalExpr:a]; }
- (void)parser:(PKParser *)p didMatchEqRelationalExpr:(PKAssembly *)a { [self parser:p didMatchAnyRelationalExpr:a]; }

- (void)parser:(PKParser *)p didMatchAnyRelationalExpr:(PKAssembly *)a {
    XPValue *v2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *v1 = [a pop];
    
    NSInteger op = XPTokenTypeEquals;

    if ([@"!=" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeNE;
    } else if ([@"<" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeLT;
    } else if ([@">" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeGT;
    } else if ([@"<=" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeLE;
    } else if ([@">=" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeGE;
    }
    
    [a push:[XPRelationalExpression relationalExpressionWithOperand:v1 operator:op operand:v2]];
}


- (void)parser:(PKParser *)p didMatchPlusOrMinusMultiExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a]; }
- (void)parser:(PKParser *)p didMatchMultDivOrModUnaryExpr:(PKAssembly *)a { [self parser:p didMatchAnyArithmeticExpr:a]; }

- (void)parser:(PKParser *)p didMatchAnyArithmeticExpr:(PKAssembly *)a {
    XPValue *v2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *v1 = [a pop];
    
    NSInteger op = XPTokenTypePlus;
    
    if ([@"-" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeMinus;
    } else if ([@"div" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeDiv;
    } else if ([@"*" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeMult;
    } else if ([@"mod" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeMod;
    }
    
    [a push:[XPArithmeticExpression arithmeticExpressionWithOperand:v1 operator:op operand:v2]];
}


- (void)parser:(PKParser *)p didMatchBooleanLiteralFunctionCall:(PKAssembly *)a {
    PKToken *nameTok = [a pop];
    
    BOOL b = NO;
    
    if ([nameTok.stringValue isEqualToString:@"true"]) {
        b = YES;
    }

    [a push:[XPBooleanValue booleanValueWithBoolean:b]];
}


- (void)parser:(PKParser *)p didMatchActualFunctionCall:(PKAssembly *)a {
    NSArray *args = [a objectsAbove:_paren];
    [a pop]; // '('
    
    NSString *name = [[a pop] stringValue];

    Class cls = [_funcTable objectForKey:name];
    NSAssert1(cls, @"unknown function %@", name);
    
    XPFunction *fn = [[[cls alloc] init] autorelease];
    
    for (id arg in [args reverseObjectEnumerator]) {
        [fn addArgument:arg];
    }
    [a push:fn];
}


- (void)parser:(PKParser *)p didMatchAxisName:(PKAssembly *)a {
    PKToken *tok = [a pop];
    
    // TODO
    [a push:[XPBooleanValue booleanValueWithBoolean:tok.doubleValue]]; // this is a place holder. add a node later when ready
}



- (void)parser:(PKParser *)p didMatchTypeTest:(PKAssembly *)a {
    PKToken *tok = [a pop];
    
    [a push:[XPBooleanValue booleanValueWithBoolean:tok.doubleValue]]; // this is a place holder. add a node later when ready
}


- (void)parser:(PKParser *)p didMatchNameTest:(PKAssembly *)a {
    PKToken *tok = [a pop];
    
    // TODO
    [a push:[XPBooleanValue booleanValueWithBoolean:tok.doubleValue]]; // this is a place holder. add a node later when ready
}


- (void)parser:(PKParser *)p didMatchMinusUnionExpr:(PKAssembly *)a {
    XPValue *val = [a pop];
    PKToken *tok = [a pop];
    XPAssert([tok.stringValue isEqualToString:@"-"]);

    BOOL isNegative = NO;
    while ([tok.stringValue isEqualToString:@"-"]) {
        isNegative = !isNegative;
        tok = [a pop];
    }
    [a push:tok]; // put that last one back, fool
    
    double d = [val asNumber];
    if (isNegative) d = -d;
    [a push:[XPNumericValue numericValueWithNumber:d]];
}


- (void)parser:(PKParser *)p didMatchNumber:(PKAssembly *)a {
    PKToken *tok = [a pop];
    [a push:[XPNumericValue numericValueWithNumber:tok.doubleValue]];
}


- (void)parser:(PKParser *)p didMatchLiteral:(PKAssembly *)a {
    PKToken *tok = [a pop];
    NSString *s = tok.stringValue;
    
    if ([s length]) {
        unichar c = [s characterAtIndex:0];
        NSCharacterSet *set = _singleQuoteCharacterSet;
        if ('"' == c) {
            set = _doubleQuoteCharacterSet;
        }
        s = [s stringByTrimmingCharactersInSet:set];
    }
    
    [a push:[XPStringValue stringValueWithString:s]];
}

@end
