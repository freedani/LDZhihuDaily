//
//  SQLiteManager.h
//  ZhihuDaily
//
//  Created by 李达 on 2016/12/9.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsDetailModel.h"

@interface SQLiteManager : NSObject

+(SQLiteManager *)sharedInstance;
-(NSString *)newsDetailModelFromSqliteWithID:(NSString*)articleID;
-(void)saveNewsDetailModel:(NSString *)newsDetailModelString withID:(NSString*)articleID;
-(float)fileSize;
-(void)clearFile;

@end
