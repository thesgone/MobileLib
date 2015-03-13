/*
 This file is part of MobileLib, a free-software/open source library
 for mobile app development.
 MobileLib is free software: you can redistribute it and/or modify it
 under the terms of the MobileLib license.
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 or FITNESS FOR A PARTICULAR PURPOSE.  See the license for more details.
 */

#import <Foundation/Foundation.h>
#import <MobileLib/TryCatch.h>

@implementation TryCatch

+ (void)try:(void(^)())try catch:(void(^)(NSException*exception))catch finally:(void(^)())finally{
    @try{
        try ? try() : nil;
    }
    
    @catch(NSException * exception){
        catch ? catch(exception) : nil;
    }
    
    @finally{
        finally ? finally() : nil;
    }
    
    
}


@end