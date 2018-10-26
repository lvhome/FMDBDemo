//
//  LHDataBaseManager.m
//  FmdbDemo
//
//  Created by 祥云创想 on 2018/10/26.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "LHDataBaseManager.h"
#import "FMDB.h"
@interface LHDataBaseManager()
@property (nonatomic, strong) FMDatabase * db;
@end
@implementation LHDataBaseManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static LHDataBaseManager * dataBaseManager = nil;
    dispatch_once(&onceToken, ^{
        dataBaseManager = [[LHDataBaseManager alloc] init];
    });
    return dataBaseManager;
}


/**
 创建数据库和表
 */
- (void)createDataBaseAndTable {
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接文件名
    NSString * sqlitPath = [path stringByAppendingPathComponent:@"LHDataBase.sqlite"];
    NSLog(@"数据库路径:%@",sqlitPath);
    //创建数据库,加入到队列中
    self.db = [FMDatabase databaseWithPath:sqlitPath];
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:@"create table if not exists t_user (id integer primary key autoincrement,name text,content text)"];
        if (result) {
            NSLog(@"t_user表创建成功");
        } else {
            NSLog(@"t_user表创建失败");
        }
    } else {
        NSLog(@"数据库打开失败");
    }
}


/**
 新增数据
 @param name 姓名
 @param content 爱好
 */
-(void)insetName:(NSString *)name content:(NSString *)content {
    
    BOOL result = [self.db executeUpdate:@"insert into t_user (name,content) values (?,?)",name,content];
    if (result) {
        NSLog(@"新增数据成功 名字：%@",name);
    } else {
        NSLog(@"新增数据失败");
    }
}



/**
 删除数据
 @param name 名字
 */
- (void)deleteDataByName:(NSString *)name {
    BOOL result = [self.db executeUpdate:@"delete from t_user where name = ?",name];
    if (result) {
        NSLog(@"删除数据成功");
    }
    else{
        NSLog(@"删除数据失败");
    }
}


/**
 更新数据

 @param name 更新的名字
 @param content 更新的内容
 */
- (void)updataDataWithName:(NSString *)name content:(NSString *)content {
    BOOL result = [self.db executeUpdate:@"update t_user set content = ?  where name = ?",content,name];
    if (result) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
}



/**
 查询数据

 @return 返回查询到的数据
 */
- (NSMutableArray *)selectAllContent {
    NSMutableArray * array = [NSMutableArray array];
    FMResultSet * setResult = [self.db executeQuery:@"select * from t_user"];
    while ([setResult next]) {
        //先将数据存放到字典
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[setResult stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[setResult stringForColumn:@"content"] forKey:@"content"];
        //然后将字典存放到数组
        [array addObject:dic];
    }
    return array;
}





@end


