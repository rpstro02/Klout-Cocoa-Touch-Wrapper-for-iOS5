//
//  Klout.h
//  Created by Robert Strojan on 2/4/12.
//  Copyright (c) 2012 Robert Strojan. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

@protocol KloutRequestDelegate;

/////--Enter Your API Key Below--/////

static NSString * const kKloutAPIKey = @"PASTE-YOUR-API-KEY-HERE";

////----------------------------/////

static NSString * const kKloutScore = @"klout";
static NSString * const kKloutProfile = @"users/show";
static NSString * const kKloutTopics = @"users/topics";
static NSString * const kKloutInfluencedBy = @"soi/influenced_by";
static NSString * const kKloutInfluencerOf = @"soi/influencer_of";

@interface KloutRequest : NSObject <NSURLConnectionDelegate>

@property(nonatomic,weak) id<KloutRequestDelegate> kloutRequestDelegate;

+ (KloutRequest *)kloutRequest:(NSString *)requestType forUsers:(NSArray *)usersArray withDelegate:(id<KloutRequestDelegate>)delegate;

@end

//----------------------------------------------------------------------------------------//
//--------------------------  Delegate Methods  ------------------------------------------//
//----------------------------------------------------------------------------------------//

@protocol KloutRequestDelegate <NSObject>

- (void)kloutRequestReceivedResponse:(NSArray *)scoresArray; //returns an array of dictionaries containing the result.
- (void)kloutRequestFailedWithError:(NSError *)error;  

@end