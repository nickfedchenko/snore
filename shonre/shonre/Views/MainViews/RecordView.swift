//
//  RecordView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct RecordView: View {
    var body: some View {
        VStack{
            Spacer()
            Text("Sleep Control").font(.system(size: 30, weight: .medium)).foregroundColor(.white).padding(.vertical)
            ZStack{
                VStack{
                    Text("12:35").font(.system(size: 36, weight: .medium)).foregroundColor(.white)
                    Text("Monday").font(.system(size: 19, weight: .medium)).foregroundColor(.white)
                    Image("RecPlay")
                    Spacer()
                }
                Image("RecordBack").resizable().aspectRatio(contentMode: .fit).frame(width: UIScreen.main.bounds.width)
            }.fixedSize()
            
            HStack{
                Button(action: {}){
                    ZStack{
                        RoundedRectangle(cornerRadius: 9).foregroundColor(Color("Plate")).frame(height: 71)
                        HStack{
                            Image("SenseRec")
                            Text("Sensitivity\nlevel").font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                        }
                    }
                }
                Spacer()
                Button(action: {}){
                    ZStack{
                        RoundedRectangle(cornerRadius: 9).foregroundColor(Color("Plate")).frame(height: 71)
                        HStack{
                            Image("DeleayRec")
                            Text("Delay\nactivation").font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                        }
                    }
                }
            }.frame(width: 283)
            
            Button(action: {}){
                ZStack{
                    RoundedRectangle(cornerRadius: 9).foregroundColor(Color("Plate")).frame(width: 283, height: 71)
                    HStack{
                        Image("AlarmRec")
                        Text("Alarm clock").font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                    }
                }
            }
            
            Spacer()
            HStack{
                Spacer()
            }
        }.background(Color("Back").ignoresSafeArea())
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
