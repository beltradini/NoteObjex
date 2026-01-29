//
//  Note.h
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/3/26.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface Note : NSObject <NSCopying>

@property (nonatomic, copy) NSString * _Nullable identifier;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable content;
@property (nonatomic, strong) NSDate * _Nullable createdAt;
@property (nonatomic, strong) NSDate * _Nullable updatedAt;
@property (nonatomic, strong, nullable) CKRecordID *cloudRecordID;

- (instancetype _Nullable )initWithTitle:(NSString *_Nullable)title
                                 content:(NSString *_Nullable)content;

- (NSDictionary *_Nullable)dictionaryRepresentation;
+ (Note *_Nullable)noteFromDictionary:(NSDictionary *_Nullable)dict;

@end
