//
//  Note.h
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/3/26.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject <NSCopying>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content;

- (NSDictionary *)dictionaryRepresentation;
+ (Note *)noteFromDictionary:(NSDictionary *)dict;

@end
