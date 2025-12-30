# Todoo - 记忆土豆

一个智能记忆管理应用，使用SwiftUI构建。

## 功能特性

### 核心功能
- ✅ **多模态输入** - 支持文字、语音和图片输入
- ✅ **智能文字识别** - 使用Vision框架的OCR自动提取图片中的文字
- ✅ **AI智能解析** - 自动提取时间信息和事项内容
- ✅ **记忆管理** - 创建、编辑、置顶、归档和删除记忆
- ✅ **智能提醒** - 基于时间的本地通知提醒
- ✅ **分组浏览** - 按时间分组查看所有记忆（今天、过去30天、按月份）
- ✅ **搜索功能** - 快速搜索记忆内容
- ✅ **精美UI** - 深色主题，彩色卡片设计

### 界面说明

#### 主界面
- **Upcoming** - 显示即将到来的提醒事项
- **Memories** - 显示最近的记忆，支持筛选和搜索
- **底部输入栏** - 快速创建记忆的入口

#### All Memories页面
- 按时间分组显示所有记忆
- 支持书签筛选
- 底部搜索栏

#### Memory Details页面
- 查看记忆的完整内容
- 显示关联的提醒
- 支持分享功能

#### 创建记忆
- 文字输入
- 语音录制（模拟）
- 图片OCR识别
- 智能时间提取

### 数据模型

#### Memory（记忆）
```swift
struct Memory {
    var id: UUID
    var title: String           // 标题
    var content: String         // 内容
    var category: String        // 分类
    var createdAt: Date         // 创建时间
    var updatedAt: Date         // 更新时间
    var isPinned: Bool          // 是否置顶
    var isArchived: Bool        // 是否归档
    var tags: [String]          // 标签
    var imageData: Data?        // 图片数据
    var reminderIDs: [UUID]     // 关联的提醒ID
    var color: MemoryColor      // 卡片颜色
}
```

#### Reminder（提醒）
```swift
struct Reminder {
    var id: UUID
    var memoryID: UUID          // 关联的记忆ID
    var title: String           // 标题
    var remindTime: Date        // 提醒时间
    var isCompleted: Bool       // 是否完成
    var createdAt: Date         // 创建时间
}
```

## 技术栈

- **SwiftUI** - 界面框架
- **Combine** - 响应式编程
- **Vision** - OCR文字识别
- **UserNotifications** - 本地通知
- **NaturalLanguage** - 自然语言处理
- **UserDefaults** - 数据持久化

## 项目结构

```
Todoo/
├── TodooApp.swift                  # 应用入口
├── Models/                         # 数据模型
│   ├── Memory.swift
│   └── Reminder.swift
├── Views/                          # 视图
│   ├── ContentView.swift          # 主界面
│   ├── AllMemoriesView.swift     # 所有记忆
│   ├── MemoryDetailView.swift    # 记忆详情
│   ├── UpcomingDetailView.swift  # 即将到来
│   ├── CreateMemoryView.swift    # 创建记忆
│   └── Components/                # 组件
│       ├── MemoryCardView.swift
│       └── BottomInputBar.swift
├── Managers/                       # 管理器
│   ├── DataManager.swift          # 数据管理
│   ├── AIManager.swift            # AI处理
│   └── NotificationManager.swift  # 通知管理
├── Helpers/                        # 辅助工具
│   └── SampleData.swift           # 示例数据
├── Assets.xcassets/               # 资源文件
└── Info.plist                     # 配置文件
```

## 安装与运行

### 系统要求
- macOS 13.0+
- Xcode 15.0+
- iOS 16.0+

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd todoo-copy
```

2. 打开Xcode项目
```bash
open Todoo.xcodeproj
```

3. 选择目标设备（iPhone模拟器或真机）

4. 运行项目（⌘ + R）

### 加载示例数据

在应用启动后，可以在`TodooApp.swift`中调用以下代码加载示例数据：

```swift
.onAppear {
    // 仅在首次启动或需要重置数据时使用
    // dataManager.loadSampleData()
}
```

## 使用指南

### 创建记忆

1. **文字输入**
   - 在底部输入栏直接输入文字
   - 支持自动提取时间信息
   - 示例："今天晚上10点睡觉"

2. **图片识别**
   - 点击附件按钮选择图片
   - 自动OCR识别图片中的文字
   - 支持中英文识别

3. **语音输入**
   - 点击麦克风按钮录制语音
   - 自动转换为文字（需要真机测试）

### 管理记忆

- **置顶** - 长按记忆卡片，选择"Pin"
- **归档** - 长按记忆卡片，选择"Archive Memory"
- **删除** - 长按记忆卡片，选择"Delete Memory"
- **添加图片** - 在记忆详情页添加
- **添加提醒** - 创建记忆时自动提取时间，或手动添加

### 查看记忆

- **主页** - 查看最近的记忆和即将到来的提醒
- **All Memories** - 按时间分组查看所有记忆
- **搜索** - 使用底部搜索栏搜索记忆内容
- **筛选** - 点击书签图标只显示置顶的记忆

## AI功能说明

### 时间提取

支持以下时间格式：
- "今天晚上10点" → 今天 22:00
- "明天下午3点" → 明天 15:00
- "今天下午五点" → 今天 17:00
- "Today 18:40" → 今天 18:40

### 内容分类

自动识别以下分类并应用相应颜色：
- **睡觉** → 棕色
- **写代码/编程/工作** → 紫色
- **跑步/锻炼/运动** → 绿色
- **去北京/旅行** → 粉色
- **学习/阅读** → 蓝色

## 通知权限

首次运行时，应用会请求以下权限：
- 📸 相机权限 - 用于拍照
- 🖼️ 相册权限 - 用于选择图片
- 🎤 麦克风权限 - 用于语音输入
- 🔔 通知权限 - 用于提醒功能

## 已知限制

- 语音转文字功能需要在真机上测试
- 部分AI解析功能可能需要进一步优化
- OCR识别准确率取决于图片质量

## 开发计划

- [ ] 改进语音转文字功能
- [ ] 优化AI时间提取算法
- [ ] 添加数据导出功能
- [ ] 支持iCloud同步
- [ ] 添加小组件支持
- [ ] 支持Apple Watch

## 许可证

本项目仅用于学习和演示目的。

## 作者

基于iOS应用截图完全复制开发

## 更新日志

### v1.0.0 (2025-12-30)
- ✅ 初始版本
- ✅ 实现所有核心功能
- ✅ SwiftUI界面开发
- ✅ OCR文字识别
- ✅ 智能时间提取
- ✅ 本地通知提醒
