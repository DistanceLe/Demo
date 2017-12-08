//
//  CIImageDemoUITests.m
//  CIImageDemoUITests
//
//  Created by LiJie on 2017/1/12.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CIImageDemoUITests : XCTestCase

@end

@implementation CIImageDemoUITests



- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *element = [[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"UIView"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    XCUIElement *textField = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0];
    [textField tap];
    [app.keys[@"n"] tap];
    [textField typeText:@"nigff"];
    
    XCUIElement *returnButton = app.buttons[@"Return"];
    [returnButton tap];
    [textField typeText:@"\n"];
    
    XCUIElement *textField2 = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:1];
    [textField2 tap];
    [app.keys[@"v"] tap];
    [textField2 typeText:@"ch"];
    [app.keys[@"g"] tap];
    [textField2 typeText:@"gf"];
    [returnButton tap];
    [textField2 typeText:@"\n"];
    
    XCUIElement *textField3 = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:2];
    [textField3 tap];
    [app.keys[@"c"] tap];
    [textField3 typeText:@"chg"];
    [returnButton tap];
    [textField3 typeText:@"\n"];
    [element tap];
   
    [app.navigationBars[@"UIView"].buttons[@"Item"] tap];
    
    XCUIElement *viewNavigationBar = app.navigationBars[@"View"];
    [viewNavigationBar.buttons[@"Item"] tap];
    
    XCUIElement *button = app.buttons[@"Button"];
    [button tap];
    [button tap];
    [[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"SecondView"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element swipeRight];
    [[[[viewNavigationBar childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    
    

}

@end
