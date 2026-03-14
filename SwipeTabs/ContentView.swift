//
//  ContentView.swift
//  SwipeTabs
//
//  Created by Dom Montalto on 14/3/2026.
//

import SwiftUI

struct ColorTab {
    let title: String
    let color: Color
}

// MARK: - Page Color Environment

private struct PageColorKey: EnvironmentKey {
    static let defaultValue: Color = .accentColor
}

extension EnvironmentValues {
    var pageColor: Color {
        get { self[PageColorKey.self] }
        set { self[PageColorKey.self] = newValue }
    }
}

// MARK: - Root

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("", systemImage: "house") {
                HomeView()
            }
            Tab("", systemImage: "plus.circle") {
                PlusView()
            }
            Tab("", systemImage: "book") {
                JournalView()
            }
        }
    }
}

// MARK: - Plus

struct PlusView: View {
    var body: some View {
        NavigationStack {
            ScrollView {}
                .navigationTitle("New")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Journal

struct JournalView: View {
    var body: some View {
        NavigationStack {
            JournalContent()
                .navigationTitle("Journal")
        }
    }
}

// MARK: - Info Sheet

struct InfoSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                InfoContent()
            }
            .environment(\.pageColor, .indigo)
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .presentationBackground(Color.indigo.opacity(0.12))
    }
}

// MARK: - Swipeable Page View

struct SwipePageView<PageContent: View>: View {
    let pages: [ColorTab]
    let pageContent: (Int) -> PageContent

    init(pages: [ColorTab], @ViewBuilder pageContent: @escaping (Int) -> PageContent) {
        self.pages = pages
        self.pageContent = pageContent
    }

    @State private var selectedIndex: Int? = 0
    @Namespace private var tabNamespace

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(pages.indices, id: \.self) { i in
                    ScrollView {
                        pageContent(i)
                    }
                    .containerRelativeFrame(.horizontal)
                    .environment(\.pageColor, pages[i].color)
                    .id(i)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $selectedIndex)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, spacing: 0) {
            tabBar
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(pages.indices, id: \.self) { i in
                Button {
                    withAnimation { selectedIndex = i }
                } label: {
                    VStack(spacing: 4) {
                        Text(pages[i].title)
                            .font(.system(size: 15, weight: selectedIndex == i ? .semibold : .regular))
                            .foregroundColor(selectedIndex == i ? pages[i].color : .secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)

                        if selectedIndex == i {
                            pages[i].color
                                .frame(height: 3)
                                .clipShape(Capsule())
                                .matchedGeometryEffect(id: "indicator", in: tabNamespace)
                        } else {
                            Color.clear.frame(height: 3)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) { Divider() }
    }
}

// MARK: - Home

struct HomeView: View {
    @State private var navigateToHeart = false

    private let pages: [ColorTab] = [
        ColorTab(title: "Health",  color: .red),
        ColorTab(title: "Insight", color: .purple),
        ColorTab(title: "Food",    color: .teal)
    ]

    var body: some View {
        NavigationStack {
            SwipePageView(pages: pages) { i in
                switch i {
                case 0:  HealthContent(onTap: { navigateToHeart = true })
                case 1:  InsightContent()
                default: FoodContent()
                }
            }
            .navigationTitle("Health")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToHeart) {
                TabsView()
            }
        }
    }
}

// MARK: - Tabs (Heart)

struct TabsView: View {
    @State private var showInfo = false

    private let pages: [ColorTab] = [
        ColorTab(title: "Heart",   color: .pink),
        ColorTab(title: "Data",    color: .indigo),
        ColorTab(title: "Summary", color: .mint)
    ]

    var body: some View {
        SwipePageView(pages: pages) { i in
            switch i {
            case 0:  HeartRateContent()
            case 1:  OxygenContent()
            default: HRVContent()
            }
        }
        .navigationTitle("Heart")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showInfo = true } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showInfo) { InfoSheet() }
    }
}

#Preview {
    ContentView()
}
