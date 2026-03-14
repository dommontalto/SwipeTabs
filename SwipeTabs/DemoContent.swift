//
//  DemoContent.swift
//  SwipeTabs
//
//  Created by Dom Montalto on 14/3/2026.
//

import SwiftUI

// MARK: - Shared

private struct StatCard: View {
    @Environment(\.pageColor) private var pageColor

    let icon: String
    let title: String
    let value: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Text(value)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
            }
            Spacer()
        }
        .padding()
        .background(pageColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Health (tappable — any tap navigates to Heart)

struct HealthContent: View {
    var onTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            StatCard(icon: "figure.walk",   title: "Steps",      value: "8,432",      subtitle: "Goal: 10,000")
            StatCard(icon: "heart.fill",     title: "Heart Rate", value: "72 bpm",     subtitle: "Resting · Normal")
            StatCard(icon: "moon.fill",      title: "Sleep",      value: "7h 24m",     subtitle: "Last night · Good")
            StatCard(icon: "scalemass.fill", title: "Weight",     value: "74.5 kg",    subtitle: "↓ 0.3 kg this week")
            StatCard(icon: "flame.fill",     title: "Calories",   value: "1,840 kcal", subtitle: "Active · 2,400 goal")
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Insight (tappable)

struct InsightContent: View {
    var onTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            StatCard(icon: "chart.line.uptrend.xyaxis", title: "Weekly Avg Steps", value: "7,910",    subtitle: "↑ 12% from last week")
            StatCard(icon: "bed.double.fill",           title: "Sleep Trend",      value: "7h 10m",   subtitle: "Improving over 30 days")
            StatCard(icon: "bolt.heart.fill",           title: "Readiness",        value: "84 / 100", subtitle: "High · Great day to train")
            StatCard(icon: "waveform.path.ecg",         title: "HRV Average",      value: "52 ms",    subtitle: "Above your baseline")
            StatCard(icon: "figure.run",                title: "Active Days",      value: "5 / 7",    subtitle: "This week")
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Food (tappable)

struct FoodContent: View {
    var onTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            StatCard(icon: "fork.knife",         title: "Calories Today", value: "1,480 kcal", subtitle: "920 remaining")
            StatCard(icon: "drop.fill",          title: "Water",          value: "1.8 L",      subtitle: "Goal: 2.5 L")
            StatCard(icon: "leaf.fill",          title: "Protein",        value: "98 g",       subtitle: "Goal: 120 g")
            StatCard(icon: "birthday.cake.fill", title: "Carbs",          value: "162 g",      subtitle: "Goal: 200 g")
            StatCard(icon: "fish.fill",          title: "Fat",            value: "54 g",       subtitle: "Goal: 65 g")
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Heart · Heart tab

struct HeartRateContent: View {
    var body: some View {
        VStack(spacing: 12) {
            StatCard(icon: "heart.fill",            title: "Heart Rate",  value: "72 bpm",       subtitle: "Resting · Normal")
            StatCard(icon: "arrow.up.heart.fill",   title: "Max Today",   value: "141 bpm",      subtitle: "During workout")
            StatCard(icon: "arrow.down.heart.fill", title: "Min Today",   value: "58 bpm",       subtitle: "During sleep")
            StatCard(icon: "waveform.path.ecg",     title: "Last ECG",    value: "Sinus Rhythm", subtitle: "3 hours ago")
            StatCard(icon: "clock.fill",            title: "Zone 2 Time", value: "28 min",       subtitle: "Today")
        }
        .padding()
    }
}

// MARK: - Heart · Data tab

struct OxygenContent: View {
    var body: some View {
        VStack(spacing: 12) {
            StatCard(icon: "lungs.fill",                        title: "Blood Oxygen",   value: "98%",      subtitle: "SpO₂ · Normal")
            StatCard(icon: "wind",                              title: "Resp. Rate",     value: "14 / min", subtitle: "Resting · Normal")
            StatCard(icon: "gauge.with.dots.needle.67percent",  title: "VO₂ Max",        value: "47.3",     subtitle: "Good for your age")
            StatCard(icon: "moon.stars.fill",                   title: "Night SpO₂ Avg", value: "96%",      subtitle: "Last night")
            StatCard(icon: "exclamationmark.triangle.fill",     title: "Low Events",     value: "0",        subtitle: "No dips detected")
        }
        .padding()
    }
}

// MARK: - Heart · Summary tab

struct HRVContent: View {
    var body: some View {
        VStack(spacing: 12) {
            StatCard(icon: "waveform.path.ecg.rectangle.fill", title: "HRV",             value: "54 ms", subtitle: "Above baseline · Good")
            StatCard(icon: "chart.bar.fill",                   title: "7-Day HRV Avg",   value: "49 ms", subtitle: "Trending up")
            StatCard(icon: "brain.head.profile",               title: "Stress Score",    value: "Low",   subtitle: "Based on HRV & activity")
            StatCard(icon: "figure.yoga",                      title: "Recovery",        value: "87%",   subtitle: "Well recovered")
            StatCard(icon: "timer",                            title: "Parasympathetic", value: "High",  subtitle: "Resting state dominant")
        }
        .padding()
    }
}

// MARK: - Info

struct InfoContent: View {
    var body: some View {
        VStack(spacing: 12) {
            StatCard(icon: "app.fill",          title: "App",      value: "SwipeTabs", subtitle: "Version 1.0")
            StatCard(icon: "iphone",            title: "Platform", value: "iOS 26+",   subtitle: "SwiftUI · Native")
            StatCard(icon: "lock.shield.fill",  title: "Privacy",  value: "On-Device", subtitle: "No data leaves your phone")
            StatCard(icon: "heart.text.square", title: "Data",     value: "HealthKit", subtitle: "Read access only")
            StatCard(icon: "envelope.fill",     title: "Contact",  value: "Support",   subtitle: "help@example.com")
        }
        .padding()
    }
}

// MARK: - Journal

struct JournalContent: View {
    var body: some View {
        List {
            Section("Today") {
                JournalRow(time: "8:30 AM", text: "Felt energised after my morning run. HRV was high.")
                JournalRow(time: "1:15 PM", text: "Slight fatigue after lunch. Skipped the afternoon walk.")
            }
            Section("Yesterday") {
                JournalRow(time: "9:00 PM", text: "Good recovery day. Sleep score looks promising.")
                JournalRow(time: "6:45 AM", text: "Strong workout — hit a new step PR for the week.")
            }
        }
    }
}

private struct JournalRow: View {
    let time: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(time)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(text)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}
