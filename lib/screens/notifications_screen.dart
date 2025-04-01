import 'package:flutter/material.dart';
import 'package:myapp/utils/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  final AppLocalizations translations;

  const NotificationsScreen({
    super.key,
    required this.translations,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              tabs: [
                Tab(text: translations.translate('allNotifications')),
                Tab(text: translations.translate('importantNotifications')),
              ],
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).primaryColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildNotificationsList(showAll: true),
                _buildNotificationsList(showAll: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList({required bool showAll}) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        if (showAll || true)
          _NotificationCard(
            title: 'سلة ممتلئة',
            message: 'سلة الشارع الرئيسي ممتلئة ويجب تفريغها',
            time: 'منذ 5 دقائق',
            isUrgent: true,
          ),
        if (showAll)
          _NotificationCard(
            title: 'تحديث حالة',
            message: 'تم تفريغ سلة السوق المركزي',
            time: 'منذ ساعة',
            isUrgent: false,
          ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isUrgent;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.time,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          isUrgent ? Icons.warning_amber : Icons.info_outline,
          color: isUrgent ? Colors.red : Colors.blue,
        ),
        title: Text(title),
        subtitle: Text(message),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
