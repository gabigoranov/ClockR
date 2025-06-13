import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/timer_controller.dart';
import '../components/are_you_sure_dialog.dart';
import '../l10n/app_localizations.dart';
import '../models/time_control.dart';

class AddTimeControlScreen extends StatefulWidget {
  const AddTimeControlScreen({super.key});

  @override
  State<AddTimeControlScreen> createState() => _AddTimeControlScreenState();
}

class _AddTimeControlScreenState extends State<AddTimeControlScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _minutes = 5;
  int _seconds = 0;
  int _increment = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    debugPrint("Submitting time control: ${_nameController.text.trim()}");
    if (_formKey.currentState!.validate()) {
      final timeControl = TimeControl(
        (_minutes * 60) + _seconds,
        _increment,
        _nameController.text.trim(),
        isCustom: true,
      );

      if(TimerController.presetExists((_minutes * 60) + _seconds, _increment)) {
        final bool? result = await showAreYouSureDialog(
          context: context,
          title: AppLocalizations.of(context).error,
          content: AppLocalizations.of(context).presetExistsError,
          confirmText: AppLocalizations.of(context).confirm,
          cancelText: AppLocalizations.of(context).cancel,
          confirmColor: Colors.blue, // Custom color for the confirm button
        );

        if (result == false) {
          await TimerController.updatePreset(timeControl);
        }
      }
      else{
        await TimerController.addPreset(timeControl);
      }
      Get.back();

    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addTimeControlTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0, 6, 0),
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: _submit,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              Text(
                l10n.timeControlNameLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.timeControlNameHint,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.timeControlNameError;
                  }
                  else if (value.trim().length > 20) {
                    return l10n.timeControlNameMaxLengthError;
                  }
                  else if (value.trim().length < 3) {
                    return l10n.timeControlNameMinLengthError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Base Time Section
              Text(
                l10n.baseTimeLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TimeDropdown(
                      value: _minutes,
                      items: List.generate(121, (index) => index),
                      labelBuilder: (value) => l10n.minutesSuffix(value),
                      onChanged: (value) => setState(() => _minutes = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeDropdown(
                      value: _seconds,
                      items: const [0, 15, 30, 45],
                      labelBuilder: (value) => l10n.secondsSuffix(value),
                      onChanged: (value) => setState(() => _seconds = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Increment Section
              Text(
                l10n.incrementLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _TimeDropdown(
                value: _increment,
                items: List.generate(61, (index) => index),
                labelBuilder: (value) => l10n.incrementSuffix(value),
                onChanged: (value) => setState(() => _increment = value!),
              ),
              const SizedBox(height: 32),

              // Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.previewLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      TimeControl(
                        (_minutes * 60) + _seconds,
                        _increment,
                        AppLocalizations.of(context).previewLabel,
                      ).toString(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const _TimeDropdown({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(
          labelBuilder(item),
          style: theme.textTheme.bodyLarge,
        ),
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: theme.colorScheme.surface,
      icon: Icon(
        Icons.arrow_drop_down,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      style: theme.textTheme.bodyLarge,
    );
  }
}