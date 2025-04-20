//
//  HueSlider.swift
//  Colorful
//
//  Created by wong on 4/20/25.
//

import SwiftUI

public struct HueSlider: View {
    @ObservedObject var viewModel: AlphaSliderModel = .init()
    @ObservedObject var rounded: UnevenRoundedModel = .init(
        topLeadingRadius: 0,
        topTrailingRadius: 0,
        bottomLeadingRadius: 0,
        bottomTrailingRadius: 0
    )
    @Binding var hue: CGFloat // 色相 (0.0 到 1.0)
    public init(hue: Binding<CGFloat>) {
        self._hue = hue
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 色相渐变条
                UnevenRoundedRectangle(
                    topLeadingRadius: rounded.topLeadingRadius,
                    bottomLeadingRadius: rounded.bottomTrailingRadius,
                    bottomTrailingRadius: rounded.bottomTrailingRadius,
                    topTrailingRadius: rounded.topTrailingRadius
                )
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hue: 0.0, saturation: 1, brightness: 1), // 红
                            Color(hue: 0.167, saturation: 1, brightness: 1), // 橙
                            Color(hue: 0.333, saturation: 1, brightness: 1), // 黄
                            Color(hue: 0.5, saturation: 1, brightness: 1), // 绿
                            Color(hue: 0.667, saturation: 1, brightness: 1), // 青
                            Color(hue: 0.833, saturation: 1, brightness: 1), // 蓝
                            Color(hue: 1.0, saturation: 1, brightness: 1) // 紫/红
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: rounded.topLeadingRadius,
                        bottomLeadingRadius: rounded.bottomTrailingRadius,
                        bottomTrailingRadius: rounded.bottomTrailingRadius,
                        topTrailingRadius: rounded.topTrailingRadius
                    )
                )

                // 指示器
                Circle()
                    .fill(Color(hue: hue, saturation: 1, brightness: 1))
                    .frame(width: viewModel.pointSize.width, height: viewModel.pointSize.height)
                    .overlay(Circle().stroke(Color.secondary.opacity(0.37), lineWidth: 4))
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .position(
                        x: hue * geometry.size.width,
                        y: geometry.size.height / 2
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // 将触摸位置映射到色相
                        let x = value.location.x
                        let width = geometry.size.width
                        hue = min(max(x / width, 0), 1) // 限制在 0.0 到 1.0
                    }
            )
        }
        .frame(height: viewModel.pointSize.height) // 固定高度，宽度自适应
    }
    public func topLeadingRadius(_ value: CGFloat) -> HueSlider {
        rounded.topLeadingRadius = value
        return self as HueSlider
    }
    public func topTrailingRadius(_ value: CGFloat) -> HueSlider {
        rounded.topTrailingRadius = value
        return self as HueSlider
    }
    public func bottomLeadingRadius(_ value: CGFloat) -> HueSlider {
        rounded.bottomLeadingRadius = value
        return self as HueSlider
    }
    public func bottomTrailingRadius(_ value: CGFloat) -> HueSlider {
        rounded.bottomTrailingRadius = value
        return self as HueSlider
    }
}


#Preview {
    @Previewable @State var hue: CGFloat = 1
    HueSlider(hue: $hue)
        .frame(width: 200)
        .padding()
}
