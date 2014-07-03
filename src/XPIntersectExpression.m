//
//  XPIntersectExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPIntersectExpression.h"
#import "XPIntersectEnumeration.h"

@implementation XPIntersectExpression

- (NSString *)operator {
    return @"intersect";
}


- (Class)enumerationClass {
    return [XPIntersectEnumeration class];
}

@end
