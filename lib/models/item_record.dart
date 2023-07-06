// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:listify/models/voice.dart';

class ItemRecord {
  final Voice voice;
  bool isExpanded;
  ItemRecord({
    required this.voice,
    this.isExpanded = false,
  });

  ItemRecord copyWith({
    Voice? voice,
    bool? isExpanded,
  }) {
    return ItemRecord(
      voice: voice ?? this.voice,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
