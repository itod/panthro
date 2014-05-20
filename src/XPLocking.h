//
//  XPLocking.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/19/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPLocking <NSObject>

- (void)acquire;
- (void)relinquish;
@end

