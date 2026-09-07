---
title: Settings Master-Detail Navigation - Plan
type: refactor
date: 2026-09-04
artifact_contract: ce-unified-plan/v1
artifact_readiness: implementation-ready
product_contract_source: ce-plan-bootstrap
execution: code
---

# Settings Master-Detail Navigation - Plan

## Goal Capsule

- **Objective:** 让用户从设置分类栏选择一个分类后，正文只呈现该分类，避免长页面锚点导航造成的平滑滚动和分类联动。
- **Means:** 以现有设置子路由作为选中状态来源，把设置正文改成互斥可见的分类面板，并保留当前分类内部的纵向滚动。
- **Authority:** 用户确认的低保真 master-detail 结构；现有 Electron Radix/shadcn 组件、路由和无障碍契约。
- **Execution profile:** 在当前 Electron renderer 上做有界重构，不改变设置业务 API、主进程、Preload 或共享契约。
- **Stop conditions:** 分类路由、模态阻断或已有设置状态无法在不改变业务行为的前提下保留时，停止扩大范围并重新评估组件挂载策略。

## Product Contract

### Summary

设置页采用 master-detail 结构：第二栏始终展示设置分类，第三栏只显示当前分类；分类切换不再驱动长页面滚动，只有当前分类内容超过可用高度时第三栏内部滚动。

### Problem Frame

当前设置正文一次渲染所有分类，并把第三栏作为固定视口内的滚动容器。分类点击和路由同步都会调用平滑锚点定位，滚动监听又反向更新分类选中状态，导致用户把一次分类切换感知为正文滑动，而不是内容替换。

### Requirements

**Category presentation**

- R1. 第二栏必须持续展示“通用、录制、本地模型、云端模型”，并明确标识当前分类。
- R2. 第三栏必须只显示当前分类的标题、操作和设置内容，非当前分类不得占据布局或出现在可访问性树中。
- R3. 当前分类内容超过可用高度时，第三栏保留独立纵向滚动；分类之间不得通过页面锚点、平滑滚动或 scroll-spy 联动。
- R4. 切换到另一个分类后，目标分类从顶部显示，不播放滚动动画。

**Routing and behavior preservation**

- R5. `/settings` 继续默认显示“通用”，`/settings/:categoryId` 继续支持直接进入对应分类。
- R6. 分类点击、设置内部跳转以及后退历史必须继续更新并恢复对应的设置子路由、一级标题和第二栏选中状态。
- R7. 模态打开或应用阻断期间，现有的设置导航拦截行为不得改变。
- R8. 录制、本地模型和云端模型设置的读取、订阅、待处理状态、错误恢复、表单交互及 IPC 调用契约不得改变。

**Visual and accessibility constraints**

- R9. 继续使用现有本地 shadcn/Radix primitives、设置卡片样式、间距和 shadowless 视觉规则，不新建装饰性容器体系。
- R10. 分类控件必须保留有意义的可访问名称和当前项语义；程序化打开特定分类时，焦点必须落到仍然存在的目标标题。

### Key Decisions

- **Master-detail replaces the anchored long page.** (session-settled: user-approved — chosen over a single scrolling settings page: the selected category should read as a content switch rather than a scroll destination.) Governs R1-R4.
- **Existing settings routes remain public navigation state.** 分类 URL 和历史已经承载直接进入、返回和标题同步，不因视图结构变化而降级为仅组件内部状态。Governs R5-R7.

### Scope Boundaries

- 本计划不修改各设置项的业务文案、排序、IPC、存储或主进程行为。
- 本计划不修改 Electron 其他主页面的共享滚动策略。
- 本计划不新增动画、阴影、响应式导航模式或自定义无障碍协议。
- 视觉基准更新和浏览器驱动验证仅在实施任务得到当次明确视觉验证授权后执行。

### Acceptance Examples

