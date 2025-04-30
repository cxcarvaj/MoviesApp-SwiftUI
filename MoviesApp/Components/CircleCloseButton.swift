//
//  CircleCloseButton.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 30/4/25.
//


import SwiftUI
 
 fileprivate struct CircleCloseButton: ViewModifier {
     let action: () -> Void
     
     func body(content: Content) -> some View {
         content
             .overlay(alignment: .topTrailing) {
                 Button {
                     action()
                 } label: {
                     Image(systemName: "xmark")
                         .symbolVariant(.circle.fill)
                 }
                 .buttonBorderShape(.circle)
                 #if os(iOS) || os(visionOS)
                 .hoverEffect(.highlight)
                 #endif
                 .font(.title)
                 .foregroundStyle(.white.opacity(0.5))
                 .padding(.trailing)
             }
     }
 }
 
 extension View {
     func circleCloseButton(action: @escaping () -> Void) -> some View {
         modifier(CircleCloseButton(action: action))
     }
 }