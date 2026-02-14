import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhatsNewOnboardingPage extends StatelessWidget {
  const WhatsNewOnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoOnboarding(
        bottomButtonChild:
            Text(AppLocalizations.of(context)!.translate('continue')!),
        onPressedOnLastPage: () async {
          SharedPreferences prefs = rs();
          await prefs.setBool('whats_new_v2', false);
          Navigator.of(context).pop();
        },
        pages: [
          WhatsNewPage(
            title: Text(AppLocalizations.of(context)!
                .translate('whats_new_welcome')!),
            features: [
              WhatsNewFeature(
                icon: Icon(
                  CupertinoIcons.list_bullet,
                  color: RSColors.primary,
                ),
                title: Text(
                  AppLocalizations.of(context)!
                      .translate('personalized_lists')!,
                ),
                description: Text(
                  AppLocalizations.of(context)!
                      .translate('onboarding_lists')!,
                ),
              ),
              WhatsNewFeature(
                icon: Icon(
                  CupertinoIcons.music_note,
                  color: RSColors.primary,
                ),
                title: Text(
                  AppLocalizations.of(context)!
                      .translate('onboarding_transpose_title')!,
                ),
                description: Text(
                  AppLocalizations.of(context)!
                      .translate('onboarding_transpose')!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
