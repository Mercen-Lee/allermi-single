/// Settings View
/// Created by Mercen on 2022/11/19.

import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    
    /// State Variables
    @State private var selectedAllergy: [String] = [String]()
    
    /// Local Variables
    private var allergy: [String]? {
        return UserDefaults.standard.array(forKey: "allergy") as? [String]
    }
    
    var body: some View {
        SelectionView(selectedAllergy: $selectedAllergy)
            .onAppear {
                selectedAllergy = allergy ?? [String]()
            }
    }
}
