import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import '../l10n/app_localizations.dart';

/// Shows an update dialog using AppUpdateAvailableComponent
/// Returns:
/// - 0 if no update available or dialog dismissed
/// - 1 if immediate update was initiated
/// - 2 if flexible update download was started
/// - 3 if flexible update was completed
Future<int> showUpdateDialog({
  required BuildContext context,
  required Future<AppUpdateInfo?> updateInfoFuture,
}) async {
  final updateInfo = await updateInfoFuture;

  if(updateInfo == null || updateInfo.updateAvailability != UpdateAvailability.updateAvailable) {
    return 0; // No update available
  }


  int result = 0;
  bool flexibleUpdateStarted = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AppUpdateAvailableComponent(
            updateInfo: updateInfo,
            onAction: (action) {
              switch (action) {
                case UpdateAction.immediate:
                  result = 1;
                  Navigator.pop(context);
                  break;
                case UpdateAction.flexibleStart:
                  result = 2;
                  setState(() => flexibleUpdateStarted = true);
                  break;
                case UpdateAction.flexibleComplete:
                  result = 3;
                  Navigator.pop(context);
                  break;
                case UpdateAction.cancel:
                  result = 0;
                  Navigator.pop(context);
                  break;
              }
            },
            flexibleUpdateAvailable: flexibleUpdateStarted,
          );
        },
      );
    },
  );

  return result;
}

enum UpdateAction {
  immediate,
  flexibleStart,
  flexibleComplete,
  cancel,
}

class AppUpdateAvailableComponent extends StatefulWidget {
  final AppUpdateInfo? updateInfo;
  final ValueChanged<UpdateAction> onAction;
  final bool flexibleUpdateAvailable;

  const AppUpdateAvailableComponent({
    super.key,
    this.updateInfo,
    required this.onAction,
    required this.flexibleUpdateAvailable,
  });

  @override
  State<AppUpdateAvailableComponent> createState() => _AppUpdateAvailableComponentState();
}

class _AppUpdateAvailableComponentState extends State<AppUpdateAvailableComponent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (widget.updateInfo == null || widget.updateInfo?.updateAvailability != UpdateAvailability.updateAvailable) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: Text(
        l10n.updateAvailableTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.updateAvailableMessage),
            const SizedBox(height: 16),
            Text(
              l10n.versionInfo(widget.updateInfo?.availableVersionCode.toString() ?? ''),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            if (widget.updateInfo?.immediateUpdateAllowed == true) ...[
              _buildUpdateButton(
                context,
                l10n.performImmediateUpdate,
                    () {
                  widget.onAction(UpdateAction.immediate);
                  InAppUpdate.performImmediateUpdate()
                      .then((_) => showSnack(l10n.updateSnackbarSuccess))
                      .catchError((e) {
                    showSnack(l10n.updateSnackbarFailure(e.toString()));
                  });
                },
              ),
              const SizedBox(height: 12),
            ],
            if (widget.updateInfo?.flexibleUpdateAllowed == true) ...[
              _buildUpdateButton(
                context,
                l10n.startFlexibleUpdate,
                    () {
                  widget.onAction(UpdateAction.flexibleStart);
                  InAppUpdate.startFlexibleUpdate().then((_) {
                    // State is managed by parent dialog now
                  }).catchError((e) {
                    showSnack(l10n.updateSnackbarFailure(e.toString()));
                  });
                },
              ),
              const SizedBox(height: 12),
            ],
            if (widget.flexibleUpdateAvailable) ...[
              _buildUpdateButton(
                context,
                l10n.completeFlexibleUpdate,
                    () {
                  widget.onAction(UpdateAction.flexibleComplete);
                  InAppUpdate.completeFlexibleUpdate()
                      .then((_) => showSnack(l10n.updateSnackbarSuccess))
                      .catchError((e) {
                    showSnack(l10n.updateSnackbarFailure(e.toString()));
                  });
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(l10n.laterButton),
          onPressed: () => widget.onAction(UpdateAction.cancel),
        ),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}