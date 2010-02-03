//
//  XPParser.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPParser.h>
#import <Exedore/Exedore.h>
#import <ParseKit/ParseKit.h>

@interface XPParser ()
@property (nonatomic, retain) PKParser *parser;
@property (nonatomic, retain) PKToken *paren;
@end

@implementation XPParser

- (id)init {
    if (self = [super init]) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"xpath1_0" ofType:@"grammar"];
        NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        self.parser = [[PKParserFactory factory] parserFromGrammar:g assembler:self];
        
        self.paren = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" floatValue:0.0];
}
    return self;
}


- (void)dealloc {
    self.parser = nil;
    self.paren = nil;
    [super dealloc];
}


- (XPExpression *)parseExpression:(NSString *)s inContext:(id <XPStaticContext>)ctx {
    XPExpression *res = [parser parse:s];
    return res;
}


- (void)didMatchAnyBooleanExpr:(PKAssembly *)a {
    XPValue *v2 = [a pop];
    PKToken *opTok = [a pop];
    XPValue *v1 = [a pop];

    NSInteger op = XPTokenTypeAnd;
    if ([@"or" isEqualToString:opTok.stringValue]) {
        op = XPTokenTypeOr;
    }

    [a push:[XPBooleanExpression booleanExpressionWithOperand:v1 operator:op operand:v2]];
}


- (void)didMatchAnyRelationalExpr:(PKAssembly *)a {
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


- (void)didMatchAnyArithmeticExpr:(PKAssembly *)a {
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


- (void)didMatchBooleanLiteralFunctionCall:(PKAssembly *)a {
    PKToken *nameTok = [a pop];
    
    BOOL b = NO;
    if ([nameTok.stringValue isEqualToString:@"true"]) {
        b = YES;
    } else if ([nameTok.stringValue isEqualToString:@"false"]) {
        b = NO;
    }
    [a push:[XPBooleanValue booleanValueWithBoolean:b]];
}


- (void)didMatchActualFunctionCall:(PKAssembly *)a {
    NSArray *args = [a objectsAbove:paren];
    [a pop]; // '('
    
    NSString *name = [[a pop] stringValue];

    Class cls = nil;
    if ([name isEqualToString:@"boolean"]) {
        cls = [FNBoolean class];
    } else if ([name isEqualToString:@"ceiling"]) {
        cls = [FNCeiling class];
    } else if ([name isEqualToString:@"concat"]) {
        cls = [FNConcat class];
    } else if ([name isEqualToString:@"contains"]) {
        cls = [FNContains class];
    } else if ([name isEqualToString:@"count"]) {
        cls = [FNCount class];
    } else if ([name isEqualToString:@"ends-with"]) {
        cls = [FNEndsWith class];
    } else if ([name isEqualToString:@"floor"]) {
        cls = [FNFloor class];
    } else if ([name isEqualToString:@"not"]) {
        cls = [FNNot class];
    } else if ([name isEqualToString:@"number"]) {
        cls = [FNNumber class];
    } else if ([name isEqualToString:@"round"]) {
        cls = [FNRound class];
    } else if ([name isEqualToString:@"starts-with"]) {
        cls = [FNStartsWith class];
    } else if ([name isEqualToString:@"string"]) {
        cls = [FNString class];
    } else if ([name isEqualToString:@"string-length"]) {
        cls = [FNStringLength class];
    } else if ([name isEqualToString:@"substring"]) {
        cls = [FNSubstring class];
    } else if ([name isEqualToString:@"substring-after"]) {
        cls = [FNSubstringAfter class];
    } else if ([name isEqualToString:@"substring-before"]) {
        cls = [FNSubstringBefore class];
    } else if ([name isEqualToString:@"sum"]) {
        cls = [FNSum class];
    }

    XPFunction *fn = [[[cls alloc] init] autorelease];
    
    for (id arg in [args reverseObjectEnumerator]) {
        [fn addArgument:arg];
    }
    [a push:fn];
}


- (void)didMatchNameTest:(PKAssembly *)a {
    //PKToken *tok = 
    [a pop];
    
    // TODO
    [a push:[XPBooleanValue booleanValueWithBoolean:YES]]; // this is a place holder. add a node later when ready
}


- (void)didMatchMinusUnionExpr:(PKAssembly *)a {
    XPValue *val = [a pop];
    PKToken *tok = [a pop];
    NSAssert([tok.stringValue isEqualToString:@"-"], @"");

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


- (void)didMatchNumber:(PKAssembly *)a {
    PKToken *tok = [a pop];
    [a push:[XPNumericValue numericValueWithNumber:tok.floatValue]];
}


- (void)didMatchLiteral:(PKAssembly *)a {
    PKToken *tok = [a pop];
    NSString *s = [tok.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'\""]];
    [a push:[XPStringValue stringValueWithString:s]];
}

@synthesize parser;
@synthesize paren;
@end
