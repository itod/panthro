//
//  XPSynchronousChannel.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/19/14.
//
//

#import <Foundation/Foundation.h>

@interface XPSynchronousChannel : NSObject

+ (instancetype)synchronousChannel;

- (void)put:(id)obj;
- (id)take;
@end
