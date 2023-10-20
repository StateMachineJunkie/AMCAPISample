//
//  ActivityIndicatorView.swift
//  AMCAPISample
//
//  Created by Michael Crawford on 10/20/23.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var body: some View {
        ProgressView("Fetching Movie Data ...")
            .progressViewStyle(.circular)
            .foregroundColor(.white)
            .tint(.white)
            .padding()
            .background(Color(white: 0.0, opacity: 0.5))
            .cornerRadius(10.0)
    }
}

struct FetchInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
