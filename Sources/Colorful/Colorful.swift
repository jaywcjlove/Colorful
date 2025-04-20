// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


class ColorfulModel: ObservableObject {
    @Published var showsAlpha: Bool = true
}

public struct Colorful: View {
    @ObservedObject var viewModel: ColorfulModel = .init()
    @Binding var hue: CGFloat
    @Binding var saturation: CGFloat
    @Binding var brightness: CGFloat
    @Binding var alpha: CGFloat
    public init(
        hue: Binding<CGFloat>,
        saturation: Binding<CGFloat>,
        brightness: Binding<CGFloat>,
        alpha: Binding<CGFloat>,
    ) {
        self._saturation = saturation
        self._brightness = brightness
        self._hue = hue
        self._alpha = alpha
    }
    public var body: some View {
        VStack(spacing: 0) {
            Saturation(
                saturation: $saturation,
                brightness: $brightness,
                hue: hue
            )
            .zIndex(2)
            HueSlider(hue: $hue)
                .bottomLeadingRadius(viewModel.showsAlpha == true ? 0 : 8)
                .bottomTrailingRadius(viewModel.showsAlpha == true ? 0 : 8)
            if viewModel.showsAlpha == true {
                AlphaSlider(
                    alpha: $alpha,
                    hue: hue,
                    saturation: saturation,
                    brightness: brightness
                )
            }
        }
    }
    public func showsAlpha(_ value: Bool) -> Colorful {
        viewModel.showsAlpha = value
        return self as Colorful
    }
    public func showsAlpha(_ value: Binding<Bool>) -> Colorful {
        viewModel.showsAlpha = value.wrappedValue
        return self as Colorful
    }
}


#Preview {
    @Previewable @State var hue: CGFloat = 0.21
    @Previewable @State var saturation: CGFloat = 0.81
    @Previewable @State var brightness: CGFloat = 0.70
    @Previewable @State var alpha: CGFloat = 0.8
    VStack {
        VStack(alignment: .leading) {
            Text("hue: \(String(format: "%.2f", hue))")
            Text("saturation: \(String(format: "%.2f", saturation))")
            Text("brightness: \(String(format: "%.2f", brightness))")
            Text("alpha: \(String(format: "%.2f", alpha))")
        }
        .padding(.top)
        
        HStack {
            Colorful(
                hue: $hue,
                saturation: $saturation,
                brightness: $brightness,
                alpha: $alpha,
            )
            .frame(width: 200, height: 200)
            
            Colorful(
                hue: $hue,
                saturation: $saturation,
                brightness: $brightness,
                alpha: $alpha,
            )
            .showsAlpha(false)
            .frame(width: 200, height: 200)
        }
    }
    .padding()
}

