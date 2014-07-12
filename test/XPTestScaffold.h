//
//  PKTestScaffold.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <Panthro/Panthro.h>

#import "XPEGParser.h"
#import "XPStandaloneContext.h"

#define TDTrue(e) XCTAssertTrue((e), @"")
#define TDFalse(e) XCTAssertFalse((e), @"")
#define TDNil(e) XCTAssertNil((e), @"")
#define TDNotNil(e) XCTAssertNotNil((e), @"")
#define TDEquals(e1, e2) XCTAssertEqual((e1), (e2), @"")
#define TDEqualsWithAccuracy(e1, e2, acc) XCTAssertEqualWithAccuracy((e1), (e2), (acc), @"")
#define TDEqualObjects(e1, e2) XCTAssertEqualObjects((e1), (e2), @"")

extern NSString *XPPathOfFile(NSString *relFilePath);
extern NSString *XPContentsOfFile(NSString *relFilePath);