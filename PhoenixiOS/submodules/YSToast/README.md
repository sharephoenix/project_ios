# YSToast
iOS Toast version: 1.0.1

## 居中调用方法

```swift
YSToast.instance.showToast("this is my toast")
```

## 自定义 View

```swift
// 自定义 View
class CustomToastLabel: UILabel, YSToastProtocol {
    func ys_view() -> UIView {
        return self
    }
    
    func ys_direction() -> YSToast.Direction {
        return .RC
    }
    
    func ys_size() -> CGSize {
        return CGSize(width: 200, height: 33)
    }
   
    func ys_offset() -> UIOffset {
       return UIOffset(horizontal: 0, vertical: 0)
    }
   
    func ys_parentView() -> UIView? {
        return UIApplication.shared.windows.last
    }
}

// 实现方法
let customView = CustomToastLabel()
customView.text = "this is my test tittle"
YSToast.instance.showAsyncView(customView)
```