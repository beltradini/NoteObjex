//
//  Note.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/3/26.
//

#import "Note.h"
#import <CloudKit/CloudKit.h>

@implementation Note

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content {
    self = [super init];
    if (self) {
        _identifier = [[NSUUID UUID] UUIDString];
        _title = [title copy];
        _content = [content copy];
        _createdAt = [NSDate date];
        _updatedAt = _createdAt;
        _cloudRecordID = nil;
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"id": self.identifier,
        @"title": self.title ?: @"",
        @"content": self.content ?: @"",
        @"createdAt": self.createdAt,
        @"updatedAt": self.updatedAt
    };
}

+ (Note *)noteFromDictionary:(NSDictionary *)dict {
    Note *note = [[Note alloc] init];
    note.identifier = dict[@"id"];
    note.title = dict[@"title"];
    note.content = dict[@"content"];
    note.createdAt = dict[@"createdAt"];
    note.updatedAt = dict[@"updatedAt"];
    return note;
}

- (id)copyWithZone:(NSZone *)zone {
    Note *copy = [[[self class] allocWithZone:zone] init];
    copy.identifier = self.identifier;
    copy.title = self.title;
    copy.content = self.content;
    copy.createdAt = self.createdAt;
    copy.updatedAt = self.updatedAt;
    copy.cloudRecordID = self.cloudRecordID;
    return copy;
}

@end
