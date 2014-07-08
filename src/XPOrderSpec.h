//
//  XPOrderSpec.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import <Foundation/Foundation.h>

@class XPValue;

@interface XPOrderSpec : NSObject

+ (instancetype)orderSpecWithValue:(XPValue *)val modifier:(NSComparisonResult)mod;

@property (nonatomic, retain) XPValue *value;
@property (nonatomic, assign) NSComparisonResult modifier;
@end
