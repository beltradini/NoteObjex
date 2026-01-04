//
//  NotesStore.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/3/26.
//

#import "NotesStore.h"
#import "Note.h"

@interface NotesStore ()
@property (nonatomic, strong) NSMutableArray<Note *> *privateNotes;
@end
