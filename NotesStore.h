//
//  NotesStore.h
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/3/26.
//

#import <Foundation/Foundation.h>
@class Note;

@interface NotesStore : NSObject

+ (instancetype)sharedStore;

- (NSArray<Note *> *)allNotes;
- (void)addNote:(Note *)note;
- (void)deleteNote:(Note *)note;
- (void)save;

@end
