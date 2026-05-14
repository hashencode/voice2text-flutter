# BNA UI Flutter 迁移交接说明

目标：把 React Native UI 库 `ahmedbna/ui` 的组件页和组件行为迁移到当前 Flutter 项目中，要求尽量做到 1:1 复刻；如果有故意不做或暂不做的地方，必须显式罗列，不能默默省略。

---

## 1. 上下文

- Flutter 项目根目录：`/Users/studio/Documents/GitHub/voice2text-flutter`
- RN UI 库仓库：`/Users/studio/Documents/GitHub/ui`
- RN 可运行模板 app：`/Users/studio/Documents/GitHub/ui/templates/start`
- RN demo 源文件目录：
  - `ui/templates/demo/button`
  - `ui/templates/demo/input`
- RN 组件源文件目录：
  - `ui/templates/start/components/ui/button.tsx`
  - `ui/templates/start/components/ui/input.tsx`
- Flutter 当前迁移目录：
  - `lib/features/ui_showcase/`

当前已迁移组件：

- `Button`
- `Input`

当前已知事实：

- `Button`/`Input` 已有可交互 Flutter 页面。
- `Button` 的完整 RN Reanimated 按压动效尚未 1:1 迁移；当前是简化版反馈，不是完整等价实现。
- `Input` 页此前出现过密码显隐 icon 语义错误，这类功能性问题说明“只看外观”不够，必须逐项验证状态与语义。

---

## 2. 这次迁移的经验

### 必须吸取的经验

1. 不能只凭文档页截图迁移，必须同时看 RN 源码、RN 真机效果、Flutter 真机效果。
2. 不能只对齐静态样式，必须同时检查状态、交互、图标语义、禁用态、loading 态、键盘行为。
3. 任何“故意不做”“暂时不做”“先简化”的地方，都必须单独写成差异清单，不能隐含在实现里。
4. 如果做了范围收缩，必须明确告诉用户：
   - 哪些部分已 1:1
   - 哪些部分只是近似
   - 哪些部分故意延期
5. 组件页本身的页面骨架也属于复刻范围，不只是组件本体。
6. 真机验证不能只看首屏，要实际点按关键交互。

### 这次暴露出来的问题来源

1. `Button` 动效缺失：是范围收缩，但没有把“尚未对齐项”显式列出来。
2. `Password` icon 语义错误：功能逻辑虽然可用，但状态语义复查不够细。
3. `Variants` 排版不合适：沿用了 RN 宽度分配思路，但没有充分考虑当前设备宽度和实际展示效果。

结论：后续迁移时，必须把“视觉对齐”和“功能对齐”分开检查，不能混在一起凭感觉判断。

---

## 3. 后续迁移标准流程

### Step 1. 锁定 RN 基线

每迁一个组件，先找全这三类文件：

1. RN demo 文件
2. RN 组件实现文件
3. RN 主题/常量文件

至少确认：

- 尺寸
- 圆角
- padding / gap
- 字体大小/字重
- 颜色
- 状态机
- 动效
- 图标
- 文案

### Step 2. 跑 RN 真机基线

不要直接假设 `/Users/studio/Documents/GitHub/ui` 根目录可运行。

RN 真机基线应从这里启动：

- `/Users/studio/Documents/GitHub/ui/templates/start`

必要时可以临时增加 compare 页面或 demo 入口，但要记得：

1. 记录临时改动范围
2. 在交付时说明 RN 模板侧有哪些临时修改还未清理

### Step 3. 先迁“组件本体”，再迁“展示页骨架”

优先顺序：

1. 组件本体 API 和状态行为
2. 组件视觉样式
3. demo 编排和页面骨架
4. 动效和边缘状态

### Step 4. Flutter 实现时的硬性规则

1. 不要默默删功能。
2. 如果 RN 有某个状态，Flutter 页面必须能演示出来。
3. 如果 RN 有某个交互，Flutter 页面必须能实际触发。
4. 如果暂时不做，必须在“故意不做项”中列出。

### Step 5. 自查清单

每个组件都要至少过下面这几项：

1. 默认态
2. 所有 variants
3. 所有 sizes
4. icons / icon-only
5. disabled
6. loading
7. validation / error
8. right component / suffix / prefix
9. 动效
10. 文案
11. 图标语义
12. 键盘/焦点行为

### Step 6. 真机对比

必须至少进行一次：

1. RN 真机截图
2. Flutter 真机截图
3. 关键交互点按验证

不能只看浏览器或模拟布局。

### Step 7. 输出差异结论

每个组件结束时，必须给出：

1. 已对齐项
2. 未对齐项
3. 故意不做项
4. 原因
5. 后续建议

---

## 4. 1:1 复刻检查规则

### 视觉检查

逐项检查：

1. 页面标题结构是否一致
2. section 标题是否一致
3. 每组 demo 的排列方式是否一致
4. 按钮/输入框的高度、宽度、圆角是否一致
5. 图标大小、位置、间距是否一致
6. 文字字号、字重、行高是否一致
7. 颜色、边框、背景、透明度是否一致
8. disabled/loading/error 的颜色语义是否一致

### 功能检查

逐项检查：

