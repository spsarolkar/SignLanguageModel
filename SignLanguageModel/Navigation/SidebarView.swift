import SwiftUI

struct SidebarView: View {
    @Binding var selection: NavigationItem?
    
    var body: some View {
        List(NavigationItem.allCases, selection: $selection) { item in
            NavigationLink(value: item) {
                Label(item.title, systemImage: item.icon)
            }
        }
        .navigationTitle("ISL Workbench")
    }
}
