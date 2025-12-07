#import <UIKit/UIKit.h>
@interface GlassAlert : UIView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)msg;
@end

@implementation GlassAlert {
    UIView *glass;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)msg {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];

        // Glass box
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *box = [[UIVisualEffectView alloc] initWithEffect:blur];
        box.frame = CGRectMake(40, 200, self.frame.size.width - 80, 230);
        box.layer.cornerRadius = 25;
        box.layer.masksToBounds = YES;
        box.layer.borderWidth = 1.2;
        box.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
        [self addSubview:box];
        glass = box;

        // Title
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, box.frame.size.width - 40, 30)];
        titleLbl.text = title;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.font = [UIFont boldSystemFontOfSize:22];
        titleLbl.textColor = UIColor.whiteColor;
        [box.contentView addSubview:titleLbl];

        // Message
        UILabel *msgLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, box.frame.size.width - 40, 60)];
        msgLbl.text = msg;
        msgLbl.numberOfLines = 0;
        msgLbl.textAlignment = NSTextAlignmentCenter;
        msgLbl.textColor = UIColor.whiteColor;
        msgLbl.font = [UIFont systemFontOfSize:16];
        [box.contentView addSubview:msgLbl];

        // Website button
        UIButton *webBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        webBtn.frame = CGRectMake(box.frame.size.width/2 - 110, 140, 100, 45);
        webBtn.layer.cornerRadius = 10;
        webBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        webBtn.layer.borderWidth = 1;
        webBtn.layer.borderColor = UIColor.systemPinkColor.CGColor;
        [webBtn setTitle:@"Website" forState:UIControlStateNormal];
        webBtn.tintColor = UIColor.systemPinkColor;
        [webBtn addTarget:self action:@selector(openWebsite) forControlEvents:UIControlEventTouchUpInside];
        [box.contentView addSubview:webBtn];

        // Close button
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(box.frame.size.width/2 + 10, 140, 100, 45);
        closeBtn.layer.cornerRadius = 10;
        closeBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        closeBtn.layer.borderWidth = 1;
        closeBtn.layer.borderColor = UIColor.redColor.CGColor;
        [closeBtn setTitle:@"Đóng" forState:UIControlStateNormal];
        closeBtn.tintColor = UIColor.redColor;
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [box.contentView addSubview:closeBtn];

        // Animate show
        box.transform = CGAffineTransformMakeScale(0.7, 0.7);
        box.alpha = 0;
        [UIView animateWithDuration:0.25
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:3
                            options:0
                         animations:^{
            box.alpha = 1;
            box.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    return self;
}

#pragma mark - Buttons
- (void)openWebsite {
    NSURL *url = [NSURL URLWithString:@"https://beacons.ai/manhyen"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)close {
    [UIView animateWithDuration:0.2 animations:^{
        glass.alpha = 0;
        glass.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.alpha = 0;
    } completion:^(BOOL f) {
        [self removeFromSuperview];
        [self showToast:@"Cảm ơn đã sử dụng!"];
    }];
}

#pragma mark - Toast
- (void)showToast:(NSString *)msg {
    UIWindow *key = UIApplication.sharedApplication.keyWindow;

    // Blur background
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *toast = [[UIVisualEffectView alloc] initWithEffect:blur];
    toast.layer.cornerRadius = 20;
    toast.layer.masksToBounds = YES;

    // Glow viền nhẹ
    toast.layer.borderWidth = 1.2;
    toast.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.15].CGColor;
    toast.layer.shadowColor = UIColor.blackColor.CGColor;
    toast.layer.shadowOpacity = 0.25;
    toast.layer.shadowRadius = 10;
    toast.layer.shadowOffset = CGSizeZero;

    // Icon
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_icon"]];
icon.tintColor = UIColor.greenColor;
    icon.tintColor = UIColor.systemGreenColor;
    icon.frame = CGRectMake(15, 15, 28, 28);
    [toast.contentView addSubview:icon];

    // Label
    UILabel *label = [[UILabel alloc] init];
    label.text = msg;
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 0;

    CGSize textSize = [label sizeThatFits:CGSizeMake(key.frame.size.width - 120, CGFLOAT_MAX)];
    label.frame = CGRectMake(55, 15, textSize.width, textSize.height);
    [toast.contentView addSubview:label];

    // Toast size
    toast.frame = CGRectMake(
        30,
        key.frame.size.height - (textSize.height + 120),
        textSize.width + 55 + 20,
        textSize.height + 30
    );

    toast.alpha = 0;
    toast.transform = CGAffineTransformMakeScale(0.85, 0.85);

    [key addSubview:toast];

    // Show animation
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:3
                        options:0
                     animations:^{
        toast.alpha = 1;
        toast.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // Hide animation
        [UIView animateWithDuration:0.3
                              delay:2
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            toast.alpha = 0;
            toast.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished2) {
            [toast removeFromSuperview];
        }];
    }];
}

@end

__attribute__((constructor))
static void showAlertAfterLaunch() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        GlassAlert *alert = [[GlassAlert alloc] initWithTitle:@"Khổng Mạnh Yên 👑"
                                                      message:@"Inbox thì cứ thêm vài từ *Mình sẽ trả phí* là được 😆"];

        [[UIApplication sharedApplication].keyWindow addSubview:alert];
    });
}
