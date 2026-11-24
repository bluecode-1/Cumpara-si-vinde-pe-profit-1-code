import 'package:flutter/semantics.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/livada_tokens.dart';

/// Announces [message] to screen readers (TalkBack / VoiceOver).
void announceForAccessibility(BuildContext context, String message) {
  // Fire-and-forget: there is nothing to do if no assistive service listens.
  SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    Directionality.of(context),
    assertiveness: Assertiveness.assertive,
  ).ignore();
}

/// Inline error text. It is a live region and is additionally announced
/// whenever a new message appears, so the error is never silent.
class ErrorMessage extends StatefulWidget {
  const ErrorMessage(this.message, {super.key});

  /// `null` renders nothing.
  final String? message;

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> {
  @override
  void initState() {
    super.initState();
    _announce();
  }

  @override
  void didUpdateWidget(ErrorMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      _announce();
    }
  }

  void _announce() {
    final String? message = widget.message;
    if (message == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        announceForAccessibility(context, message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? message = widget.message;
    if (message == null) {
      return const SizedBox.shrink();
    }
    final ThemeData theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(top: LivadaSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ExcludeSemantics(
              child: Icon(Icons.error_outline, color: theme.colorScheme.error),
            ),
            const SizedBox(width: LivadaSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
