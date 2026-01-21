//
//  NotesCloudSync.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/20/26.
//

#import "NotesCloudSync.h"
#include <MacTypes.h>
#include <objc/objc.h>
#include <Foundation/Foundation.h>
#include <dispatch/dispatch.h>
#include <CloudKit/CloudKit.h>
#import "Note.h"

#define kNoteRecordType @"Note"
#define kNoteTitleKey @"title"
#define kNoteContentKey @"content"
#define kNoteCreatedAtKey @"createdAt"
#define kNoteUpdatedAtKey @"updatedAt"

@interface NotesCloudSync ()
@property (nonatomic, strong) CKDatabase *privateDB;
@end

@implementation NotesCloudSync

+ (instancetype)sharedSync {
    static NotesCloudSync *shared;
    static dispatch_once_t onceToken;
    dispatch_once_t(&onceToken, ^{
        shared = [[NotesCloudSync alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.privateDB = [[CKContainer defaultContainer] privateCloudDatabase];
    }
    return self;
}

#pragma mark - Public Methods

+ (void)uploadAllNotes:(NSArray<Note *> *)notes completion:(void (^)(NSError *error))completion {
    NSMutableArray<CKRecord *> *records = [NSMutableArray array];
    for (Note *note in notes) {
        CKRecord *record = [self recordFromNote:note];
        [records addObject:record];
    }   
    CKModifyRecordsOperation *op = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:nil];
    op.savePolicy = CKRecordSaveAllKeys;
    op.modifyRecordsCompletionBlock = ^(NSArray *savedRecords, NSArray *deletedRecordIDs, NSError *opError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(opError);
            }
        });
    };
    [self.privateDB addOperation:op];
}

- (void)downloadAllNotesWithCompletion:(void (^)(NSArray<Note *> *, NSError *))completion {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:kNoteRecordType predicate:predicate];
    [self.privateDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> *records, NSError *error) {
        NSMutableArray<Note *> *notes = [NSMutableArray array];
        if (!error) {
            for (CKRecord *record in records) {
                Note *note = [self noteFromRecord:record];
                [notes addObject:note];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(notes, error);
            }
        });
    }];
}

- (void)deleteNoteFromCloud:(Note *)note completion:(void (^)(NSError *))completion {
    if (!note.cloudRecordID) {
        if (completion) completion([NSError errorWithDomain:@"CloudKit" code:0 userInfo:@{NSLocalizedDescriptionKey:@"No CKRecordID for note"}]);
        return;
    }
    [self.privateDB deleteRecordWithID:note.cloudRecordID completionHandler: ^(CKRecordID *recordID, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(error);
            }
        });
    }];
}

#pragma mark - Helper Methods

- (CKRecord *)recordFromNote:(Note *)note {
    CKRecordID *recordID = note.cloudRecordID ?: [[CKRecordID alloc] initWithRecord:[[NSUUID UUID] UUIDString]];

}

@end
