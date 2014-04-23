//
//  XPStepTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPTestScaffold.h"

@interface XPStepTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) id res;
@end

@implementation XPStepTest

- (void)setUp {
    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

- (void)testExample {
    self.expr = [XPExpression expressionFromString:@"node()" inContext:nil error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDNotNil(_res);
    
}

@end
