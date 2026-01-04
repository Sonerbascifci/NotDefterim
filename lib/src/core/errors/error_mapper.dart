import 'package:flutter/material.dart';
import '../../app/l10n/l10n_extension.dart';

class ErrorMapper {
  static String mapErrorToMessage(BuildContext context, Object error) {
    // TODO: Implement specific mapping for FirebaseAuthException, etc.
    return context.l10n.unexpectedError;
  }
}
