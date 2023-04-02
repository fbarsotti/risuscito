import 'package:flutter/material.dart';

import '../../infrastructure/error/types/failures.dart';
import '../../infrastructure/localization/app_localizations.dart';
import '../../infrastructure/report/report_manager.dart';

class SLFailureView extends StatelessWidget {
  final Failure failure;
  final Function? refresh;
  final String? refreshText;
  final Color iconColor;

  const SLFailureView({
    Key? key,
    required this.failure,
    this.refresh,
    this.refreshText,
    this.iconColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Icon(
              Icons.error,
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
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.translate('show_error')!,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(failure.localizedDescription(context)!),
                    content: SelectableText(failure.e.toString()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.translate('ok')!),
                      ),
                      TextButton(
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
