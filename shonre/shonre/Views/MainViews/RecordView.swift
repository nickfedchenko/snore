//
//  RecordView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var DS : DataStorage
    
    @State var isRecording : Bool = false
    @State var sec : Double = 0.0
    @State var secTime : String = "00:00"
    
    @State var day : String = ""
    @State var timeText : String = ""
    @State var showSensitivity : Bool = false
    @State var showDelayLounch : Bool = false
    
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            Spacer()
            Text("Sleep Control").font(.system(size: 30, weight: .medium)).foregroundColor(.white).padding(.vertical)
            
            ZStack{
                Image("RecordBack").resizable().aspectRatio(contentMode: .fit).frame(width: UIScreen.main.bounds.width)
                VStack{
                    Text(timeText).font(.system(size: 36, weight: .medium)).foregroundColor(.white)
                    Text(day).font(.system(size: 19, weight: .medium)).foregroundColor(.white)
                    
                    Button(action: {
                        if DS.soundAnalyzer.audioRecorder.isRecording {
                            DS.soundAnalyzer.stopRecording()
                        } else {
                            sec = 0.0
                            setSecTime()
                            DS.soundAnalyzer.startRecording()
                        }
                    }){
                        ZStack{
                            Image(isRecording ? "RecPause" : "RecPlay")
                            if isRecording {
                                Text(secTime).foregroundColor(.white).font(.system(size: 40, weight: .medium)).multilineTextAlignment(.center).frame(width: 200)
                            }
                        }
                    }.onReceive(DS.soundAnalyzer.audioRecorder.$isRecording, perform: {val in
                        self.isRecording = DS.soundAnalyzer.audioRecorder.isRecording
                    })
                    Spacer()
                }
            }.fixedSize()
            
            HStack{
                Button(action: {
                    showSensitivity = true
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 9).foregroundColor(Color("Plate")).frame(height: 71)
                        HStack{
                            Image("SenseRec")
                            Text("Sensitivity\nlevel").font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    showDelayLounch = true
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 9).foregroundColor(Color("Plate")).frame(height: 71)
                        HStack{
                            Image("DeleayRec")
                            Text("Delay\nactivation").font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                        }
                    }
                }
            }.frame(width: 283)
            
//            Button(action: {
//                
//            }){
//                ZStack{
//                    RoundedRectangle(cornerRadius: 9).foregroundColor(Color("Plate")).frame(width: 283, height: 71)
//                    HStack{
//                        Image("AlarmRec")
//                        Text("Alarm clock").font(.system(size: 14, weight: .medium)).foregroundColor(.white)
//                    }
//                }
//            }
            
            Spacer()
            HStack{
                Spacer()
            }
        }.background(Color("Back").ignoresSafeArea()).onReceive(timer, perform: {_ in
            sec += 0.05
            setTime()
            setSecTime()
        }).onAppear(perform: {
            setTime()
        }).sheet(isPresented: $showSensitivity, content: {
            SensitivyLevelView(senseLevel: DS.soundAnalyzer.senceLevel, isPresented: $showSensitivity)
        }).sheet(isPresented: $showDelayLounch, content: {
            DelayedLaunchView(isPresented: $showDelayLounch)
        })
    }
    
    func setTime() {
        let today = Date()
        let formatter1 = DateFormatter()
        let formatter2 = DateFormatter()
        formatter1.dateFormat = "HH:mm"
        formatter2.dateFormat = "EEEE"
        
        self.day = formatter1.string(from: today)
        self.timeText = formatter2.string(from: today)
    }
    
    func setSecTime() {
        let h = Int(sec) / 60
        let s = Int(sec) % 60
        secTime = h.get2simb() + ":" + s.get2simb()
    }
    
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}


extension Int {
    func get2simb() -> String {
        return self > 9 ? "\(self)" : "0\(self)"
    }
}
