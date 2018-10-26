//
//  LHDataBaseManager.h
//  FmdbDemo
//
//  Created by 祥云创想 on 2018/10/26.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHDataBaseManager : NSObject
/**
 创建数据库和表
 */
- (void)createDataBaseAndTable;
/**
 创建对象
 @return 返回LHDataBaseManager 对象
 */
+ (instancetype)shareManager;
/**
 删除数据
 @param name 名字
 */
- (void)deleteDataByName:(NSString *)name;
/**
 查询数据
 
 @return 返回查询到的数据
 */
- (NSMutableArray *)selectAllContent;
/**
 更新数据
 
 @param name 更新的名字
 @param content 更新的内容
 */
- (void)updataDataWithName:(NSString *)name content:(NSString *)content;

/**
 新增数据
 @param name 姓名
 @param content 爱好
 */
-(void)insetName:(NSString *)name content:(NSString *)content;
@end
