import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _NotificationCard(
          title: 'سلة ممتلئة',
          message: 'سلة الشارع الرئيسي ممتلئة ويجب تفريغها',
          time: 'منذ 5 دقائق',
          isUrgent: true,
        ),
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
