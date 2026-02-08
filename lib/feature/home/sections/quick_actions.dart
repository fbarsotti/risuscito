import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/header_text.dart';
import 'package:risuscito/core/presentation/quick_action_button.dart';
import 'package:risuscito/feature/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:risuscito/feature/favourites/presentation/favourites_page.dart';
import 'package:risuscito/feature/history/presentation/bloc/history_bloc.dart';
import 'package:risuscito/feature/history/presentation/history_page.dart';
import 'package:risuscito/feature/lists/presentation/bloc/lists_bloc.dart';
import 'package:risuscito/feature/lists/presentation/lists_page.dart';

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
                onTap: () {
                  BlocProvider.of<FavouritesBloc>(context).add(
                    GetLocalizedFavourites(
                      languageCode:
                          AppLocalizations.of(context)!.locale.languageCode,
                    ),
                  );
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => FavouritesPage(),
                    ),
                  );
                },
              ),
              QuickActionButton(
                text: AppLocalizations.of(context)!
                    .translate('personalized_lists')!,
                icon: CupertinoIcons.rectangle_stack_badge_person_crop,
                iconColor: CupertinoColors.systemRed,
                onTap: () {
                  BlocProvider.of<ListsBloc>(context).add(
                    ListsGetAllListsEvent(
                      languageCode:
                          AppLocalizations.of(context)!.locale.languageCode,
                    ),
                  );
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => ListsPage(),
                    ),
                  );
                },
              ),
              QuickActionButton(
                text: AppLocalizations.of(context)!.translate('history')!,
                icon: CupertinoIcons.refresh_circled,
                iconColor: CupertinoColors.systemBlue,
                onTap: () {
                  BlocProvider.of<HistoryBloc>(context).add(
                    GetLocalizedHistory(
                      languageCode:
                          AppLocalizations.of(context)!.locale.languageCode,
                    ),
                  );
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => HistoryPage(),
                    ),
                  );
                },
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
