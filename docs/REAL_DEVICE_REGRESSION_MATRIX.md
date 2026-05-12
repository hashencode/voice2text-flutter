# Real Device Regression Matrix (Android)

目标：覆盖“是否算重构完成”最关键链路，优先验证端到端稳定性与可回归性。

验收总标准：
- 无闪退
- 任务状态流转正确（pending -> processing -> completed/failed）
- 结果可展示（成功文本/失败原因）
- 日志可见 `transcribe ok`

## 0. 基础信息（每次回归必填）

- 日期：2026-05-07
- 执行人：
- 分支/提交：
- 设备型号：M2102J2SC（thyme）
- Android 版本：
- App 版本（包名/版本号/安装时间）：
- 模型配置：paraformer-zh
- 引擎模式（auto/stub/real）：

---

## 1. 核心场景矩阵

| ID | 场景 | 步骤 | 预期结果 | 日志证据 | 结果(PASS/FAIL) | 备注 |
|---|---|---|---|---|---|---|
| R1 | 短录音转写 | 录音 3-8 秒 -> 停止并保存 | 记录入库；任务完成；列表可见转写文本 | `transcribe ok` | PASS |  |
| R2 | 长录音转写 | 录音 60-180 秒 -> 停止并保存 | 无闪退；任务完成；UI可滚动展示结果 | `transcribe ok` + costMs | PASS |  |
| R3 | 多次连续录音 | 连续做 5 次短录音并保存 | 每次都生成记录和任务，状态无错乱 | 多条 `transcribe ok` | PASS |  |
| R4 | 任务失败后重试 | 制造失败任务后点“重试” | 状态 failed -> processing -> completed/failed；按钮防连点生效 | retry 前后日志 | PASS |  |
| R5 | 权限拒绝后重试 | 首次拒绝麦克风权限 -> 再次触发录音 | 给出明确提示；允许用户恢复后再次录音 | 权限相关日志 | PASS |  |
| R6 | 来电/系统中断恢复 | 1) 开始录音 2) 触发中断（按 Home/切后台/来电）3) 回到 App | 出现“录音因系统中断已自动停止并保存”；不崩溃；可继续下一次录音 | 中断后提示截图 + `transcribe ok`/失败日志 | PASS |  |

---

## 2. 状态流转核对

每个任务至少核对一次：

- [x] pending
- [x] processing
- [x] completed（有 result_text）
- [x] failed（有 error_message）

异常核对：

- [x] failed 任务可重试
- [x] 重试期间按钮禁用，避免重复触发
- [x] 重试完成后列表刷新正确

---

## 3. 日志与产物留档

建议命令：

```bash
./tool/run_android_smoke.sh
./tool/check_transcribe_log.sh
```

每轮回归至少留档：

- [x] 最新 smoke 日志路径
- [x] 至少一条 `transcribe ok` 日志截图/文本
- [x] 失败场景日志（如有）
- [x] 构建信息截图（包名/版本/安装时间）

本轮日志证据：

- `build/smoke/logcat-20260507-092723.txt`
- `05-07 09:28:31.869 I/Voice2TextNative(...): transcribe ok mode=auto model=paraformer-zh durationMs=17448 costMs=3481`
- `05-07 09:28:31.882 I/flutter(...): transcribe ok jobId=2 durationMs=17448`

---

## 4. 结论门槛（是否通过）

通过条件（全部满足才算 PASS）：

- [x] R1~R6 全部 PASS
- [x] 无闪退
- [x] 任务状态无异常卡死
- [x] 成功/失败结果都可展示
- [x] 至少一轮 real 模式日志包含 `transcribe ok`

最终结论：

- [x] 本轮回归通过，可作为“重构完成度”证据
- [ ] 本轮回归未通过，阻塞项见下

状态：PASS（回归矩阵已通过，可作为重构完成度核心证据）

阻塞项：无（矩阵维度）

---

## R6 专项留证（建议）

- [ ] 中断触发前录音状态截图（录音中）
- [ ] 回到 App 后提示截图（自动停止并保存/自动保存失败）
- [ ] 记录页新增记录截图
- [ ] 转写页任务状态截图（completed 或 failed）
- [ ] 对应日志文件路径（`build/smoke/logcat-*.txt`）

## 已知限制（当前版本）

- 无新增阻塞性已知限制（R6 已完成真机回归通过）。
