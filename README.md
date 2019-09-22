# LabelMaker

A wrapper for UILabel to set rich text, use like masonry.

# Usage

```objc
[self.label jx_make:^(JXTextMaker * _Nonnull make) {
	make.text(@"start").font(15).color([UIColor blackColor]);
	make.text(@"182 6193 2918").font(15).color([UIColor redColor]).tap(@selector(clickPhoneNumber:));
	make.text(@"end").font(15).color([UIColor blackColor]);
}];
```
