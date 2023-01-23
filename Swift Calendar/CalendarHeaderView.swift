//
//  CalendarHeaderView.swift
//  Swift Calendar
//
//  Created by Nizami Tagiyev on 23.01.2023.
//

import SwiftUI

struct CalendarHeaderView: View {
    private let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
    var font: Font = .body
    
    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(font)
                    .fontWeight(.black)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView()
    }
}
