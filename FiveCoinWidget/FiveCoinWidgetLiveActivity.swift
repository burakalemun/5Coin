//
//  FiveCoinWidgetLiveActivity.swift
//  FiveCoinWidget
//
//  Created by Burak Kaya on 17.05.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FiveCoinWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FiveCoinWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FiveCoinWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FiveCoinWidgetAttributes {
    fileprivate static var preview: FiveCoinWidgetAttributes {
        FiveCoinWidgetAttributes(name: "World")
    }
}

extension FiveCoinWidgetAttributes.ContentState {
    fileprivate static var smiley: FiveCoinWidgetAttributes.ContentState {
        FiveCoinWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FiveCoinWidgetAttributes.ContentState {
         FiveCoinWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FiveCoinWidgetAttributes.preview) {
   FiveCoinWidgetLiveActivity()
} contentStates: {
    FiveCoinWidgetAttributes.ContentState.smiley
    FiveCoinWidgetAttributes.ContentState.starEyes
}
