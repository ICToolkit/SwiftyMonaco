# SwiftyMonaco

SwiftyMonaco is a wrapper for Monaco Editor from Microsoft.

<img width="1012" alt="image" src="https://user-images.githubusercontent.com/17158860/111897521-60620800-8a31-11eb-9250-ec45b40e56cf.png">

# How to use?
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
## Syntax Highlighting
Also you can use `SwiftyMonaco` with syntax highlighting by passing `SyntaxHighlight` rule:
```swift
import SwiftUI

struct EditorView: View {
    @State var text: String
    
    var body: some View {
        SwiftyMonaco(text: $text)
            .syntaxHighlight(.systemVerilog)
    }
}
```
### Default `SyntaxHighlight`s
| `SyntaxHighlight` | Language |
| --- | --- |
| `.swift` | Swift |
| `.cpp` | C++ |
| `.systemVerilog` | Verilog/SystemVerilog |

### How to create your own `SyntaxHighlight`?
To create your own `SyntaxHighlight` you can use available initializers:
```swift
// With JS file containing syntax definition for Monarch
let syntax = SyntaxHighlight(title: "My custom language", fileURL: Bundle.module.url(forResource: "lang", withExtension: "js", subdirectory: "Languages")!)
// With a String containing syntax definition for Monarch
let syntax = SyntaxHighlight(title: "My custom language", configuration: "...")
```
You can create your own syntax at [Monaco Editor Monarch](https://microsoft.github.io/monaco-editor/monarch.html) website

# Interface theme detection
`SwiftyMonaco` automatically detects interface theme changes and updates Monaco Editor theme according to it without dropping the current state of the editor.
<img width="1012" alt="image" src="https://user-images.githubusercontent.com/17158860/111897521-60620800-8a31-11eb-9250-ec45b40e56cf.png">
<img width="1012" alt="image" src="https://user-images.githubusercontent.com/17158860/111897745-b7b4a800-8a32-11eb-8783-d21d96b4cc10.png">
