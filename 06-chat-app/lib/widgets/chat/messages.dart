import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (_, snapshot) {
        final docs = snapshot.data?.docs;
        final currentUserID = FirebaseAuth.instance.currentUser?.uid;
        if (snapshot.connectionState == ConnectionState.waiting || docs == null || currentUserID == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (_, index) {
            return MessageBubble(
              key: ValueKey(docs[index].id),
              message: docs[index]['text'],
              isMe: docs[index]['userID'] == currentUserID,
              username: docs[index]['username'],
              imageUrl: docs[index]['userImage'],
            );
          },
        );
      },
    );
  }
}
