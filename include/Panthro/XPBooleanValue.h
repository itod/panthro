//
//  XPBooleanValue.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Panthro/XPValue.h>

@interface XPBooleanValue : XPValue

+ (instancetype)booleanValueWithBoolean:(BOOL)b;

- (instancetype)initWithBoolean:(BOOL)b;

@end
