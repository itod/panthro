//
//  XPRegexTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/12/14.
//
//

#import "XPTestScaffold.h"

@interface XPRegexTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) BOOL res;
@end

@implementation XPRegexTest

- (void)setUp {
    [super setUp];

}


- (void)tearDown {
    self.expr = nil;
    [super tearDown];
}


- (void)testMatches {
    self.expr = [XPExpression expressionFromString:@"matches('foo', 'foo')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"matches('foo', 'FOO')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"matches('foo', 'FOO', 'i')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"matches('foo', '\\w+')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"matches('foo', '\\W+')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"matches('abracadabra', 'bra')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"matches('abracadabra', '^a.*a$')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"matches('abracadabra', '^bra')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
}


- (void)testReplace {
    self.expr = [XPExpression expressionFromString:@"replace('abracadabra', 'bra', '*')" inContext:nil error:nil];
    NSString *res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"a*cada*", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('abracadabra', 'BRA', '*', 'i')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"a*cada*", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('abracadabra', 'a.*a', '*')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"*", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('abracadabra', 'a.*?a', '*')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"*c*bra", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('abracadabra', 'a', '')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"brcdbr", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('abracadabra', 'a(.)', 'a$1$1')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"abbraccaddabbra", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('abracadabra', '.*?', '$1')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"abracadabra", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('AAAA', 'A+', 'b')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"b", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('AAAA', 'A+?', 'b')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"bbbb", res);
    
    self.expr = [XPExpression expressionFromString:@"replace('darted', '^(.*?)d(.*)$', '$1c$2')" inContext:nil error:nil];
    res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"carted", res);
    
}

//replace("abracadabra", "bra", "*") returns "a*cada*"
//replace("abracadabra", "a.*a", "*") returns "*"
//replace("abracadabra", "a.*?a", "*") returns "*c*bra"
//replace("abracadabra", "a", "") returns "brcdbr"
//replace("abracadabra", "a(.)", "a$1$1") returns "abbraccaddabbra"
//replace("abracadabra", ".*?", "$1") raises an error, because the pattern matches the zero-length string
//replace("AAAA", "A+", "b") returns "b"
//replace("AAAA", "A+?", "b") returns "bbbb"
//replace("darted", "^(.*?)d(.*)$", "$1c$2") returns "carted". The first d is replaced.

@end
