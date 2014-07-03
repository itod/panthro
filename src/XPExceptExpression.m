//
//  XPExceptExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPExceptExpression.h"
#import "XPExceptEnumeration.h"

@implementation XPExceptExpression

- (NSString *)operator {
    return @"except";
}


- (Class)enumerationClass {
    return [XPExceptEnumeration class];
}

@end
