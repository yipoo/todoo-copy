//
//  WelcomeView.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }

                    Spacer()
                }
                .padding(.top, 50)

                VStack(alignment: .leading, spacing: 16) {
                    Text("欢迎使用 Todoo！")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    Text("如果你是第一次使用 Todoo。")
                        .font(.system(size: 17))
                        .foregroundColor(.white)

                    Text("这个软件可以帮你记录生活中的琐事、或者安排事项。")
                        .font(.system(size: 17))
                        .foregroundColor(.white)

                    Text("你只需要在输入框使用「语音、图片或文字」来添加记忆。")
                        .font(.system(size: 17))
                        .foregroundColor(.white)

                    Text("软件会 自动提取图像中的文字、理解并润色你说的话、提取提到的事项，并按照事项发生的时间 发送通知 给你。")
                        .font(.system(size: 17))
                        .foregroundColor(.white)

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    Text("听起来有点麻烦？")
                        .font(.system(size: 17))
                        .foregroundColor(.white)

                    Text("哈哈，麻烦是我们的。")
                        .font(.system(size: 17))
                        .foregroundColor(.white)

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    Text("你需要的只有「创建记忆」。")
                        .font(.system(size: 17))
                        .foregroundColor(.white)

                    Text("剩下的请都交给 Todoo！")
                        .font(.system(size: 17))
                        .foregroundColor(.white)

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    Text("PS1：界面我就不介绍了，如果你看不懂欢迎联系我，是我设计的有问题，我觉得好的设计应该无需介绍！")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Text("PS2：有什么其他的产品建议、或者想联系我，可以随时在微博找我！")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 40)

                Button(action: { dismiss() }) {
                    Text("开始使用")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal)
        }
        .background(Color.black)
    }
}

#Preview {
    WelcomeView()
}
