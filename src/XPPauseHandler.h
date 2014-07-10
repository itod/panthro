//
//  XPPauseHandler.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/9/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPPauseHandler <NSObject>

@property (nonatomic, retain, readonly) NSArray *currentResultNodes;
@end
