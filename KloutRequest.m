//
//  Klout.m
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

#import "KloutRequest.h"

@interface KloutRequest ()

// private properties
@property(nonatomic,strong) NSMutableData *responseData;

@end

@implementation KloutRequest

+ (KloutRequest *)kloutRequest:(NSString *)requestType forUsers:(NSArray *)usersArray withDelegate:(id<KloutRequestDelegate>)delegate{
    KloutRequest *kloutRequest = [[KloutRequest alloc] init];
    [kloutRequest setKloutRequestDelegate:delegate];
    
    NSMutableString *userString = [NSMutableString stringWithCapacity:1];
    for(NSString *username in usersArray) {
        if ([userString length]>0) {
            [userString appendString:@","];
        }
        [userString appendString:username];
    }    
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.klout.com/1/%@.json?users=%@&key=%@",requestType,userString,kKloutAPIKey];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *kloutConnection = [NSURLConnection connectionWithRequest:request delegate:kloutRequest];
    [kloutConnection start];
    
    return kloutRequest;
}


//--NSURLConnectionDelegate Methods--//

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    NSError *error=nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
    
    if (error==nil) {
        NSArray *scoresArray = [responseDictionary objectForKey:@"users"];
        if ([self.kloutRequestDelegate respondsToSelector: @selector(kloutRequestReceivedResponse:)]) {
            [self.kloutRequestDelegate kloutRequestReceivedResponse:scoresArray];
        }
    } else {
        if ([self.kloutRequestDelegate respondsToSelector: @selector(kloutRequestFailedWithError:)]) {
            [self.kloutRequestDelegate kloutRequestFailedWithError:error];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //done loading.  Do something with response data    
    self.responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([self.kloutRequestDelegate respondsToSelector: @selector(kloutRequestFailedWithError:)]) {
        [self.kloutRequestDelegate kloutRequestFailedWithError:error];
    }
    self.responseData = nil;
}

@synthesize responseData = _responseData;
@synthesize kloutRequestDelegate = _kloutRequestDelegate;
@end