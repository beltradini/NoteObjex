//
//  NotesStore.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/3/26.
//

#import "NotesStore.h"
#include <objc/objc.h>
#include <Foundation/Foundation.h>
#include <dispatch/dispatch.h>
#import "Note.h"

@interface NotesStore ()
@property (nonatomic, strong) NSMutableArray<Note *> *privateNotes;
@end

@implementation NotesStore

+ (instancetype)sharedStore {
    static NotesStore *store;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[NotesStore alloc] initPrivate];
    });
    return store;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _privateNotes = [NSMutableArray array];
        [self load];
    }
    return self;
}

- (NSArray<Note *> *)allNotes {
    return [_privateNotes copy];
}

- (void)addNote:(Note *) note {
    [self.privateNotes addObject:note];
    [self save];
}

- (void)deleteNote:(Note *)note {
    [self.privateNotes removeObject:note];
    [self save];
}

- (NSString *)notesPath {
    NSString *dir =
      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                          NSUserDomainMask, YES).firstObject;
    return [dir stringByAppendingPathComponent:@"notes.plist"];
}

- (void)save {
    NSMutableArray *array = [NSMutableArray array];
    for (Note *note in self.privateNotes) {
        [array addObject:[note dictionaryRepresentation]];
    }
    [array writeToFile:[self notesPath] atomically:YES];
}

- (void)load {
    NSArray *saved =
      [NSArray arrayWithContentsOfFile:[self notesPath]];
    for (NSDictionary *dict in saved) {
        [self.privateNotes addObject:
         [Note noteFromDictionary:dict]];
    }
}

@end
