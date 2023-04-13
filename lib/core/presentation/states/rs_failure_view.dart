import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';

import '../../infrastructure/error/types/failures.dart';
import '../../infrastructure/localization/app_localizations.dart';
import '../../infrastructure/report/report_manager.dart';

class RSFailureView extends StatelessWidget {
  final Failure failure;
  final Function? refresh;
  final String? refreshText;
  final Color iconColor;

  const RSFailureView({
    Key? key,
    required this.failure,
    this.refresh,
    this.refreshText,
    this.iconColor = CupertinoColors.inactiveGray,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Icon(
              CupertinoIcons.exclamationmark,
              size: 70, //overflow
              color: iconColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              failure.localizedDescription(context) ?? '',
              textAlign: TextAlign.center,
            ),
          ),
          if (refresh != null)
            const SizedBox(
              height: 12,
            ),
          CupertinoButton(
            child: Text(
              AppLocalizations.of(context)!.translate('show_error')!,
              style: TextStyle(
                color: RSColors.primary,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(failure.localizedDescription(context)!),
                    content: Text(failure.e.toString()),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.translate('ok')!),
                      ),
                      CupertinoDialogAction(
                        onPressed: () async {
                          RSReportManager.sendEmail(
                            context,
                            failure: failure,
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('bug_report_alert')!,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          if (refresh != null)
            TextButton(
              child: Text(
                refreshText ??
                    AppLocalizations.of(context)!.translate('refresh')!,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              onPressed: refresh as void Function()?,
            )
        ],
      ),
    );
  }
}
