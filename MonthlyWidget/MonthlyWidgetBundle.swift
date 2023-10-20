//
//  MonthlyWidgetBundle.swift
//  MonthlyWidget
//
//  Created by Joel Storr on 15.10.23.
//

import WidgetKit
import SwiftUI


@main
struct MonthlyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MonthlyWidget()
        MonthlyWidgetLiveActivity()
    }
}
