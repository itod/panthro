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

- (id)awaitPauseInfo;
- (void)pauseWithInfo:(id)info;

- (id)awaitResumeInfo;
- (void)resumeWithInfo:(id)info;
@end
