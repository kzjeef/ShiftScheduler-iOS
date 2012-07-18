//
//  SSThinkNoteShareAgent.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSShareObject.h"

@class SSShareResult;

@class SSShareController;
@interface SSThinkNoteShareAgent : NSObject

- (id) initWithSharedObject: (SSShareController *)shareC;



- (void) composeThinkNoteWithNagvagation: (UINavigationController *)nvc
                               withBlock: (ComposeShareViewCompleteHander) block;

@end

enum {
    THINKNOTE_CONN_STATUS_IDLE = 1,
    THINKNOTE_CONN_STATUS_LOGIN,
    THINKNOTE_CONN_STATUS_NOTE_POST,
};

@protocol SSThinkNoteControllerDelegate <NSObject>

- (void) thinkNoteServerUpdateState: (int) state error: (NSError *) error;

@end

@interface SSThinkNoteController : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

{
    int _status;
    NSString *_loginToken;
    NSString *_noteID;
    // Attachement is NSDirectory with name & data. 
    // after flush, clear the array.
    NSArray *_attachments;
    NSMutableData *_recvData;
    NSURLConnection *_serverConn;
    
    __unsafe_unretained id <SSThinkNoteControllerDelegate> _connectDelegate;
}

@property (assign) id <SSThinkNoteControllerDelegate> connectDelegate;

- (void) loginNoteServerSyncWithName:(NSString *)name withPassword:(NSString *)password;
- (void) loginNoteServerWithName: (NSString *) name 
                    withPassword: (NSString *) password;

- (int) postNoteOnServer: (NSString *) note;
- (int) postNoteOnServerSync: (NSString *) title note: (NSString *)note;

//- (int) flushNoteCache;

- (int) postAttachment: (NSString *)name withData: (NSData *)data;

- (void) disconnect;

@end
