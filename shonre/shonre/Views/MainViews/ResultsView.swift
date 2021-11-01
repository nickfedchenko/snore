//
//  ResultsView.swift
//  shonre
//
//  Created by Александр Шендрик on 01.10.2021.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var DS : DataStorage
    @State var sounds : [Sound] = [Sound]()
    
    @State var activeSound : SingleWaveSoundPlayer? = nil
    @State var isLinkActive : Bool = false
    
    @State var toDeleteSound : Sound?
    @State var toDelete : Bool = false
    @State var openSound : Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                        ForEach(sounds){ sound in
                            RecordListComponent(player: DS.soundAnalyzer.soundPlayer.getPlayer(for: sound), activeSound : $activeSound, isLinkActive : $isLinkActive, toDeleteSound : $toDeleteSound, toDelete: $toDelete)
                        }
                    if activeSound != nil {
                        NavigationLink(destination: SingleSoundView(player: activeSound!, isPresented: $isLinkActive), isActive: $isLinkActive){
                            EmptyView()
                        }
                    }
                    Spacer()
                    HStack{
                        Spacer()
                    }
                }.navigationBarTitle(isLinkActive ? "Results" : "", displayMode: .automatic).navigationBarHidden(true).background(Color("Back").ignoresSafeArea()).background(NavigationConfigurator { nc in
                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                })
                
                if toDelete {
                    ZStack(alignment: .center){
                        Rectangle().foregroundColor(.black.opacity(0.3))
                        ZStack{
                            RoundedRectangle(cornerRadius: 19).frame(width: 323, height: 212).foregroundColor(.white)
                            VStack{
                                Text("Are you sure you want to delete the entry?").frame(width: 220).multilineTextAlignment(.center).font(.system(size: 22, weight: .medium))
                                
                                Button(action: {
                                    if toDeleteSound != nil {
                                        DS.soundAnalyzer.deleteSound(sound: toDeleteSound!)
                                    }
                                    withAnimation{
                                        toDelete = false
                                    }
                                }){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 38).foregroundColor(Color("ButtonRed")).frame(width: 206, height: 47)
                                        Text("Yes").foregroundColor(.white)
                                    }
                                }
                                Button(action: {
                                    withAnimation{
                                        toDelete = false
                                    }
                                }){
                                    Text("Cancel").foregroundColor(Color("TextGray"))
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear(perform: {
            self.sounds = DS.soundAnalyzer.sounds
        }).onReceive(DS.soundAnalyzer.$sounds, perform: {val in
            self.sounds = val
        })
    }
    
    func removeRows(at offsets: IndexSet) {
//        numbers.remove(atOffsets: offsets)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
