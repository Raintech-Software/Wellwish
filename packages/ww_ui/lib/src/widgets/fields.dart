import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens.dart';

/// Plain text field in the WellWish style.
class WWTextField extends StatelessWidget {
  const WWTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.autofillHints,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  /// More than 1 for notes (the field grows up to this many lines).
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      style: WWType.body,
      decoration: InputDecoration(labelText: label, hintText: hint, errorText: errorText),
    );
  }
}

/// Indian mobile number field: fixed "🇮🇳 +91" prefix, 10 digits only (ARCHITECTURE §6.2).
class WWPhoneField extends StatelessWidget {
  const WWPhoneField({super.key, this.controller, this.hint, this.errorText, this.onChanged});

  final TextEditingController? controller;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
      onChanged: onChanged,
      style: WWType.body.copyWith(letterSpacing: 0.5),
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇮🇳', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text('+91', style: WWType.body.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Container(width: 1, height: 22, color: WWColors.border),
            ],
          ),
        ),
      ),
    );
  }
}

/// 6-box OTP entry. One hidden text field drives the boxes, so paste and
/// Android SMS auto-read (one-time-code autofill) both work.
class WWOtpField extends StatefulWidget {
  const WWOtpField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false,
    this.autofocus = true,
    this.controller,
    this.semanticLabel,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;
  final bool autofocus;

  /// Optional: lets the screen fill in a code read from the SMS, or clear the boxes.
  final TextEditingController? controller;

  /// What TalkBack says for the field, e.g. "The 6-digit code" (PHASES 9.8).
  final String? semanticLabel;

  @override
  State<WWOtpField> createState() => _WWOtpFieldState();
}

class _WWOtpFieldState extends State<WWOtpField> {
  late final TextEditingController _controller = widget.controller ?? TextEditingController();
  final _focus = FocusNode();
  String _lastValue = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Typing, pasting, SMS autofill and the screen setting the text all end up here.
  void _onControllerChanged() {
    final value = _controller.text;
    if (value == _lastValue) return;
    _lastValue = value;
    setState(() {});
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      widget.onCompleted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;
    return GestureDetector(
      onTap: () => _focus.requestFocus(),
      // TalkBack reaches the text field itself (labelled below), not a second, nameless tap area
      excludeFromSemantics: true,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length, (i) {
              final filled = i < code.length;
              final active = i == code.length && _focus.hasFocus;
              final borderColor = widget.hasError ? WWColors.danger : (active ? WWColors.primary : WWColors.border);
              return Container(
                width: 46,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: WWColors.surface,
                  borderRadius: BorderRadius.circular(WWRadius.field),
                  border: Border.all(color: borderColor, width: active ? 1.6 : 1),
                ),
                child: Text(filled ? code[i] : '', style: WWType.section.copyWith(fontSize: 20)),
              );
            }),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              // invisible, but TalkBack must still find the field (it is the one to type in)
              alwaysIncludeSemantics: true,
              child: TextField(
                key: const Key('ww-otp-input'),
                // the code typed so far is read out with the label
                decoration: InputDecoration(border: InputBorder.none, counterText: '', labelText: widget.semanticLabel),
                controller: _controller,
                focusNode: _focus,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                showCursor: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Search box with a magnifier (mockup 4: "Search doctor by name…").
class WWSearchField extends StatelessWidget {
  const WWSearchField({super.key, this.controller, required this.hint, this.onChanged});

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: WWType.body,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: WWColors.textSecondary),
        isDense: true,
      ),
    );
  }
}
