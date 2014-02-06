//
//  ViewController.m
//  SQLite Using C Library 2
//
//  Created by danny on 2014/2/6.
//  Copyright (c) 2014年 danny. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self testDatabase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)testDatabase
{
    //
	char		*sqlStatement;
	sqlite3		*pDb;
	char		*errorMsg;
	int			returnCode;
    //
    sqlite3_stmt *statement;
    
    NSString *sqlitepath = [[NSBundle mainBundle] pathForResource:@"sqlitedata" ofType:@"db"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:sqlitepath]){
        NSLog(@"檔案存在！");
        //這裡放置如果檔案存在時的程式
    }else{
        NSLog(@"檔案不存在！");
    }
    
    NSLog(@"%@",sqlitepath);
    
    NSLog(@"-----------callback mode-----------\n");
    
    const char *databaseFileName =[sqlitepath UTF8String];
    
    returnCode= sqlite3_open(databaseFileName, &pDb);
	if(returnCode!=SQLITE_OK) {
		fprintf(stderr, "Error in opening the database. Error: %s", sqlite3_errmsg(pDb));
		sqlite3_close(pDb);
		return;
	}
    
    //
    
	sqlStatement =  "SELECT * from stocks";
	returnCode = sqlite3_exec(pDb, sqlStatement, processRow, NULL, &errorMsg);
	if(returnCode!=SQLITE_OK) {
		fprintf(stderr, "Error in selecting from stocks table. Error: %s", errorMsg);
		sqlite3_free(errorMsg);
	}
    
    //
    NSLog(@"-----------prepare mode-----------\n");
    
    returnCode=sqlite3_prepare_v2(pDb, sqlStatement, strlen(sqlStatement), &statement, NULL);
	if(returnCode!=SQLITE_OK) {
		fprintf(stderr, "Error in selecting from stocks table. Error: %s", errorMsg);
		sqlite3_free(errorMsg);
	}
    returnCode = sqlite3_step(statement);
    while (returnCode == SQLITE_ROW){
        const unsigned char *symbol;
        int units;
        double price;
        symbol = sqlite3_column_text(statement,0);
        price = sqlite3_column_double(statement,1);
        units = sqlite3_column_int(statement,2);
        printf("We bought %d from %s at a price %.4f\n",units,symbol,price);
        returnCode = sqlite3_step(statement);
    }
    
    
	sqlite3_close(pDb);
    
}


static int processRow(void *argument, int argc, char **argv, char **colName){
	printf("Record Data:\n");
	for(int i=0; i<argc; i++){
		printf("The value for Column Name %s is equal to %s\n", colName[i], argv[i] ? argv[i] : "NULL");
	}
	printf("\n");
	return 0;
}

@end
