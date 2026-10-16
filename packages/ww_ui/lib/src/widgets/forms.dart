import 'package:flutter/material.dart';

import '../tokens.dart';

/// Label above a form field.
class WWFieldLabel extends StatelessWidget {
  const WWFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: WWSpacing.sm),
      child: Text(text, style: WWType.cardTitle.copyWith(fontSize: 14)),
    );
  }
}

/// Tappable field that shows a picked date or time (opens the picker given by the screen).
class WWDateField extends StatelessWidget {
  const WWDateField({
    super.key,
    required this.text,
    required this.placeholder,
    required this.onTap,
    this.errorText,
    this.icon = Icons.calendar_today_outlined,
  });

  /// Calendar by default; a clock for a time.
  final IconData icon;

  /// Formatted date, or null when nothing is picked yet.
  final String? text;
  final String placeholder;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(WWRadius.field),
      child: InputDecorator(
        decoration: InputDecoration(
          errorText: errorText,
          suffixIcon: Icon(icon, size: 20, color: WWColors.textSecondary),
        ),
        child: Text(
          text ?? placeholder,
          style: WWType.body.copyWith(color: text == null ? WWColors.textSecondary : null),
        ),
      ),
    );
  }
}

class WWChoice<T> {
  const WWChoice({required this.value, required this.label, this.enabled = true, this.key});

  final T value;
  final String label;

  /// False: shown greyed out and can't be picked (a blocked date).
  final bool enabled;

  /// For tests (`find.byKey`).
  final Key? key;
}

/// One-of-many pill buttons (gender, language, date, time), styled like the mockup's date/time
/// pills. [scrollable]: one line that scrolls sideways (the date strip), with [trailing] at its end.
class WWChoicePills<T> extends StatelessWidget {
  const WWChoicePills({
    super.key,
    required this.choices,
    required this.selected,
    required this.onSelected,
    this.errorText,
    this.scrollable = false,
    this.scrollController,
    this.trailing,
  });

  final List<WWChoice<T>> choices;
  final T? selected;
  final ValueChanged<T> onSelected;
  final String? errorText;
  final bool scrollable;
  final ScrollController? scrollController;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final pills = [
      for (final choice in choices)
        _Pill(
          key: choice.key,
          label: choice.label,
          selected: choice.value == selected,
          onTap: choice.enabled ? () => onSelected(choice.value) : null,
        ),
      ?trailing,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (scrollable)
          SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final pill in pills) ...[pill, const SizedBox(width: WWSpacing.sm)],
              ],
            ),
          )
        else
          Wrap(spacing: WWSpacing.sm, runSpacing: WWSpacing.sm, children: pills),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: WWType.caption.copyWith(color: WWColors.danger)),
        ],
      ],
    );
  }
}

/// Many-of-many pill buttons (languages, skills). Same look as [WWChoicePills].
class WWMultiChoicePills<T> extends StatelessWidget {
  const WWMultiChoicePills({
    super.key,
    required this.choices,
    required this.selected,
    required this.onChanged,
    this.errorText,
  });

  final List<WWChoice<T>> choices;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: WWSpacing.sm,
          runSpacing: WWSpacing.sm,
          children: [
            for (final choice in choices)
              _Pill(
                label: choice.label,
                selected: selected.contains(choice.value),
                onTap: () {
                  final next = {...selected};
                  if (!next.remove(choice.value)) next.add(choice.value);
                  onChanged(next);
                },
              ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: WWType.caption.copyWith(color: WWColors.danger)),
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;

  /// Null: greyed out.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      selected: selected,
      enabled: enabled,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(WWRadius.chip),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          // at least 48 dp tall: Android's tap target guideline (PHASES 9.8)
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            color: selected ? WWColors.primary : WWColors.surface,
            borderRadius: BorderRadius.circular(WWRadius.chip),
            border: Border.all(color: selected ? WWColors.primary : WWColors.border),
          ),
          // centred in its 48 dp without growing wider than the label (a Wrap gives it the row)
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(
              label,
              style: WWType.body.copyWith(
                color: selected
                    ? Colors.white
                    : enabled
                    ? WWColors.textPrimary
                    : WWColors.textSecondary.withValues(alpha: 0.5),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                decoration: enabled ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Checkbox with a title and a short explanation (consent screen).
class WWCheckTile extends StatelessWidget {
  const WWCheckTile({super.key, required this.value, required this.onChanged, required this.title, this.detail});

  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    // One control for TalkBack: "title, detail, checked", the whole card as its tap area (the
    // small box inside isn't a second, nameless target; PHASES 9.8)
    return MergeSemantics(
      child: Semantics(checked: value, child: _tile()),
    );
  }

  Widget _tile() {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(WWRadius.card),
      child: Container(
        padding: const EdgeInsets.all(WWSpacing.md),
        decoration: BoxDecoration(
          color: WWColors.surface,
          borderRadius: BorderRadius.circular(WWRadius.card),
          border: Border.all(color: value ? WWColors.primary : WWColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: WWSpacing.xs),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: WWType.cardTitle.copyWith(fontSize: 14)),
                    if (detail != null) ...[const SizedBox(height: 2), Text(detail!, style: WWType.caption)],
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
