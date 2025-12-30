//
//  SampleData.swift
//  Todoo
//
//  Created on 2025-12-30.
//

import Foundation

extension DataManager {
    func loadSampleData() {
        // Clear existing data
        memories = []
        reminders = []

        let calendar = Calendar.current
        let now = Date()

        // Sample Memory 1: 睡觉 (Sleep)
        let memory1 = Memory(
            title: "今天晚上 10 点睡觉",
            content: "今天晚上 10:00 睡觉。",
            category: "睡觉",
            createdAt: now,
            isPinned: true,
            color: .brown
        )
        memories.append(memory1)

        let reminder1 = Reminder(
            memoryID: memory1.id,
            title: "睡觉",
            remindTime: calendar.date(bySettingHour: 22, minute: 0, second: 0, of: now) ?? now
        )
        reminders.append(reminder1)

        // Sample Memory 2: 写代码 (Code)
        let memory2 = Memory(
            title: "今晚七点写代码",
            content: "今晚七点写代码",
            category: "写代码",
            createdAt: calendar.date(byAdding: .minute, value: -5, to: now) ?? now,
            color: .purple
        )
        memories.append(memory2)

        let reminder2 = Reminder(
            memoryID: memory2.id,
            title: "写代码",
            remindTime: calendar.date(bySettingHour: 18, minute: 40, second: 0, of: now) ?? now
        )
        reminders.append(reminder2)

        // Sample Memory 3: 内容概括 (Content Summary)
        let memory3 = Memory(
            title: "内容概括",
            content: "内容概括",
            category: "",
            createdAt: calendar.date(byAdding: .minute, value: -6, to: now) ?? now,
            color: .pink
        )
        memories.append(memory3)

        // Sample Memory 4: 跑步 (Running) - Past 30 days
        let past30DaysDate = calendar.date(byAdding: .day, value: -9, to: now) ?? now
        let memory4 = Memory(
            title: "今天下午五点跑步",
            content: "今天下午五点跑步",
            category: "跑步",
            createdAt: past30DaysDate,
            isPinned: true,
            color: .green
        )
        memories.append(memory4)

        // Sample Memory 5: Past 30 days
        let memory5 = Memory(
            title: "内容概括",
            content: "内容概括",
            category: "",
            createdAt: calendar.date(byAdding: .day, value: -9, to: now) ?? now,
            color: .brown
        )
        memories.append(memory5)

        // Sample Memory 6: November - 去北京
        let novemberDate = calendar.date(from: DateComponents(year: 2025, month: 11, day: 14, hour: 17, minute: 27)) ?? now
        let memory6 = Memory(
            title: "今晚出发前往北京",
            content: "今晚出发前往北京",
            category: "去北京",
            createdAt: novemberDate,
            color: .pink
        )
        memories.append(memory6)

        // Sample Memory 7: November - 待办事项清单
        let memory7 = Memory(
            title: "今日待办事项安排",
            content: "今日待办事项安排\n\n如果你是第一次使用 Todoo。\n\n这个软件可以帮你记录生活中的琐事、或者安排事项。\n\n你只需要在输入框使用「语音、图片或文字」来添加记忆。\n\n软件会 自动提取图像中的文字、理解并润色你说的话、提取提到的事项，并按照事项发生的时间 发送通知 给你。\n\n听起来有点麻烦？\n哈哈，麻烦是我们的。\n\n你需要的只有「创建记忆」。\n\n剩下的请都交给 Todoo！\n\nPS1：界面我就不介绍了，如果你看不懂欢迎联系我，是我设计的有问题，我觉得好的设计应该无需介绍！\nPS2：有什么其他的产品建议、或者想联系我，可以随时在微博找我！",
            category: "待办事项清单",
            createdAt: calendar.date(from: DateComponents(year: 2025, month: 11, day: 14, hour: 17, minute: 26)) ?? now,
            color: .blue
        )
        memories.append(memory7)

        saveMemories()
        saveReminders()

        print("Sample data loaded successfully")
    }
}
