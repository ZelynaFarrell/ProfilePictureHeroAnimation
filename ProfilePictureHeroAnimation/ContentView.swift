//
//  ContentView.swift
//  ProfilePictureHeroAnimation
//
//  Created by Zelyna Sillas on 7/3/24.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State var selectedItem: PhotosPickerItem? = nil
    @State var profilePicture: UIImage? = nil
    @State var showPicker: Bool = false
    @State var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: isExpanded ? .leading : .center) {
                if let picture = profilePicture {
                    ProfilePictureView(isExpanded: $isExpanded, profilePicture: picture)
                } else {
                    PlaceholderImageView(isExpanded: $isExpanded, showPicker: $showPicker)
                }
                
                ProfileBioView(isExpanded: $isExpanded)
                
                Rectangle()
                    .frame(height: 1)
                    .opacity(isExpanded ? 0 : 0.25)
                
                HStack(spacing: 12) {
                    MessageButton(title: "Message", icon: "message") {}
                    ConnectIconButton(icon: "phone", action: {})
                    ConnectIconButton(icon: "video", action: {})
                }
                .padding(.top, isExpanded ? 0 : 20)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.horizontal, isExpanded ? 0 : 10)
            .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            if profilePicture != nil {
                Button {
                    showPicker.toggle()
                } label: {
                    Image(systemName: "photo")
                        .frame(width: 23, height: 23)
                        .padding(10)
                        .background(Color(.systemGray5), in: .circle)
                        .foregroundStyle(.white)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .bottomLeading, endPoint: .topTrailing))
                        }
                }
                .padding(.trailing, 24)
                .opacity(isExpanded ? 0 : 1)
                .offset(y: isExpanded ? -100 : 0)
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                    withAnimation {
                        profilePicture = uiImage
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct PlaceholderImageView: View {
    @Binding var isExpanded: Bool
    @Binding var showPicker: Bool
    
    var body: some View {
        Image(systemName: "person.fill")
            .frame(width: 110, height: 110)
            .font(.largeTitle)
            .foregroundStyle(.white)
            .background(.ultraThinMaterial, in: Circle())
            .padding(.top, isExpanded ? 0 : 80)
            .onTapGesture {
                showPicker.toggle()
            }
    }
}

//#Preview {
//   PlaceholderImageView()
//}

struct ProfilePictureView: View {
    @Binding var isExpanded: Bool
    var profilePicture: UIImage
    
    var body: some View {
        GeometryReader { geo in
            Image(uiImage: profilePicture)
                .resizable()
                .scaledToFill()
                .frame(width: isExpanded ? geo.size.width : 110, height: isExpanded ? 320 : 110)
                .clipShape(.rect(cornerRadius: isExpanded ? 0 : 100))
                .padding(.top, isExpanded ? 0 : 80)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isExpanded.toggle()
                    }
                }
        }
        .frame(maxWidth: isExpanded ? .infinity : 110, maxHeight: isExpanded ? 240 : 190)
    }
}

//#Preview {
//    ProfilePictureView()
//}

struct ProfileBioView: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: isExpanded ? .leading : .center) {
            Text("Zelyna Farrell")
                .font(.largeTitle)
                .fontWeight(isExpanded ? .black : .bold)
                .foregroundStyle(.white)
            
            Text("iOS Developer")
                .foregroundStyle(isExpanded ? .white : .gray)
        }
        .padding(.leading, isExpanded ? 24 : 0)
    }
}

//#Preview {
//    ProfileBioView()
//}

struct MessageButton: View {
    var title: String
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label(title, systemImage: icon)
                .font(.title3).bold()
                .foregroundStyle(.black)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(.white, in: .rect(cornerRadius: 30))
        }
    }
}

//#Preview {
//    ConnectButton()
//}

struct ConnectIconButton: View {
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .imageScale(.large)
                .frame(width: 25, height: 25)
                .padding(10)
                .background(Color(.systemGray5), in: .circle)
                .foregroundStyle(.white)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .bottomLeading, endPoint: .topTrailing))
                }
        }
    }
}

//#Preview {
//    ConnectIconButton()
//}
