//
//  DelayedLaunchView.swift
//  shonre
//
//  Created by Александр Шендрик on 13.10.2021.
//

import SwiftUI

struct DelayedLaunchView: View {
    @EnvironmentObject var DS : DataStorage
    @Binding var isPresented : Bool
    @State var selected : DelayTypes = DelayTypes.data[0]
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    isPresented = false
                }){
                    Text("Cancel").font(.system(size: 16, weight: .medium))
                }
                Spacer()
                Text("Sensitivy").font(.system(size: 20, weight: .medium))
                Spacer()
                Button(action: {
                    isPresented = false
                    DS.soundAnalyzer.delayLaunch(delayType: selected)
                }){
                    Text("Done").font(.system(size: 16, weight: .medium))
                }
            }.foregroundColor(.white).padding().background(Color("MixerColor").ignoresSafeArea())
            
            VStack(alignment: .leading){
                ForEach(DelayTypes.data) { delay in
                    Button(action: {
                        selected = delay
                    }){
                        HStack{
                            Text(delay.title).font(.system(size: 16)).foregroundColor(.white)
                            Spacer()
                            if selected.length == delay.length {
                                Image("redcheck")
                            }
                        }.padding(.horizontal)
                    }
                    Divider()
                }
            }
            Spacer()
        }.background(Color("NavBack").ignoresSafeArea()).onAppear(perform: {
            if DS.soundAnalyzer.delayType != nil {
                selected = DS.soundAnalyzer.delayType!
            } else {
                selected = DelayTypes.data[0]
            }
        })
    }
}

struct DelayedLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        DelayedLaunchView(isPresented: .constant(true))
    }
}

struct DelayTypes: Identifiable {
    var id = UUID()
    var title : LocalizedStringKey
    var length : Double
}

extension DelayTypes {
    static var data : [DelayTypes] = [DelayTypes(title: "off", length: 0),
                                      DelayTypes(title: "5 minutes", length: 5 * 60),
                                      DelayTypes(title: "10 minutes", length: 10 * 60),
                                      DelayTypes(title: "15 minutes", length: 15 * 60),
                                      DelayTypes(title: "20 minutes", length: 20 * 60),
                                      DelayTypes(title: "30 minutes", length: 30 * 60),
                                      DelayTypes(title: "45 minutes", length: 45 * 60),
                                      DelayTypes(title: "1 hour", length: 1 * 60 * 60),
                                      DelayTypes(title: "2 hour", length: 2 * 60 * 60),
                                      DelayTypes(title: "3 hour", length: 3 * 60 * 60),
    ]
}
