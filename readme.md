# What It Is

KloutRequest is a Klout API wrapper for Cocoa Touch

# Requirements

Requires ARC

Uses NSJSONSerialization which requires iOS5

# How to use

Get an API key from http://developer.klout.com/
Paste the API key into KloutRequest.h

Get Klout Scores, Profiles, Topics, Incluencers, and Incluencees for lists of users:

KloutRequest *kloutRequest = [KloutRequest kloutRequest:kKloutScore forUsers:[NSArray arrayWithObjects:@"blackoutrobb",@"appstore",nil] withDelegate:self];

Declare the delegate methods to get the result:

- (void)kloutRequestReceivedResponse:(NSArray *)scoresArray;
- (void)kloutRequestFailedWithError:(NSError *)error;