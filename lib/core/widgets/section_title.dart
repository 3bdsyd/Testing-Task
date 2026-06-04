import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// Green section header used above each grid ("ارقامي القياسي", …).
///
/// Alignment follows text direction automatically (start = right in RTL), so
/// no explicit RTL wrapper is required.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(text, style: AppTextStyles.sectionTitle),
    );
  }
}
