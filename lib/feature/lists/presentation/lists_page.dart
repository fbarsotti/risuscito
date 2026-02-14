import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';
import 'package:risuscito/core/presentation/states/rs_failure_view.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/lists/domain/model/list_domain_model.dart';
import 'package:risuscito/feature/lists/presentation/bloc/lists_bloc.dart';
import 'package:risuscito/feature/lists/presentation/list_detail_page.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  late List<ListDomainModel> lists;

  void _showCreateDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('new_list')!,
          ),
          content: Column(
            children: [
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: titleController,
                placeholder:
                    AppLocalizations.of(context)!.translate('list_title'),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: descriptionController,
                placeholder:
                    AppLocalizations.of(context)!.translate('list_description'),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                AppLocalizations.of(context)!.translate('cancel')!,
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  BlocProvider.of<ListsBloc>(context).add(
                    ListsCreateListEvent(
                      name: title,
                      description: descriptionController.text.trim(),
                      languageCode:
                          AppLocalizations.of(context)!.locale.languageCode,
                    ),
                  );
                }
                Navigator.pop(dialogContext);
              },
              child: Text(
                AppLocalizations.of(context)!.translate('create')!,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          AppLocalizations.of(context)!.translate('personalized_lists')!,
        ),
        previousPageTitle: AppLocalizations.of(context)!.translate('home'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: _showCreateDialog,
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<ListsBloc, ListsState>(
          builder: (context, state) {
            if (state is ListsLoaded) {
              lists = state.lists;
              if (lists.isEmpty) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          child: EmptyPageMessage(
                            icon: CupertinoIcons
                                .rectangle_stack_badge_person_crop,
                            title: AppLocalizations.of(context)!
                                .translate('no_lists')!,
                            subtitle: AppLocalizations.of(context)!
                                .translate('no_lists_full')!,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  itemCount: lists.length,
                  itemBuilder: (context, index) {
                    final list = lists[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SwipeActionCell(
                          key: ObjectKey(list.id),
                          trailingActions: <SwipeAction>[
                            SwipeAction(
                              color: CupertinoColors.systemRed,
                              icon: const Icon(
                                CupertinoIcons.trash,
                                color: CupertinoColors.white,
                              ),
                              onTap: (CompletionHandler handler) async {
                                await handler(true);
                                BlocProvider.of<ListsBloc>(context).add(
                                  ListsDeleteListEvent(
                                    listId: list.id,
                                    languageCode:
                                        AppLocalizations.of(context)!
                                            .locale
                                            .languageCode,
                                  ),
                                );
                              },
                            ),
                          ],
                          child: CupertinoButton(
                            pressedOpacity:
                                themeChange.darkTheme ? 0.8 : 0.4,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => ListDetailPage(
                                    list: list,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: themeChange.darkTheme
                                ? RSColors.cardColorDark
                                : RSColors.cardColorLight,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons
                                          .rectangle_stack_badge_person_crop,
                                      color: RSColors.primary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${list.songs?.length ?? 0} ${AppLocalizations.of(context)!.translate('songs_count')}',
                                      style: TextStyle(
                                        color: RSColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      CupertinoIcons.chevron_right,
                                      color: RSColors.primary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  list.name,
                                  style: TextStyle(
                                    color: themeChange.darkTheme
                                        ? RSColors.darkText
                                        : RSColors.text,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (list.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    list.description,
                                    style: TextStyle(
                                      color: CupertinoColors.inactiveGray,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ),
                    );
                  },
                );
              }
            } else if (state is ListsFailure) {
              return RSFailureView(failure: state.failure);
            } else {
              return RSLoadingView();
            }
          },
        ),
      ),
    );
  }
}
