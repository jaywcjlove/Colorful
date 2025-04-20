//
//  AlphaSlider.swift
//  Colorful
//
//  Created by wong on 4/20/25.
//


import SwiftUI

class AlphaSliderModel: ObservableObject {
    @Published var pointSize: CGSize = .init(width: 28, height: 28)
}

public struct AlphaSlider: View {
    @ObservedObject var viewModel: AlphaSliderModel = .init()
    @ObservedObject var rounded: UnevenRoundedModel = .init(
        topLeadingRadius: 0,
        topTrailingRadius: 0,
        bottomLeadingRadius: 8,
        bottomTrailingRadius: 8
    )
    @Binding var alpha: CGFloat // 透明度 (0.0 到 1.0)
    var hue: CGFloat // 色相，用于显示渐变颜色
    var saturation: CGFloat // 饱和度，用于显示渐变颜色
    var brightness: CGFloat // 亮度，用于显示渐变颜色
    public init(
        alpha: Binding<CGFloat>,
        hue: CGFloat = 0,
        saturation: CGFloat = 1,
        brightness: CGFloat = 1,
    ) {
        self._alpha = alpha
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                UnevenRoundedRectangle(
                    topLeadingRadius: rounded.topLeadingRadius,
                    bottomLeadingRadius: rounded.bottomTrailingRadius,
                    bottomTrailingRadius: rounded.bottomTrailingRadius,
                    topTrailingRadius: rounded.topTrailingRadius
                )
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hue: hue, saturation: saturation, brightness: brightness, opacity: 0.0), // 透明
                            Color(hue: hue, saturation: saturation, brightness: brightness, opacity: 1.0) // 不透明
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .background(
                    // 添加棋盘格背景，增强透明效果
                    CheckerboardBackground(squareSize: 5)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: rounded.topLeadingRadius,
                                bottomLeadingRadius: rounded.bottomTrailingRadius,
                                bottomTrailingRadius: rounded.bottomTrailingRadius,
                                topTrailingRadius: rounded.topTrailingRadius
                            )
                        )
                        .opacity(0.45)
                )
                
                // 指示器
                Circle()
                    .fill(Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha))
                    .background(
                        CheckerboardBackground(squareSize: 5)
                            .clipShape(RoundedRectangle(cornerRadius: viewModel.pointSize.width))
                    )
                    .frame(width: viewModel.pointSize.width, height: viewModel.pointSize.height)
                    .overlay(Circle().stroke(Color.secondary.opacity(0.37), lineWidth: 4))
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .position(
                        x: alpha * geometry.size.width,
                        y: geometry.size.height / 2
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // 将触摸位置映射到透明度
                        let x = value.location.x
                        let width = geometry.size.width
                        alpha = min(max(x / width, 0), 1) // 限制在 0.0 到 1.0
                    }
            )
        }
        .frame(height: viewModel.pointSize.height) // 固定高度，宽度自适应
    }
}


// 棋盘格背景（增强透明效果）
struct CheckerboardBackground: View {
    var squareSize: CGFloat = 3
    var body: some View {
        Canvas { context, size in
            let rows = Int(size.height / squareSize) + 1
            let cols = Int(size.width / squareSize) + 1
            for row in 0..<rows {
                for col in 0..<cols {
                    let x = CGFloat(col) * squareSize
                    let y = CGFloat(row) * squareSize
                    let isEven = (row + col) % 2 == 0
                    let color = isEven ? Color(white: 0.9) : Color(white: 0.7)
                    context.fill(
                        Path(CGRect(x: x, y: y, width: squareSize, height: squareSize)),
                        with: .color(color)
                    )
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var saturation: CGFloat = 1.0
    @Previewable @State var brightness: CGFloat = 1.0
    @Previewable @State var hue: CGFloat = 0.0
    @Previewable @State var alpha: CGFloat = 0.65
    Text("\(alpha)")
    AlphaSlider(
        alpha: $alpha,
        hue: hue,
        saturation: saturation,
        brightness: brightness
    )
    .padding()
}
