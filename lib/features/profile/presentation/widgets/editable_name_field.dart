import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Represents EditableNameField.
class EditableNameField extends StatefulWidget {
  const EditableNameField({super.key, required this.name, required this.isSaving, required this.onSave});

  final String name;

  /// The is saving property.
  final bool isSaving;
  final ValueChanged<String> onSave;

  @override
  State<EditableNameField> createState() => _EditableNameFieldState();
}

class _EditableNameFieldState extends State<EditableNameField> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  late final TextEditingController _textController = TextEditingController(text: widget.name);
  bool _isEditing = false;

  @override
  void didUpdateWidget(covariant EditableNameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the field in sync if the name changes from outside (e.g. a
    // successful save updates AuthBloc's state, which flows back here)
    // — but only when the user isn't actively mid-edit, so we don't
    // overwrite what they're typing.
    if (oldWidget.name != widget.name && !_isEditing) {
      _textController.text = widget.name;
    }
    // The in-flight save just resolved (success or error) — collapse
    // the field. On error the user can tap edit again to retry; the
    // failure itself is already surfaced via a SnackBar by the parent.
    if (oldWidget.isSaving && !widget.isSaving && _isEditing) {
      _toggleEdit();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
    _isEditing ? _controller.forward() : _controller.reverse();
  }

  void _save() {
    final newName = _textController.text.trim();
    if (newName.isEmpty || newName == widget.name) {
      _toggleEdit();
      return;
    }
    // Deliberately NOT collapsing here — stays open (showing the
    // spinner below) until `isSaving` flips back to false above, so
    // there's visible feedback for however long the network call takes.
    widget.onSave(newName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.name,
                style: Theme.of(context).textTheme.headlineMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                _isEditing ? Icons.close_rounded : Icons.edit_outlined,
                size: 20,
                color: AppColors.textSecondary,
              ),
              onPressed: widget.isSaving ? null : _toggleEdit,
            ),
          ],
        ),
        SizeTransition(
          sizeFactor: _controller,
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    enabled: !widget.isSaving,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(hintText: 'Your name'),
                    onSubmitted: (_) => _save(),
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.isSaving)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: AppColors.primary),
                    onPressed: _save,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
