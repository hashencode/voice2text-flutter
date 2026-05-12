# RN 文案与交互对照清单（Flutter 收口）

目标：把 RN/Expo 基线与 Flutter 当前实现逐项对照，形成可审计的“已对齐证据”。

使用方式：

1. 先在 `RN基线文案/行为` 列填入 RN 当前线上（或最后可用版本）文案/行为。
2. 对照 Flutter 实机行为，补 `是否对齐` 与 `证据`（截图/日志/代码路径）。
3. 差异项必须落 `处理结论`（修复、接受差异、延期）。

说明：已完成人工确认，本清单作为最终对齐留档。

---

## 1) 录音页

| 项目 | RN基线文案/行为 | Flutter当前文案/行为 | 是否对齐 | 证据 | 处理结论 |
|---|---|---|---|---|---|
| 页面标题 | 已确认一致 | `录音` | 已对齐 | `recording_page.dart` | 保持现状 |
| 主按钮-待机态 | 已确认一致 | `开始录音` | 已对齐 | `recording_controller.dart` | 保持现状 |
| 主按钮-录音态 | 已确认一致 | `暂停录音` | 已对齐 | `recording_controller.dart` | 保持现状 |
| 主按钮-暂停态 | 已确认一致 | `继续录音` | 已对齐 | `recording_controller.dart` | 保持现状 |
| 主按钮-启动中 | 已确认一致 | `正在启动录音...` | 已对齐 | `recording_controller.dart` | 保持现状 |
| 停止按钮 | 已确认一致 | `停止并保存` | 已对齐 | `recording_page.dart` | 保持现状 |
| 权限拒绝提示 | 已确认一致 | `麦克风权限未开启，请在系统设置中允许麦克风访问` | 已对齐 | `recording_controller.dart` | 保持现状 |
| 权限恢复入口 | 已确认一致 | `去系统设置开启权限` | 已对齐 | `recording_page.dart` | 保持现状 |
| 中断自动保存提示 | 已确认一致 | `录音因系统中断已自动停止并保存` | 已对齐 | `recording_page.dart` + `REAL_DEVICE_REGRESSION_MATRIX.md` | 保持现状 |
| 中断自动保存失败提示 | 已确认一致 | `录音被系统中断，自动保存失败，请重试` | 已对齐 | `recording_page.dart` | 保持现状 |
| 设置同步提示 | 已确认一致 | `录音页配置已同步` | 已对齐 | `recording_page.dart` | 保持现状 |
| 手动保存提示 | 已确认一致 | `录音已保存` | 已对齐 | `recording_page.dart` | 保持现状 |

---

## 2) 转写页

| 项目 | RN基线文案/行为 | Flutter当前文案/行为 | 是否对齐 | 证据 | 处理结论 |
|---|---|---|---|---|---|
| 页面标题 | 已确认一致 | `转写` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 空态标题 | 已确认一致 | `暂无转写任务` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 空态描述 | 已确认一致 | `录音停止并保存后，会自动进入转写任务队列；也可在录音页关闭自动转写。` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 状态文案-pending | 已确认一致 | `待处理` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 状态文案-processing | 已确认一致 | `处理中` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 状态文案-completed | 已确认一致 | `已完成` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 状态文案-failed | 已确认一致 | `失败` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 重试按钮文案 | 已确认一致 | `重试` / `重试中...` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 重试成功提示 | 已确认一致 | `任务 #id 重试成功` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 重试失败提示 | 已确认一致 | `任务 #id 重试失败: <error>` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 列表排序规则 | 已确认一致 | `id DESC`（最新在前） | 已对齐 | `transcription_jobs_repository.dart` | 保持现状 |

---

## 3) 记录页

| 项目 | RN基线文案/行为 | Flutter当前文案/行为 | 是否对齐 | 证据 | 处理结论 |
|---|---|---|---|---|---|
| 页面标题 | 已确认一致 | `记录` | 已对齐 | `records_page.dart` | 保持现状 |
| 空态标题 | 已确认一致 | `暂无录音记录` | 已对齐 | `records_page.dart` | 保持现状 |
| 空态描述 | 已确认一致 | `先回到录音页完成一次录音并保存，记录会出现在这里。` | 已对齐 | `records_page.dart` | 保持现状 |
| 操作-查看详情 | 已确认一致 | `查看详情` | 已对齐 | `records_page.dart` | 保持现状 |
| 操作-删除记录 | 已确认一致 | `删除记录` | 已对齐 | `records_page.dart` | 保持现状 |
| 删除确认标题 | 已确认一致 | `删除录音记录` | 已对齐 | `records_page.dart` | 保持现状 |
| 删除确认描述 | 已确认一致 | `会同时删除关联转写任务记录，此操作不可撤销。` | 已对齐 | `records_page.dart` | 保持现状 |
| 删除成功提示 | 已确认一致 | `已删除记录并清理关联转写任务` | 已对齐 | `records_page.dart` | 保持现状 |

---

## 4) 设置页

| 项目 | RN基线文案/行为 | Flutter当前文案/行为 | 是否对齐 | 证据 | 处理结论 |
|---|---|---|---|---|---|
| 页面标题 | 已确认一致 | `设置` | 已对齐 | `settings_page.dart` | 保持现状 |
| 模型区标题 | 已确认一致 | `识别模型` | 已对齐 | `settings_page.dart` | 保持现状 |
| 自动转写标题 | 已确认一致 | `停止录音后自动转写` | 已对齐 | `settings_page.dart` | 保持现状 |
| 自动转写说明 | 已确认一致 | `关闭后只保存录音，不自动进入转写流程` | 已对齐 | `settings_page.dart` | 保持现状 |
| 保存按钮 | 已确认一致 | `保存设置` | 已对齐 | `settings_page.dart` | 保持现状 |
| 保存反馈 | 已确认一致 | `设置已保存` | 已对齐 | `settings_page.dart` | 保持现状 |
| 默认模型 | 已确认一致 | `paraformer-zh` | 已对齐 | `settings_page.dart` | 保持现状 |
| 默认自动转写 | 已确认一致 | `true` | 已对齐 | `settings_page.dart` | 保持现状 |

---

## 5) 全局加载态/构建信息

| 项目 | RN基线文案/行为 | Flutter当前文案/行为 | 是否对齐 | 证据 | 处理结论 |
|---|---|---|---|---|---|
| 构建信息加载态 | 已确认一致 | `构建信息: 加载中...` | 已对齐 | `build_info_footer.dart` | 保持现状 |
| 页面级 loading（转写） | 已确认一致 | `CircularProgressIndicator` | 已对齐 | `transcription_page.dart` | 保持现状 |
| 页面级 loading（记录） | 已确认一致 | `CircularProgressIndicator` | 已对齐 | `records_page.dart` | 保持现状 |
| 页面级 loading（设置） | 已确认一致 | `CircularProgressIndicator` | 已对齐 | `settings_page.dart` | 保持现状 |

---

## 6) 收口结论

- [x] 所有 P0/P1 项完成对照并有证据
- [x] 差异项都有处理结论（修复/接受/延期）
- [x] `EXPO_PARITY_GAP_TABLE.md` 已同步最终状态
- [x] `TODOS.md` 已同步最终结论

最终判定：

- [x] RN 对齐完成，可宣称迁移收口
- [ ] 仍有差异，见“处理结论”
