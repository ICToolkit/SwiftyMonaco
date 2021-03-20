# SwiftyMonaco

SwiftyMonaco is a wrapper for Monaco Editor from Microsoft.

## Planned features
- [ ] Syntax highlighting modifiers
- [ ] Theme update synchronization with system theme change

## How to use?
There is a simple example of how to use `SwiftyMonaco`
```swift
import SwiftUI

struct EditorView: View {
    @State var text: String
    
    var body: some View {
        SwiftyMonaco(text: $text)
    }
}
```
