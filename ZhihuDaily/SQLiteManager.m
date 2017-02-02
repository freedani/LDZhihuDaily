//
//  SQLiteManager.m
//  ZhihuDaily
//
//  Created by 李达 on 2016/12/9.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "SQLiteManager.h"


@interface SQLiteManager ()

@property (nonatomic, strong) FMDatabase *database;

@end

//静态实例并初始化
static SQLiteManager *shareObj = nil;

@implementation SQLiteManager

#pragma mark 单例
+(SQLiteManager *)sharedInstance {
    @synchronized(self) {
        if (shareObj == nil) {
            shareObj = [[self alloc] init];
        }
    }
    return shareObj;
}

#pragma mark 初始化数据库
-(instancetype)init {
    if (self = [super init]) {
        //文件路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZhihuDaily.Sqlite"];
        //初始化数据库
        self.database = [FMDatabase databaseWithPath:path];
        //打开数据库
        [self.database open];
        
        if ([self.database open]) {
            //将step采用blob类型来存储
            NSString *create = @"CREATE TABLE IF NOT EXISTS newsDetail (id integer PRIMARY KEY, ArticleID TEXT NOT NULL, content blob NOT NULL);";
            [self.database executeUpdate:create];
        }
    }
    return self;
}

#pragma mark 从数据库获取数据

-(NSString *)newsDetailModelFromSqliteWithID:(NSString*)articleID; {
    FMResultSet *set = [self.database executeQueryWithFormat:@"SELECT * FROM newsDetail where ArticleID = %@",articleID];

    while (set.next) {
        NSData *data = [set objectForColumnName:@"content"];
        NSString *str = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return str;
    }
    return nil;
}

#pragma mark 保存数据到数据库

-(void)saveNewsDetailModel:(NSString *)newsDetailModelString withID:(NSString*) articleID {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newsDetailModelString];
    [self.database executeUpdateWithFormat:@"INSERT INTO newsDetail(ArticleID, content) VALUES (%@,%@);", articleID,data];
}

// 显示缓存大小
-( float )fileSize
{
//    float fileSizeBytes = 0;
//    float temp;
//    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString * cachePath = [cachPath stringByAppendingString:@"/Snapshots"];
//    NSLog(@"cachePath %@",cachePath);
//    temp = [self folderSizeAtPath:cachePath];
//    fileSizeBytes += temp;
    NSUInteger size = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:cachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        NSLog(@"%@",filePath);
        NSDictionary *attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    NSLog(@"Cache %.1lfM",(float)size/1024/1024);
    return size;
}
// 清理缓存

- (void)clearFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",cachePath);
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:cachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:filePath error:nil];
    }
//    if ([fileManager removeItemAtPath:cachePath error:nil] == true) {
        NSLog(@"清理成功");
//    }
//    [fileManager createDirectoryAtPath:cachePath
//           withIntermediateDirectories:YES
//                            attributes:nil
//                                 error:NULL];
    shareObj = [self init];
}

@end

