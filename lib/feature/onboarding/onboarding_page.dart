import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/onboarding/sections/onboarding_languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoOnboarding(
        bottomButtonChild:
            Text(AppLocalizations.of(context)!.translate('continue')!),
        onPressedOnLastPage: () async {
          Navigator.of(context).pop();
          SharedPreferences prefs = rs();
          await prefs.setBool('onboarding', false);
          await prefs.setBool('whats_new_v2', false);
        },
        pages: [
          CupertinoOnboardingPage(
            title: Text(
                AppLocalizations.of(context)!.translate('onboarding_welcome')!),
            bodyPadding: EdgeInsets.zero,
            body: Image.asset(
              'assets/images/risuscito_logo_primary.png',
              width: 400,
              height: 400,
            ),
          ),
          CupertinoOnboardingPage(
            title: Text(
                AppLocalizations.of(context)!.translate('choose_a_language')!),
            bodyPadding: EdgeInsets.zero,
            body: OnBoardingLanguage(),
          ),
          WhatsNewPage(
            title: Text(AppLocalizations.of(context)!
                .translate('onboarding_features')!),
            features: [
              WhatsNewFeature(
                icon: Icon(
                  CupertinoIcons.music_albums,
                  color: RSColors.primary,
                ),
                title: Text(
                  AppLocalizations.of(context)!.translate('songs')!,
                ),
                description: Text(
                  AppLocalizations.of(context)!.translate('onboarding_songs')!,
                ),
              ),
              WhatsNewFeature(
                icon: Icon(
                  CupertinoIcons.search,
                  color: RSColors.primary,
                ),
                title: Text(
                  AppLocalizations.of(context)!.translate('search')!,
                ),
                description: Text(
                  AppLocalizations.of(context)!.translate('onboarding_search')!,
                ),
              ),
              WhatsNewFeature(
                icon: Icon(
                  CupertinoIcons.star,
                  color: RSColors.primary,
                ),
                title: Text(
                  AppLocalizations.of(context)!.translate('favourites')!,
                ),
                description: Text(
                  AppLocalizations.of(context)!
                      .translate('onboarding_favourites')!,
                ),
              ),
            ],
          ),
          WhatsNewPage(
            title: Text(AppLocalizations.of(context)!
                .translate('onboarding_features')!),
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