- AE1. Given 用户位于“通用”，when 点击“录制”，then 路由变为录制分类，第二栏选中“录制”，第三栏只显示录制内容且从顶部呈现，无平滑滚动。
- AE2. Given 用户依次访问“录制”和“本地模型”，when 使用后退操作，then 恢复“录制”的标题、分类选中状态和唯一可见内容。
- AE3. Given 通过设置内部入口打开“本地模型”，when 设置页出现，then 第三栏只显示本地模型并把焦点放到本地模型标题。
- AE4. Given 当前分类内容高于窗口，when 用户浏览该分类，then 只有第三栏正文可纵向滚动，第二栏选中状态不随滚动改变。
- AE5. Given 模态正在阻止后台导航，when 用户点击另一个设置分类，then 路由、标题和可见分类保持不变。

## Planning Contract

### Key Technical Decisions

- KTD1. **Derive selection from the settings route.** 使用已解析的设置子路由投影当前分类，避免 `settingsSection` 与路由形成两个可漂移的状态源。Applies to R1, R5-R7.
- KTD2. **Keep feature lifecycles stable while hiding inactive panels.** 设置特性继续在进入设置页时按现有生命周期挂载；非当前面板使用原生隐藏语义退出布局和可访问性树，以避免分类切换重新读取设备、模型或云端配置。Applies to R2, R8, R10.
- KTD3. **Perform one post-route presentation update.** 路由提交后仅执行一次无动画的顶部复位；只有程序化跨页面入口额外聚焦目标标题，普通分类点击沿用触发控件焦点。Applies to R3-R4, R6, R10.
- KTD4. **Delete bidirectional scroll synchronization.** 删除设置锚点定位、滚动位置推导选中项和相关 pending target 协调，只保留路由同步及现有 modal navigation gate。Applies to R3-R7.

### Sequencing

先用现有 shell 测试改写预期并建立失败证据，再重构设置选择和面板呈现，最后补齐路由集成与经授权的视觉验证。实施前必须核对 `App.tsx`、`shell_test.tsx` 和相关视觉文件中的现有未提交改动，避免覆盖用户工作。

## Implementation Units

### U1. Route-driven settings panel selection

- **Goal:** 用设置子路由驱动第二栏选中状态和第三栏互斥可见内容，移除长页面滚动协议。
- **Requirements:** R1-R8, R10; AE1-AE5.
- **Dependencies:** None.
- **Files:**
  - `apps/desktop-electron/src/renderer/App.tsx`
  - `apps/desktop-electron/src/renderer/features/settings/settings-page-section.tsx`
  - `apps/desktop-electron/tests/unit/renderer/shell_test.tsx`
- **Approach:**
  1. 从 `parseSectionRoute` 的结果投影当前设置分类，并让分类栏、一级标题和正文共用该值。
  2. 把分类控件从标题 fragment 链接改为与其他上下文面板一致的按钮式路由选择，保留 `aria-current`，并彻底移除 `#settings-section-*` 锚点协议。
  3. 让 `SettingsContent` 接收当前分类，只把对应面板暴露到布局和可访问性树，同时保持设置特性组件的现有挂载生命周期。
  4. 删除 `scrollSettingsSectionIntoView`、设置 scroll listener、位置计算和重复的 animation-frame 调度。
  5. 在路由生效后的稳定边界把共享正文容器复位到顶部；程序化本地模型入口在面板可见后聚焦标题。
  6. 保留 `modalOpen`、`applicationBlocked` 和 section router 的现有导航保护。
- **Execution note:** 先把现有断言从“所有分类同时可见并调用 smooth scroll”改为互斥面板行为，让测试在生产代码变更前失败。
- **Patterns to follow:** `section-router-registry.tsx` 的 memory-router journal、`routeTitle` 的路由标题投影、Radix 模态导航阻断及原生 `hidden` 语义。
- **Test scenarios:**
  - Covers AE1. 初始进入 `/settings` 时只有“通用”二级标题可见；点击“录制”后只有录制面板可见，路由与一级标题同步更新，且 `scrollIntoView` 未被调用。
  - 每个分类项使用按钮语义并保留 `aria-current`；断言设置分类不再暴露标题 fragment `href`。
  - Covers AE2. 在多个分类间导航后触发后退，断言唯一可见面板、`aria-current` 和一级标题一起恢复。
  - Covers AE3. 从现有内部入口打开本地模型，断言本地模型是唯一可见面板且其标题获得焦点。
  - Covers AE4. 模拟正文已有非零滚动位置后切换分类，断言位置立即归零且滚动事件不会改变分类选中状态。
  - Covers AE5. 在 modal blocking 状态点击其他分类，断言导航和可见面板均不变化。
  - 在“录制、本地模型、云端模型”之间往返，断言各设置 API 不因隐藏/显示重复初始化，已有待处理状态和订阅不被重建。
