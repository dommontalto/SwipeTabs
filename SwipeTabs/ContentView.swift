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
    var body: some View {
        TabView {
            Tab("", systemImage: "house") { HomeView() }
            Tab("", systemImage: "plus.circle") {
                NavigationStack {
                    ScrollView {}.navigationTitle("Menu")
                }
            }
            Tab("", systemImage: "book") {
                NavigationStack {
                    JournalContent().refreshable {}.navigationTitle("Journal")
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
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(pages.indices, id: \.self) { i in
                    Button { withAnimation { selected = i } } label: {
                        Text(pages[i].title)
                            .foregroundStyle(selected == i ? .primary : .secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .overlay(alignment: .bottomLeading) {
                GeometryReader { geo in
                    let tabWidth = geo.size.width / CGFloat(pages.count)
                    Color.primary
                        .frame(width: tabWidth, height: 2)
                        .clipShape(Capsule())
                        .offset(x: scrollOffset / CGFloat(pages.count))
                }
                .frame(height: 2)
            }
            .background(.ultraThinMaterial)
            .overlay(alignment: .bottom) { Divider() }
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
