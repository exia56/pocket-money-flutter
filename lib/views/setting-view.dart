import 'package:flutter/material.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/views/index.dart';
import 'package:pocket_money/utils/index.dart';

class SettingView extends StatelessWidget {
  static const route = 'SettingView';

  final _logger = createLogger(SettingView.route);

  Widget settingRow(BuildContext context, String str, void Function() onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                str,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            settingRow(context, '同步', () async {
              final User? user = await Navigator.of(context)
                  .pushNamed(SignInView.route) as User?;
              if (user != null) {
                _logger.d(user.id);
                Navigator.of(context).pushNamed(SyncDataView.route,
                    arguments: SyncViewParam(user));
              }
            }),
          ],
        ),
      ),
    );
  }
}
