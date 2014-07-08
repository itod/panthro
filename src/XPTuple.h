//
//  XPTuple.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import <Foundation/Foundation.h>

@class XPExpression;

@interface XPTuple : NSObject

+ (instancetype)tupeWithResultItems:(NSArray *)res orderSpecs:(NSArray *)specs;

@property (nonatomic, retain) NSArray *resultItems;
@property (nonatomic, retain) NSArray *orderSpecs;
@end
