//
//  ResultsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct ResultsView: View {
    var body: some View {
        VStack{
            HStack{
                Text("Monday,02.09.2021").font(.system(size: 19, weight: .medium)).foregroundColor(.white)
                Spacer()
            }.padding(.horizontal)
            RecordListComponent()
            Spacer()
            HStack{
                Spacer()
            }
        }.background(Color("Back").ignoresSafeArea())
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
