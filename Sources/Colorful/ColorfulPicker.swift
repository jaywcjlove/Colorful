//
//  ColorfulPicker.swift
//  Colorful
//
//  Created by wong on 4/20/25.
//


import SwiftUI

class ColorfulPickerModel: ObservableObject {
    @Published var showsAlpha: Bool = true
}

public struct ColorfulPicker: View {
    @ObservedObject var viewModel: ColorfulPickerModel = .init()
    @Binding var selection: Color?
    @State private var popover: Bool = false
    var title: LocalizedStringKey?
    var arrowEdge: Edge? = nil
    public init(_ title: LocalizedStringKey? = nil, selection: Binding<Color?>, arrowEdge: Edge? = nil) {
        self.title = title
        self.arrowEdge = arrowEdge
        self._selection = selection
    }
    
    @State private var saturation: CGFloat = 1.0
    @State private var brightness: CGFloat = 1.0
    @State private var hue: CGFloat = 0.0
    @State private var alpha: CGFloat = 1.0
    
    public var body: some View {
        HStack {
            if let title {
                Text(title)
                Spacer()
            }
            Button(action: {
                popover = true
            }, label: {
                ZStack {
                    if let selection, selection != .clear {
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(selection)
                            .frame(width: 38, height: 17)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2.5, style: .continuous).stroke(lineWidth: 1).opacity(0.25)
                            )
                            .background(
                                CheckerboardBackground(squareSize: 5)
                                    .opacity(0.25)
                            )
                            .mask(RoundedRectangle(cornerRadius: 2.5, style: .continuous))
                            .padding([.leading, .trailing], -5).padding([.top, .bottom], 2)
                    } else {
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(.white)
                            .frame(width: 38, height: 17)
                            .overlay(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 2.5, style: .continuous)
                                        .stroke(lineWidth: 1) .opacity(0.25)
                                    Rectangle()
                                        .fill(.red)
                                        .frame(height: 1)
                                        .rotationEffect(Angle(degrees: -22))
                                }
                            )
                            .mask(RoundedRectangle(cornerRadius: 2.5, style: .continuous))
                            .padding([.leading, .trailing], -5).padding([.top, .bottom], 2)
                    }
                }
            })
            .frame(width: 44, height: 23)
            .popover(isPresented: $popover, arrowEdge: arrowEdge) {
                ZStack {
                    Color(nsColor: NSColor.windowBackgroundColor).scaleEffect(1.5)
                    Colorful(
                        hue: $hue,
                        saturation: $saturation,
                        brightness: $brightness,
                        alpha: $alpha,
                    )
                    .showsAlpha($viewModel.showsAlpha)
                    .onChange(of: hue, initial: false, { old, val in
                        changeColor()
                    })
                    .onChange(of: brightness, initial: false, { old, val in
                        changeColor()
                    })
                    .onChange(of: saturation, initial: false, { old, val in
                        changeColor()
                    })
                    .onChange(of: alpha, initial: false, { old, val in
                        changeColor()
                    })
                }
                .frame(width: 200, height: 220)
                .padding()
                .onAppear() {
                    let selection = selection ?? Color.clear
                    hue = selection.hue
                    saturation = selection.saturation
                    brightness = selection.brightness
                    alpha = selection.alpha
                }
            }
        }
    }
    private func changeColor() {
        selection = Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    public func showsAlpha(_ value: Bool) -> ColorfulPicker {
        viewModel.showsAlpha = value
        return self as ColorfulPicker
    }
    public func showsAlpha(_ value: Binding<Bool>) -> ColorfulPicker {
        viewModel.showsAlpha = value.wrappedValue
        return self as ColorfulPicker
    }
}

#Preview {
    @Previewable @State var color: Color? = Color.blue
    @Previewable @State var colorClear: Color? = .clear
    ColorfulPicker("Color", selection: $color, arrowEdge: .bottom)
        .frame(width: 210)
        .padding()
    ColorfulPicker(selection: $color)
        .showsAlpha(false)
        .padding()
    ColorfulPicker(selection: $colorClear, arrowEdge: .top).padding()
    
    color.frame(width: 60, height: 30)
}
