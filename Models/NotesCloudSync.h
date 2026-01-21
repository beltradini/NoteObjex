//
//  NotesCloudSync.h
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/20/26.
//

#import <Foundation/Foundation.h>
#include <objc/NSObject.h>
#import <CloudKit/CloudKit.h>

@class Note;

@interface NotesCloudSync : NSObject

+ (instancetype)sharedSync;

- (void)uploadAllNotes:(NSArray<Note *> *)notes completion:(void (^)(NSError * error))completion;

- (void)downloadAllNotesWithCompletion:(void (^)(NSArray<Note *> * notes, NSError * error))completion;

- (void)deleteNoteFromCloud:(Note *)note completion:(void (^)(NSError * error))completion;

@end
