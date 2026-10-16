import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../common/booking_format.dart';
import '../common/patient_ui.dart';

/// The date strip of P12 and P30: the first week as pills, "Pick a date" for the rest. Days with
/// no free time are greyed out.

bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// "Today", "Tomorrow", else "Fri 10" (India dates; counted on UTC dates so a phone in a
/// daylight-saving time zone can't make two "Tomorrow"s).
String dayLabel(BuildContext context, DateTime day) {
  final l10n = WWLocalizations.of(context);
  final today = istToday();
  final diff = DateTime.utc(
    day.year,
    day.month,
    day.day,
  ).difference(DateTime.utc(today.year, today.month, today.day)).inDays;
  if (diff == 0) return l10n.today;
  if (diff == 1) return l10n.tomorrow;
  return DateFormat('EEE d', Localizations.localeOf(context).toString()).format(day);
}

class DateStrip extends StatelessWidget {
  const DateStrip({super.key, required this.times, required this.controller, required this.onChosen});

  /// The last loaded dates (the strip stays while another date's times load).
  final BookingTimesOut times;
  final ScrollController controller;

  /// Another day was chosen (not called for the day already shown).
  final ValueChanged<DateTime> onChosen;

  void _choose(DateTime day) {
    if (!sameDay(day, times.date)) onChosen(day);
  }

  Future<void> _pickDate(BuildContext context) async {
    final free = [
      for (final d in times.days.where((d) => d.available)) DateTime(d.date.year, d.date.month, d.date.day),
    ];
    if (free.isEmpty) return;
    final shown = DateTime(times.date.year, times.date.month, times.date.day);
    final picked = await showDatePicker(
      context: context,
      firstDate: times.days.first.date,
      lastDate: times.days.last.date,
      currentDate: istToday(),
      initialDate: free.any((d) => sameDay(d, shown)) ? shown : free.first,
      selectableDayPredicate: (day) => free.any((d) => sameDay(d, day)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) _choose(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final week = times.days.take(7);
    return WWChoicePills<DateTime>(
      scrollable: true,
      scrollController: controller,
      choices: [
        for (final d in week)
          WWChoice(
            key: Key('day-${DateFormat('yyyy-MM-dd').format(d.date)}'),
            value: DateTime(d.date.year, d.date.month, d.date.day),
            label: dayLabel(context, d.date),
            enabled: d.available,
          ),
      ],
      selected: DateTime(times.date.year, times.date.month, times.date.day),
      onSelected: _choose,
      trailing: ActionChip(
        key: const Key('day-pick'),
        avatar: const Icon(Icons.calendar_month_outlined, size: 18),
        label: Text(week.any((d) => sameDay(d.date, times.date)) ? l10n.pickADate : formatDate(context, times.date)),
        onPressed: () => _pickDate(context),
      ),
    );
  }
}

/// The free start times of the shown day as pills, with "Times are India time" below.
class TimePills extends StatelessWidget {
  const TimePills({super.key, required this.times, required this.selected, required this.onSelected});

  final BookingTimesOut times;
  final DateTime? selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final picked = selected == null ? null : times.times.where((t) => t.isAtSameMomentAs(selected!)).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (times.times.isEmpty)
          WWMessageBox(message: l10n.noTimesLeft)
        else
          WWChoicePills<DateTime>(
            choices: [
              for (final t in times.times)
                WWChoice(
                  key: Key('time-${DateFormat('HH:mm').format(toIst(t))}'),
                  value: t,
                  label: istTime(context, t),
                ),
            ],
            selected: picked,
            onSelected: onSelected,
          ),
        const SizedBox(height: WWSpacing.xs),
        Text(l10n.timesInIst, style: WWType.caption),
      ],
    );
  }
}
