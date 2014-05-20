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

- (id)takePauseInfo;
- (void)putPauseInfo:(id)info;

- (id)takeResumeInfo;
- (void)putResumeInfo:(id)info;
@end