1. 点击是否触发
2. loading 时是否真的不可交互
3. disabled 时是否真的不可交互
4. icon 是否表达正确语义
5. 密码显隐时 icon 与实际状态是否一致
6. 复制、提交、搜索等右侧动作是否真实可用
7. 焦点切换、键盘唤起、光标行为是否正常

### 动效检查

逐项检查：

1. 是否有按压反馈
2. 动效类型是否一致
3. 动效幅度是否接近
4. 动效时长和回弹节奏是否接近

如果故意不做，必须在结果里单列：

- `故意不做项：xxx`
- `原因：xxx`
- `影响：xxx`
- `后续是否补齐：xxx`

---

## 5. 真机校验方式

### 当前可用设备

- Android 真机：`a186e452`
- 机型：`M2102J2SC`

### Flutter 真机运行

在 Flutter 项目根目录执行：

```bash
flutter run -d a186e452
```

### RN 真机运行

在 RN 模板 app 目录执行：

```bash
cd /Users/studio/Documents/GitHub/ui/templates/start
npm install
npx expo install expo-linear-gradient
npx expo run:android
```

### 真机截图

```bash
adb exec-out screencap -p > /tmp/current-screen.png
```

### 真机点击/输入辅助

```bash
adb shell input tap X Y
adb shell input text Button
adb shell input keyevent 4
```

### 真机性能辅助检查

如果怀疑键盘或页面卡顿，可补充：

```bash
adb shell dumpsys gfxinfo com.voice2text.app
adb logcat | rg "Skipped|PerfMonitor|latency|Choreographer"
```

---

## 6. 已知约束

1. 当前仓库没有完整可用的 `ios/` 工程，所以真机 UI 校验主要基于 Android。
2. RN 模板 app 侧曾为了对比而临时加入 compare 入口和 demo 文件；如果继续沿用，必须在交付时说明这些临时改动是否保留。
3. Flutter showcase 页此前为了解决 `Input` 键盘卡顿，已经做过 lazy build 和局部状态拆分；后续不要为了“更像 RN”直接回退成整页重建。

---

## 7. 后续迁移时什么该做、什么不该做

### 该做

1. 先看 RN 源码，再看 RN 真机，再改 Flutter。
2. 每次只迁 1 到 2 个组件，做完即对齐即验证。
3. 每轮结束都输出“已对齐 / 未对齐 / 故意不做”。
4. 优先修功能语义错误，其次再修视觉细节。
5. 对开关类、校验类、密码类交互做显式点按验证。

### 不该做

1. 不要凭印象复刻。
2. 不要只看网页文档，不看 RN 真实代码。
3. 不要只看静态图，不点交互。
4. 不要把故意省略的部分藏起来不说。
5. 不要在未验证前宣称“完全复刻”。

---

## 8. 交付模板

每完成一个组件，建议按下面模板汇报：

1. 已完成：
   - 列出迁移组件名
   - 列出已对齐的视觉/状态/交互
2. 未对齐：
   - 列出仍有差异的点
3. 故意不做项：
   - 列出省略内容、原因和影响
4. 验证：
   - `flutter analyze`
   - `flutter test`
   - RN 真机对比
   - Flutter 真机对比

---

## 9. 新对话接续文案

把下面整段直接发到新对话里：

```text
继续在 /Users/studio/Documents/GitHub/voice2text-flutter 中迁移 BNA UI（RN 源库在 /Users/studio/Documents/GitHub/ui）。先读取 /Users/studio/Documents/GitHub/voice2text-flutter/docs/BNA_UI_MIGRATION_HANDOFF.md，再严格按其中规则继续执行。

硬性要求：
1. 每次只迁 1 到 2 个组件，先迁组件本体，再迁 demo 页面。
2. 必须先读取 RN demo 源码和 RN 组件源码，再开始改 Flutter。
3. 必须在真机上同时对比 RN 和 Flutter 的实际展示效果，不要只看文档页截图。
4. 目标是尽量 1:1 复刻视觉、状态、交互、图标语义和页面骨架。
5. 任何故意不做、暂时不做、无法 1:1 的地方，必须单独列成“故意不做项”，写清原因、影响和后续是否补齐，不能默默省略。
6. 不能只检查样式，必须逐项检查功能：disabled、loading、validation、toggle、copy、submit、keyboard、focus、icon 语义。
7. 完成后必须运行 flutter analyze 和 flutter test，并给出 RN 真机与 Flutter 真机对比结论。

已知上下文：
- RN 可运行模板 app 在 /Users/studio/Documents/GitHub/ui/templates/start
- RN demo 目录在 /Users/studio/Documents/GitHub/ui/templates/demo
- Android 真机设备是 a186e452（M2102J2SC）
- 当前已迁移 Button 和 Input
- Button 的完整 RN Reanimated 按压动效尚未完整迁移；如果继续不做，必须在结果里显式列出
- 之前出现过 Password 显隐 icon 语义错误，后续必须重点检查状态语义和实际表现是否一致
- Input 页之前为了解决键盘卡顿，已经做过 lazy build；不要为了更像 RN 直接回退成整页重建

这次请先：
1. 选择下一个最适合迁移的 1 到 2 个基础组件
2. 读取 RN 源码和 demo
3. 给出迁移计划
4. 开始实现
5. 做真机对比和差异结论
```

