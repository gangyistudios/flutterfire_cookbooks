import 'package:flutter/material.dart';
import 'package:flutterfire_cookbooks/model/order_model.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;
  const OrderTile({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Text(order.firstName[0]),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${order.firstName} ${order.lastName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              order.number,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
