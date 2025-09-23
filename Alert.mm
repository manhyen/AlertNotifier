#import <UIKit/UIKit.h>

__attribute__((constructor))
static void showAlertAfterLaunch() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Khổng Mạnh Yên⛈️"
                                                                       message:@"Inbox thì cứ thêm vài từ *Mình sẽ trả phí* là được 😆"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Đóng"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [ok setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alert addAction:ok];
        UIAlertAction *openLink = [UIAlertAction actionWithTitle:@"Website"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:@"https://beacons.ai/yenv2"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }];
        [openLink setValue:[UIColor systemPinkColor] forKey:@"titleTextColor"];
        [alert addAction:openLink];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert
                                                                                     animated:YES
                                                                                   completion:nil];
    });
}