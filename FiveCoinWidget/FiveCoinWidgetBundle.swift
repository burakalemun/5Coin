//
//  FiveCoinWidgetBundle.swift
//  FiveCoinWidget
//
//  Created by Burak Kaya on 17.05.2025.
//

import WidgetKit
import SwiftUI

@main
struct FiveCoinWidgetBundle: WidgetBundle {
    var body: some Widget {
        FiveCoinWidget()
        FiveCoinWidgetControl()
        FiveCoinWidgetLiveActivity()
    }
}
