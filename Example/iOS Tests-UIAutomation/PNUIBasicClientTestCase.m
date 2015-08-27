//
//  PNUIBasicClientTestCase.m
//  PubNub
//
//  Created by Jordan Zucker on 8/27/15.
//  Copyright (c) 2015 Jordan Zucker. All rights reserved.
//

#import "PNUIBasicClientTestCase.h"

@implementation PNUIBasicClientTestCase

- (JSZVCRTestingStrictness)matchingFailStrictness {
    return JSZVCRTestingStrictnessNone;
}

- (void)beforeEach {
    [super beforeEach];
    [PNLog enabled:YES];
    self.configuration = [PNConfiguration configurationWithPublishKey:@"demo-36" subscribeKey:@"demo-36"];
    self.configuration.uuid = @"322A70B3-F0EA-48CD-9BB0-D3F0F5DE996C";
    self.client = [PubNub clientWithConfiguration:self.configuration];
}

- (void)afterEach {
    self.client = nil;
    [super afterEach];
}

- (Class<JSZVCRMatching>)matcherClass {
    return [JSZVCRUnorderedQueryMatcher class];
}

#pragma mark - Channel Group Helpers

- (void)performVerifiedAddChannels:(NSArray *)channels toGroup:(NSString *)channelGroup withAssertions:(PNChannelGroupAssertions)assertions {
    XCTestExpectation *addChannelsToGroupExpectation = [self expectationWithDescription:@"addChannels"];
    [self.client addChannels:channels toGroup:channelGroup
              withCompletion:^(PNAcknowledgmentStatus *status) {
                  if (assertions) {
                      assertions(status);
                  }
                  [addChannelsToGroupExpectation fulfill];
              }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)performVerifiedRemoveAllChannelsFromGroup:(NSString *)channelGroup withAssertions:(PNChannelGroupAssertions)assertions {
    XCTestExpectation *removeChannels = [self expectationWithDescription:@"removeChannels"];
    [self.client removeChannelsFromGroup:channelGroup withCompletion:^(PNAcknowledgmentStatus *status) {
        if (assertions) {
            assertions(status);
        }
        [removeChannels fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)performVerifiedRemoveChannels:(NSArray *)channels fromGroup:(NSString *)channelGroup withAssertions:(PNChannelGroupAssertions)assertions {
    XCTestExpectation *removeSpecificChannels = [self expectationWithDescription:@"removeSpecificChannels"];
    [self.client removeChannels:channels fromGroup:channelGroup withCompletion:^(PNAcknowledgmentStatus *status) {
        if (assertions) {
            assertions(status);
        }
        [removeSpecificChannels fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

@end