- **Verification:** 设置分类、标题、路由、焦点和唯一可见面板保持一致；代码中不再存在设置页专用的 `scrollIntoView` 或 scroll-spy 监听。

### U2. Navigation and visual contract coverage

- **Goal:** 在壳层集成边界证明新结构没有破坏一级导航、上下文面板、路由历史或现有视觉规则。
- **Requirements:** R1-R10; AE1-AE5.
- **Dependencies:** U1.
- **Files:**
  - `apps/desktop-electron/tests/e2e/sidebar_navigation_test.ts`
  - `apps/desktop-electron/tests/visual/renderer-shell.visual.spec.ts`
  - `apps/desktop-electron/tests/visual/goldens/settings.png`
- **Approach:**
  1. 扩展现有 sidebar navigation 流程，覆盖进入设置、切换分类、离开后返回及分类历史恢复。
  2. 保持第二栏尺寸、共享第三栏滚动容器和现有设置卡片视觉规则不变，只更新设置页基准中由“单分类可见”造成的结构差异。
  3. 未获得当次视觉验证授权时，不启动 Electron、浏览器测试或截图更新，并明确保留视觉基准工作未执行的状态。
- **Patterns to follow:** 现有 `sidebar_navigation_test.ts` 的跨 section 流程和 `renderer-shell.visual.spec.ts` 的 `settings` visual session。
- **Test scenarios:**
  - 从其他一级页面进入设置后，第二栏仍为 docked 设置上下文面板且默认分类正确。
  - 切换设置分类、离开设置再返回，断言 section router journal 恢复最近分类而不是回到由滚动位置推导的分类。
  - Covers AE4. 在短窗口视觉场景中，当前分类内容可到达，第二栏保持固定且不存在跨分类平滑滚动状态。
  - 现有设置卡片继续保持边框、圆角、无阴影和轻量焦点样式。
- **Verification:** 集成测试覆盖分类路由恢复；经授权时更新后的设置视觉基准只包含预期的单分类布局变化。

## Verification Contract

| Scope | Verification | Done signal |
| --- | --- | --- |
| Static consistency | 审查生产与测试 diff，并搜索已移除的设置滚动 helper、scroll listener、标题 fragment `href` 和旧断言 | 不存在悬空引用、重复状态源、设置锚点或旧 smooth-scroll 契约 |
| Electron renderer behavior | 经当次视觉验证授权后，在 `apps/desktop-electron` 运行 `bun run check:ui:quick` | 格式、lint、类型检查、renderer unit 与 sidebar e2e 全部通过 |
| Final Electron UI gate | 若 UI 代码在 quick check 后未再变化，经授权运行一次 `bun run check:ui` | 最终 UI gate 通过且没有重复运行 |
| Visual baseline | 仅在用户明确授权视觉验证后运行设置 visual session、检查差异并更新 `settings.png` | 画面符合确认的 master-detail 草图，且只出现预期 diff |
| Device watcher | 仅在当次视觉验证授权覆盖该步骤时，从仓库根目录运行 `./tool/ensure_ui_watcher.sh` | watcher 已运行、已存在，或无物理 Android 设备时安全退出 |

## Definition of Done

- 第二栏选择与设置子路由、一级标题和第三栏唯一可见面板始终一致。
- 设置分类切换不调用平滑锚点滚动，也不由正文滚动反向改变选中分类。
- 当前分类内容超高时仍可在第三栏内部完整访问。
- 设置业务 API、订阅、待处理状态、modal blocking 和程序化焦点行为保持不变。
- 所有改动与当前工作区已有未提交修改完成逐文件合并，没有覆盖无关用户工作。
- 已按授权范围完成 Verification Contract；未获授权的视觉检查被明确报告为跳过。
