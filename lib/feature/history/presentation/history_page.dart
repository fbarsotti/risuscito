import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';
import 'package:risuscito/core/presentation/states/rs_failure_view.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';

import 'bloc/history_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final myListKey = GlobalKey<AnimatedListState>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context)!.translate('history')!),
        previousPageTitle: AppLocalizations.of(context)!.translate('home'),
        trailing: CupertinoButton(
          // color: Colors.red,
          padding: EdgeInsets.all(1.0),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: Text(
                  AppLocalizations.of(context)!.translate('history_delete')!,
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      BlocProvider.of<HistoryBloc>(context).add(
                        DeleteHistory(),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('continue')!,
                      style: TextStyle(color: CupertinoColors.systemRed),
                    ),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text(AppLocalizations.of(context)!.translate('cancel')!),
                ),
              ),
            );
          },
          child: Icon(
            CupertinoIcons.trash,
          ),
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoaded) {
              if (state.songs.isEmpty)
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          child: EmptyPageMessage(
                            icon: CupertinoIcons.refresh_circled,
                            title: AppLocalizations.of(context)!
                                .translate('history_empty')!,
                            subtitle: AppLocalizations.of(context)!
                                .translate('history_empty_full')!,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              else {
                final historySongs = state.songs;
                return ListView.builder(
                  key: myListKey,
                  itemCount: historySongs.length,
                  itemBuilder: (context, index) {
                    // return SwipeActionCell(
                    //   key: ObjectKey(index),
                    //   trailingActions: <SwipeAction>[
                    //     SwipeAction(
                    //       color: CupertinoColors.systemRed,
                    //       icon: Icon(
                    //         CupertinoIcons.trash,
                    //         color: CupertinoColors.white,
                    //       ),
                    //       onTap: (CompletionHandler handler) async {
                    //         /// await handler(true) : will delete this row
                    //         /// And after delete animation,setState will called to
                    //         /// sync your data source with your UI

                    //         await handler(true);
                    //         BlocProvider.of<HistoryBloc>(context).add(
                    //           RemoveFromHistory(
                    //             songId: historySongs[index].id!,
                    //             reload: false,
                    //           ),
                    //         );

                    //         setState(() {
                    //           historySongs.remove(historySongs[index]);
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // child: SongTile(
                    return SongTile(
                      song: historySongs[index],
                      forceRef: false,
                      divider: index != historySongs.length - 1,
                      // ),
                    );
                  },
                );
              }
            } else if (state is HistoryFailure)
              return RSFailureView(failure: state.failure);
            else
              return RSLoadingView();
          },
        ),
      ),
    );
  }
}
