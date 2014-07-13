//
//  XPCallable.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/13/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPCallable <NSObject>
- (void)addArgument:(XPExpression *)expr;
- (NSUInteger)numberOfArguments;
@end
