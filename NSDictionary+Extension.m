#import "NSDictionary+Extension.h"

@implementation NSDictionary(Extension)

+ (instancetype) fromJsonString: (NSString*) string
{
    NSError *err;
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
    if(err || ![jsonObj isKindOfClass:[NSDictionary class]]) { return nil; }
    return (NSDictionary *)jsonObj;
}

- (NSString *) toString
{
    NSError *err;
    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingFragmentsAllowed error:&err];
    if(err) { return nil; }
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}
    
@end
