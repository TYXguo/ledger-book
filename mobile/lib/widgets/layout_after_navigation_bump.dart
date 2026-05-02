import 'package:flutter/material.dart';

/// Triggers a second layout pass after the first frame. Some routes (especially
/// web) return with transient constraints; a no-op rebuild often fixes clipped
/// or incomplete ListView content without refetching data.
class LayoutAfterNavigationBump extends StatefulWidget {
  const LayoutAfterNavigationBump({super.key, required this.child});

  final Widget child;

  @override
  State<LayoutAfterNavigationBump> createState() => _LayoutAfterNavigationBumpState();
}

class _LayoutAfterNavigationBumpState extends State<LayoutAfterNavigationBump> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
