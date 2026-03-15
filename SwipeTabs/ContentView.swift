//
//  ContentView.swift
//  SwipeTabs
//
//  Created by Dom Montalto on 14/3/2026.
//

import SwiftUI

struct ColorTab { let title: String; let color: Color }

extension EnvironmentValues {
    @Entry var widgetColor: Color = .accentColor
}

// MARK: - Root

struct ContentView: View {
    @State private var showMenu = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                Tab("", systemImage: "house") { HomeView() }
                Tab("", systemImage: "plus.circle") {}.disabled(true)
                Tab("", systemImage: "book") {
                    NavigationStack {
                        JournalContent().refreshable {}.navigationTitle("Journal")
                    }
                }
            }
            
            HStack(spacing: 0) {
                Color.clear
                Button { showMenu = true } label: { Color.clear }
                Color.clear
            }
            .frame(height: 83)
        }
        .sheet(isPresented: $showMenu) { MenuSheet() }
    }
}

// MARK: - Menu Sheet

struct MenuSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("")
                .navigationTitle("Menu")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { dismiss() } label: { Image(systemName: "xmark") }
                    }
                }
        }
    }
}

// MARK: - Swipeable Page View

struct SwipePageView<Content: View>: View {
    let pages: [ColorTab]
    let content: (Int) -> Content
    
    init(pages: [ColorTab], @ViewBuilder content: @escaping (Int) -> Content) {
        self.pages = pages
        self.content = content
    }
    
    @State private var selected: Int? = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var containerWidth: CGFloat = 1
    @State private var textWidths: [Int: CGFloat] = [:]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(pages.indices, id: \.self) { i in
                    ScrollView {
                        content(i)
                    }
                    .refreshable {}
                    .containerRelativeFrame(.horizontal)
                    .environment(\.widgetColor, pages[i].color)
                    .id(i)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $selected)
        .scrollIndicators(.hidden)
        .onScrollGeometryChange(for: CGFloat.self) { $0.contentOffset.x } action: { _, new in
            scrollOffset = new
        }
        .onScrollGeometryChange(for: CGFloat.self) { $0.containerSize.width } action: { _, new in
            containerWidth = new
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(pages.indices, id: \.self) { i in
                        Button { withAnimation { selected = i } } label: {
                            Text(pages[i].title)
                                .font(.body)
                                .foregroundStyle(selected == i ? .primary : .secondary)
                                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { textWidths[i] = $0 }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    GeometryReader { geo in
                        let tabCellWidth = geo.size.width / CGFloat(pages.count)
                        let progress = scrollOffset / containerWidth
                        let leftIdx = max(0, min(pages.count - 2, Int(progress)))
                        let fraction = progress - CGFloat(leftIdx)
                        let leftW = textWidths[leftIdx] ?? tabCellWidth
                        let rightW = textWidths[min(leftIdx + 1, pages.count - 1)] ?? tabCellWidth
                        let indicatorWidth = leftW + (rightW - leftW) * fraction
                        let leftCenter = tabCellWidth * CGFloat(leftIdx) + tabCellWidth / 2
                        let rightCenter = tabCellWidth * CGFloat(leftIdx + 1) + tabCellWidth / 2
                        let centerX = leftCenter + (rightCenter - leftCenter) * fraction
                        Color.primary
                            .frame(width: indicatorWidth, height: 2)
                            .clipShape(Capsule())
                            .offset(x: centerX - indicatorWidth / 2)
                    }
                    .frame(height: 2)
                }
                .padding(.horizontal, 90)
                Divider()
            }
            .background(.ultraThinMaterial)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
}

// MARK: - Home

struct HomeView: View {
    @State private var navigateToHeart = false
    
    var body: some View {
        NavigationStack {
            SwipePageView(pages: [
                ColorTab(title: "Health",  color: .red),
                ColorTab(title: "Insight", color: .purple),
                ColorTab(title: "Food",    color: .teal)
            ]) { i in
                switch i {
                case 0:  HealthContent(onTap: { navigateToHeart = true })
                case 1:  InsightContent()
                default: FoodContent()
                }
            }
            .navigationTitle("Health")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToHeart) { TabsView() }
        }
    }
}

// MARK: - Heart

struct TabsView: View {
    @State private var showInfo = false
    
    var body: some View {
        SwipePageView(pages: [
            ColorTab(title: "Heart",   color: .pink),
            ColorTab(title: "Data",    color: .indigo),
            ColorTab(title: "Summary", color: .mint)
        ]) { i in
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
                Button { showInfo = true } label: { Image(systemName: "info.circle") }
            }
        }
        .sheet(isPresented: $showInfo) { InfoSheet() }
    }
}

// MARK: - Heart Info Sheet

struct InfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView { InfoContent() }
                .environment(\.widgetColor, .indigo)
                .navigationTitle("Info")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
    }
}
