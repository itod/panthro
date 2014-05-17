//
//  PKTestScaffold.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

NSString *XPPathOfFile(NSString *relFilePath) {
    NSString *file = [relFilePath stringByDeletingPathExtension];
    NSString *ext = [relFilePath pathExtension];
    NSString *path = [[NSBundle bundleWithIdentifier:@"com.celestialteapot.XPTests"] pathForResource:file ofType:ext];
    return path;
}


NSString *XPContentsOfFile(NSString *relFilePath) {
    NSString *path = XPPathOfFile(relFilePath);
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return str;
}