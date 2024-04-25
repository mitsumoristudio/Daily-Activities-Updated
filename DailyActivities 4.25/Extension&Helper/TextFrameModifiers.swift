//
//  TextFrameModifiers.swift
//  DailyActivities 4.25
//
//  Created by Satoshi Mitsumori on 4/25/24.
//

import Foundation
import SwiftUI


struct GradientIconButton: View {
    var icon: String
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)), Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .mask(Image(systemName: icon).font(.system(size: 17)))
            .background(Color(#colorLiteral(red: 0.1019607843, green: 0.07058823529, blue: 0.2431372549, alpha: 0.6004759934)))
            .frame(width: 40, height: 40)
            .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(lineWidth: 2)
                .foregroundColor(Color.white)
                .blendMode(.overlay))
    }
}

struct ChangeFrameSize: ViewModifier {
    func body(content: Content) -> some View {
        content
        
            .frame(width: 370, height: 80, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 20).stroke(Color(UIColor.systemGray2)))
            .background(.ultraThickMaterial).opacity(0.8)
            .foregroundColor(Color.black)
            .cornerRadius(20)
            .padding(.horizontal, 30)
            .shadow(radius: 5, x:5, y: 10)
    }
}

struct ChangeSmallerFrameSize: ViewModifier {
    func body(content: Content) -> some View {
        content
        
            .frame(width: 350, height: 80, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 20).stroke(Color(UIColor.systemGray2)))
            .background(.ultraThickMaterial).opacity(0.8)
            .foregroundColor(Color.black)
            .cornerRadius(20)
            .padding(.horizontal, 30)
            .shadow(radius: 5, x:5, y: 10)
    }
}

    struct fontModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(.vertical, 10)
                .padding(.horizontal, 5)
                .padding(.leading, 2)
                .foregroundColor(Color.white)
                .font(.headline)
            
        }
    }

struct TextFieldClearButton: ViewModifier {
    @Binding var nextText: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !nextText.isEmpty {
                Button(action: {self.nextText = ""}, label: {
                    Image(systemName: "delete.left.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color.gray)
                })
            }
        }
    }
}









