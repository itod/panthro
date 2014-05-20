//
//  XPSync.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/19/14.
//
//

#import <Foundation/Foundation.h>

@interface XPSync : NSObject

+ (instancetype)sync;

- (id)awaitPause;
- (void)pause:(id)info;

- (id)awaitResume;
- (void)resume:(id)info;
@end
