/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBSessionTokenCachingStrategy.h"

// SocializeFBSessionManualTokenCachingStrategy
//
// Summary:
// Internal use only, this class enables migration logic for the Facebook class, by providing
// a means to directly provide the access token to a FBSession object
//
@interface SocializeFBSessionManualTokenCachingStrategy : FBSessionTokenCachingStrategy

// set the properties before instantiating the FBSession object in order to seed a token
@property (readwrite, copy) NSString *accessToken;
@property (readwrite, copy) NSDate *expirationDate;

@end

