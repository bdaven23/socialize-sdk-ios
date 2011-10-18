/*
 * SocializeActivityServiceTests.m
 * SocializeSDK
 *
 * Created on 10/18/11.
 * 
 * Copyright (c) 2011 Socialize, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * See Also: http://gabriel.github.com/gh-unit/
 */

#import "SocializeActivityServiceTests.h"
#import "SocializeActivityService.h"
#import "SocializeService+Testing.h"
#import "SocializeLikeService.h"

@implementation SocializeActivityServiceTests

-(void)setUpClass
{
    SocializeActivityService* service = [[SocializeActivityService alloc] init];
    _activityService = [[service nonRetainingMock] retain];
    [service release];
}

-(void)tearDown
{
    [_activityService release];
}

-(void)testGetActivityOfCurrentUser
{    
    [[_activityService expect]executeRequest:
     [SocializeRequest requestWithHttpMethod:@"GET"
                                resourcePath:@"activity/"
                          expectedJSONFormat:SocializeDictionaryWIthListAndErrors
                                      params:nil]];
    
    [_activityService getActivityOfCurrentUser];
    [_activityService verify];
}

@end