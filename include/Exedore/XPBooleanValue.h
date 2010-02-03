//
//  XPBooleanValue.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPValue.h>

@interface XPBooleanValue : XPValue {
    BOOL value;
}

+ (id)booleanValueWithBoolean:(BOOL)b;

- (id)initWithBoolean:(BOOL)b;

@end
