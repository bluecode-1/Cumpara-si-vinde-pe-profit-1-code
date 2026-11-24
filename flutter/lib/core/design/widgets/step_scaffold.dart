import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/livada_tokens.dart';

/// Page skeleton shared by the full-screen steps: a heading, an optional
/// subtitle, free-form content and actions pinned to the bottom.
///
/// Everything lives in one scroll view: when the text is enlarged (up to
/// 200 % and beyond) or the keyboard is open, the page scrolls instead of
/// clipping; when there is room, the actions stay at the bottom edge.
class StepScaffold extends StatelessWidget {
  const StepScaffold({
    required this.title,
    required this.children,
    this.subtitle,
    this.actions = const <Widget>[],
    this.showBackButton = false,
    this.titleStyle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  /// Buttons laid out vertically at the bottom of the page.
  final List<Widget> actions;

  /// Shows an app bar with the platform back button.
  final bool showBackButton;

  /// Defaults to `headlineSmall`.
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? subtitle = this.subtitle;
    return Scaffold(
      appBar: showBackButton ? AppBar() : null,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                LivadaSpacing.lg,
                showBackButton ? LivadaSpacing.sm : LivadaSpacing.xl,
                LivadaSpacing.lg,
                LivadaSpacing.md,
              ),
              // Not lazy on purpose: a step has a handful of children and
              // screen readers should be able to reach all of them.
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: titleStyle ?? theme.textTheme.headlineSmall,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: LivadaSpacing.sm),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: LivadaSpacing.lg),
                    ...children,
                  ],
                ),
              ),
            ),
            if (actions.isNotEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LivadaSpacing.lg,
                    0,
                    LivadaSpacing.lg,
                    LivadaSpacing.md,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      for (final (int index, Widget action)
                          in actions.indexed) ...<Widget>[
                        if (index > 0) const SizedBox(height: LivadaSpacing.sm),
                        action,
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
