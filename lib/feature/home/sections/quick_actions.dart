import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/header_text.dart';
import 'package:risuscito/core/presentation/quick_action_button.dart';
import 'package:risuscito/feature/favourites/presentation/favourites_page.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: HeaderText(
            text: AppLocalizations.of(context)!.translate('quick_actions')!,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 230,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(
                width: 8,
              ),
              QuickActionButton(
                  text: AppLocalizations.of(context)!.translate('favourites')!,
                  icon: CupertinoIcons.text_badge_star,
                  iconColor: CupertinoColors.systemYellow,
                  onTap: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => FavouritesPage(),
                        ),
                      )),
              QuickActionButton(
                text: AppLocalizations.of(context)!
                    .translate('personalized_lists')!,
                icon: CupertinoIcons.rectangle_stack_badge_person_crop,
                iconColor: CupertinoColors.systemRed,
                onTap: null,
              ),
              QuickActionButton(
                text: AppLocalizations.of(context)!.translate('history')!,
                icon: CupertinoIcons.refresh_circled,
                iconColor: CupertinoColors.systemBlue,
                onTap: null,
              ),
              const SizedBox(
                width: 8,
              ),
              // QuickActionButton(
              //   text: 'Impostazioni',
              //   icon: CupertinoIcons.settings,
              //   iconColor: CupertinoColors.inactiveGray,
              // ),
            ],
          ),
        )
      ],
    );
  }
}
