#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static BOOL TVPL_IsTVProviderContext(UIView *view) {
    UIViewController *vc = view.nextResponder;
    int depth = 0;

    while (vc && depth++ < 20) {
        NSString *cls = NSStringFromClass([vc class]);
        NSString *title = vc.title ?: @"";
        NSString *accessibility = vc.view.accessibilityLabel ?: @"";

        NSString *context = [NSString stringWithFormat:@"%@ %@ %@",
                             cls.lowercaseString,
                             title.lowercaseString,
                             accessibility.lowercaseString];

        // English + Spanish identifiers/text commonly associated with TV Provider.
        NSArray *needles = @[
            @"tvprovider",
            @"tv provider",
            @"videosubscriber",
            @"video subscriber",
            @"subscriber",
            @"provider",
            @"proveedor",
            @"proveedor de tv"
        ];

        for (NSString *needle in needles) {
            if ([context containsString:needle]) {
                return YES;
            }
        }

        vc = (UIViewController *)vc.parentViewController;
        if (!vc) {
            UIResponder *r = vc.nextResponder;
            vc = [r isKindOfClass:UIViewController.class] ? (UIViewController *)r : nil;
        }
    }

    return NO;
}

%hook UIActivityIndicatorView

- (void)stopAnimating {
    if (TVPL_IsTVProviderContext(self)) {
        // Intentionally suppress the stop call so the TV Provider spinner
        // remains active while this screen is visible.
        if (!self.isAnimating) {
            [self startAnimating];
        }
        return;
    }

    %orig;
}

- (void)setHidden:(BOOL)hidden {
    if (TVPL_IsTVProviderContext(self) && hidden) {
        %orig(NO);
        if (!self.isAnimating) {
            [self startAnimating];
        }
        return;
    }

    %orig;
}

%end
