import 'package:flutter/material.dart';

import '../bna_theme.dart';
import '../data/bna_components.dart';
import '../widgets/bna_showcase_shell.dart';

class BnaComponentPlaceholderPage extends StatelessWidget {
  const BnaComponentPlaceholderPage({super.key, required this.component});

  final BnaComponentDefinition component;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return BnaShowcaseScaffold(
      title: component.name,
      leadingLabel: 'BNA UI / Components',
      description: component.description,
      trailing: BnaStatusPill(
        label: '待迁移',
        backgroundColor: colors.textMuted.withValues(alpha: 0.14),
        foregroundColor: colors.text,
      ),
      children: <Widget>[
        const BnaExampleSection(
          title: '当前状态',
          description: '这个组件已经加入目录页，但 Flutter 版还没有开始正式迁移。',
          child: BnaBulletList(
            items: <String>[
              '当前优先完成基础交互原语，先把 Button 和 Input 的视觉、状态和交互细节对齐。',
              '这一类组件的 Flutter 迁移通常还需要先补齐上游依赖，例如 Card、Sheet、Popover、媒体能力或平台权限封装。',
              '文档页已经预留出来，后续可以按组件逐个替换成真实 Demo，不需要再改目录结构。',
            ],
          ),
        ),
        BnaExampleSection(
          title: '来源文档',
          description: '原始 React Native 文档地址已经记录，便于后续逐项比对。',
          child: SelectableText(
            component.docsUrl,
            style: BnaShowcaseTextStyles.body(
              colors,
            ).copyWith(color: colors.blue),
          ),
        ),
        const BnaExampleSection(
          title: '后续迁移建议',
          description: '为了控制复杂度，建议按依赖关系从低到高推进。',
          child: BnaBulletList(
            items: <String>[
              '先补齐基础层：Text、Card、Badge、Spinner、Separator。',
              '再迁移布局与容器：Tabs、Accordion、Sheet、Popover、BottomSheet。',
              '然后处理表单控件：Checkbox、Radio、Switch、Picker、Date Picker、Input OTP。',
              '最后进入强平台依赖组件：Video、Camera、Gallery、MediaPicker。',
            ],
          ),
        ),
      ],
    );
  }
}
