//
//  XPGroupSpec.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import <Foundation/Foundation.h>

@class XPValue;

@interface XPGroupSpec : NSObject

+ (instancetype)groupSpecWithValue:(XPValue *)val;

@property (nonatomic, retain) XPValue *value;
@end
