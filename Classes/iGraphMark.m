//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//
#import "iGraphMark.h"

@implementation iGraphMark

@synthesize index;
@synthesize point;
@synthesize title;
@synthesize value;


- (id)initWithIndex:(NSUInteger)_index {
    if (![super init]) return nil;
    index = _index;
    return self;
}


- (void)dealloc {
    [title release];
    [super dealloc];
}

@end
