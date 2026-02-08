//
//  Note.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/3/26.
//

#import "Note.h"
#include <Foundation/Foundation.h>
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
        _cloudRecord = nil;
        _cloudRecordName = nil;
        _cloudRecordChangeTag = nil;
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"id": self.identifier,
        @"title": self.title ?: @"",
        @"content": self.content ?: @"",
        @"createdAt": self.createdAt ?: [NSNull null],
        @"updatedAt": self.updatedAt ?: [NSNull null],
        @"cloudRecordName": self.cloudRecordName ? self.cloudRecordName.recordName : @"",
        @"cloudRecordChangeTag": self.cloudRecordChangeTag ?: @""
    };
}

+ (Note *)noteFromDictionary:(NSDictionary *)dict {
    Note *note = [[Note alloc] init];
    note.identifier = dict[@"id"];
    note.title = dict[@"title"];
    note.content = dict[@"content"];
    note.createdAt = dict[@"createdAt"];
    note.updatedAt = dict[@"updatedAt"];
    NSString *rName = dict[@"cloudRecordName"];
    note.cloudRecordName = (rName && [rName length] > 0) ? [[CKRecordID alloc] initWithRecordName:rName] : nil;
    NSString *rTag = dict[@"cloudRecordChangeTag"];
    note.cloudRecordChangeTag = (rTag && [rTag length] > 0) ? rTag : nil;
    return note;
}

- (id)copyWithZone:(NSZone *)zone {
    Note *copy = [[[self class] allocWithZone:zone] init];
    copy.identifier = self.identifier;
    copy.title = self.title;
    copy.content = self.content;
    copy.createdAt = self.createdAt;
    copy.updatedAt = self.updatedAt;
    copy.cloudRecord = self.cloudRecord;
    copy.cloudRecordName = self.cloudRecordName;
    copy.cloudRecordChangeTag = self.cloudRecordChangeTag;
    return copy;
}

@end
