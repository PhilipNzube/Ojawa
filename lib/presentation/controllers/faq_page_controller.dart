import 'package:flutter/material.dart';

import '../../data/model/faq_item_model.dart';

class FaqPageController extends ChangeNotifier {
  final List<FaqItem> _faqItems = [
    FaqItem(
      question: "Nostrum facilis?",
      answer:
          "Nostrum facilis voluptatum voluptates sunt facere, distinctio ullam aspernatur cumque autem a esse non unde, nemo iusto",
    ),
    FaqItem(
      question: "voluptatum voluptates?",
      answer:
          "Nostrum facilis voluptatum voluptates sunt facere, distinctio ullam aspernatur cumque autem a esse non unde, nemo iusto!",
    ),
    FaqItem(
      question: "sunt facere?",
      answer:
          "Nostrum facilis voluptatum voluptates sunt facere, distinctio ullam aspernatur cumque autem a esse non unde, nemo iusto!",
    ),
  ];

  //public getters
  List<FaqItem> get faqItems => _faqItems;
}
