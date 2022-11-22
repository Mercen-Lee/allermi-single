/// Allermi App Controller
/// Created by Mercen on 2022/11/03.

import SwiftUI
import ResponderChain

@main
struct AllermiApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .withResponderChainForCurrentWindow()
        }
    }
}
