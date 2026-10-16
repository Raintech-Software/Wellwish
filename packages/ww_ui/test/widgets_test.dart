import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ww_ui/ww_ui.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: WWTheme.light(),
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  testWidgets('primary button shows label and calls onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(WWPrimaryButton(label: 'Send OTP', onPressed: () => taps++)));
    await tester.tap(find.text('Send OTP'));
    expect(taps, 1);
  });

  testWidgets('primary button is disabled while loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(WWPrimaryButton(label: 'Send OTP', loading: true, onPressed: () => taps++)));
    expect(find.text('Send OTP'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    expect(taps, 0);
  });

  testWidgets('phone field shows +91 and keeps only 10 digits', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(_wrap(WWPhoneField(controller: controller)));
    expect(find.text('+91'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '98a765-432109999');
    expect(controller.text, '9876543210');
  });

  testWidgets('OTP field reports the code once 6 digits are entered', (tester) async {
    String? completed;
    await tester.pumpWidget(_wrap(WWOtpField(onCompleted: (code) => completed = code)));
    await tester.enterText(find.byKey(const Key('ww-otp-input')), '12345');
    await tester.pump();
    expect(completed, isNull);
    await tester.enterText(find.byKey(const Key('ww-otp-input')), '123456');
    await tester.pump();
    expect(completed, '123456');
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('list tile shows title, subtitle and handles taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        WWListTile(
          icon: Icons.family_restroom,
          title: 'My Family Members',
          subtitle: '3 Members',
          onTap: () => tapped = true,
        ),
      ),
    );
    await tester.tap(find.text('My Family Members'));
    expect(find.text('3 Members'), findsOneWidget);
    expect(tapped, isTrue);
  });

  testWidgets('bottom nav switches tabs', (tester) async {
    var index = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: WWTheme.light(),
        home: Scaffold(
          bottomNavigationBar: WWBottomNav(
            currentIndex: 0,
            onTap: (i) => index = i,
            items: const [
              WWNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
              WWNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Profile'));
    expect(index, 1);
  });

  testWidgets('error state shows message and retries', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      _wrap(WWErrorState(message: 'Something went wrong.', retryLabel: 'Try again', onRetry: () => retried = true)),
    );
    await tester.tap(find.text('Try again'));
    expect(retried, isTrue);
  });

  testWidgets('splash shows the official logo lockup and optional badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: WWTheme.light(),
        home: const WWSplash(semanticLabel: 'WellWish', badge: 'Partner'),
      ),
    );
    expect(find.byType(WWLogoLockup), findsOneWidget);
    expect(find.bySemanticsLabel('WellWish'), findsOneWidget);
    expect(find.byKey(const Key('ww-splash-badge')), findsOneWidget);
    expect(find.text('Partner'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('patient splash has no badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: WWTheme.light(),
        home: const WWSplash(semanticLabel: 'WellWish'),
      ),
    );
    expect(find.byKey(const Key('ww-splash-badge')), findsNothing);
  });

  testWidgets('OTP field can be filled by the screen (SMS auto-read)', (tester) async {
    String? completed;
    final controller = TextEditingController();
    await tester.pumpWidget(_wrap(WWOtpField(controller: controller, onCompleted: (code) => completed = code)));
    controller.text = '482910';
    await tester.pump();
    expect(completed, '482910');
    expect(find.text('4'), findsOneWidget);
    controller.clear();
    await tester.pump();
    expect(find.text('4'), findsNothing);
  });

  testWidgets('auth layout shows logo, title, badge and footer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: WWTheme.light(),
        home: const WWAuthLayout(
          title: 'Welcome Back',
          subtitle: 'Login to continue',
          badge: 'Partner',
          footer: Text('New here?'),
          children: [WWPhoneField(hint: 'Enter mobile number')],
        ),
      ),
    );
    expect(find.byType(WWLogoLockup), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Partner'), findsOneWidget);
    expect(find.text('New here?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('choice pills select one value', (tester) async {
    String? picked;
    await tester.pumpWidget(
      _wrap(
        WWChoicePills<String>(
          choices: const [
            WWChoice(value: 'FEMALE', label: 'Female'),
            WWChoice(value: 'MALE', label: 'Male'),
          ],
          selected: 'FEMALE',
          errorText: null,
          onSelected: (v) => picked = v,
        ),
      ),
    );
    await tester.tap(find.text('Male'));
    expect(picked, 'MALE');
  });

  testWidgets('check tile toggles from anywhere on the tile', (tester) async {
    var value = false;
    await tester.pumpWidget(
      _wrap(
        WWCheckTile(
          value: false,
          onChanged: (v) => value = v,
          title: 'I accept the Terms of Use',
          detail: 'How bookings work.',
        ),
      ),
    );
    await tester.tap(find.text('How bookings work.'));
    expect(value, isTrue);
  });

  testWidgets('feature tile shows a coming-soon badge', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 160,
          height: 180,
          child: WWFeatureTile(
            icon: Icons.medical_services_outlined,
            label: 'Doctors',
            badge: 'Coming soon',
            onTap: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Doctors'));
    expect(find.text('Coming soon'), findsOneWidget);
    expect(taps, 1);
  });

  testWidgets('avatar shows initials', (tester) async {
    await tester.pumpWidget(_wrap(const WWAvatar(name: 'Priyansu Gouda')));
    expect(find.text('PG'), findsOneWidget);
  });

  testWidgets('tap targets: the consent tile, a link and the choice pills are big enough and named (9.8)', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var checked = false;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              WWCheckTile(
                value: checked,
                onChanged: (v) => setState(() => checked = v),
                title: 'I agree to the terms',
                detail: 'Version 1',
              ),
              WWLinkButton(label: 'Create Account', onPressed: () {}),
              WWChoicePills<String>(
                choices: const [
                  WWChoice(value: 'a', label: 'Today'),
                  WWChoice(value: 'b', label: 'Tomorrow'),
                ],
                selected: 'a',
                onSelected: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    // the tile is one control that says whether it's ticked
    expect(
      tester.getSemantics(find.byType(WWCheckTile)),
      matchesSemantics(
        label: 'I agree to the terms\nVersion 1',
        hasCheckedState: true,
        isChecked: false,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );
    await tester.tap(find.text('I agree to the terms'));
    await tester.pump();
    expect(checked, isTrue);
    semantics.dispose();
  });

  testWidgets('pills in a wrapping row stay as wide as their label (deep check 9.8)', (tester) async {
    await tester.pumpWidget(
      _wrap(
        WWChoicePills<String>(
          choices: const [
            WWChoice(value: 'f', label: 'Female'),
            WWChoice(value: 'm', label: 'Male'),
          ],
          selected: 'f',
          onSelected: (_) {},
        ),
      ),
    );
    final female = tester.getRect(find.ancestor(of: find.text('Female'), matching: find.byType(AnimatedContainer)));
    final male = tester.getRect(find.ancestor(of: find.text('Male'), matching: find.byType(AnimatedContainer)));
    expect(female.width, lessThan(200));
    expect(female.height, greaterThanOrEqualTo(48));
    expect(male.top, female.top); // side by side, not one per line
  });

  testWidgets('TalkBack finds the code field by its name (deep check 9.8)', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_wrap(WWOtpField(onCompleted: (_) {}, semanticLabel: 'The 6-digit code')));
    expect(find.bySemanticsLabel('The 6-digit code'), findsOneWidget);
    semantics.dispose();
  });
}
