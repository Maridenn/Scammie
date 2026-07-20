import 'package:flutter/material.dart';

class QuickRepliesBar extends StatelessWidget {
  final List<String> quickReplies;
  final ValueChanged<String> onReplySelected;

  const QuickRepliesBar({
    super.key,
    required this.quickReplies,
    required this.onReplySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        itemCount: quickReplies.length,
        itemBuilder: (context, index) {
          final reply = quickReplies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ActionChip(
              label: Text(reply),
              labelStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14.0,
              ),
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
              onPressed: () => onReplySelected(reply),
            ),
          );
        },
      ),
    );
  }
}
