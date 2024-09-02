import 'package:flutter/material.dart';

String removeMarkdown(String markdownText) {
  final markdown = markdownText
      .replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), '') // Remove images
      .replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '') // Remove links
      .replaceAll(RegExp(r'```.*?```', dotAll: true), '') // Remove code blocks
      .replaceAll(RegExp(r'`.*?`'), '') // Remove inline code
      .replaceAll(RegExp(r'#\s*'), '') // Remove headers
      .replaceAll(RegExp(r'\*\*|__'), '') // Remove bold
      .replaceAll(RegExp(r'\*|_'), '') // Remove italic
      .replaceAll(
          RegExp(r'^\s*[-*]\s+', multiLine: true), '') // Remove list bullets
      .replaceAll(
          RegExp(r'^\s*\d+\.\s+', multiLine: true), '') // Remove numbered lists
      .replaceAll(RegExp(r'\n\s*\n'), '\n') // Remove empty lines
      .replaceAll(RegExp(r'^\s+|\s+$', multiLine: true),
          ''); // Trim leading/trailing whitespace

  return markdown.trim();
}

void insertLineBreak(TextEditingController controller, TextSelection selection,
    Function(TextSelection) updateSelection) {
  if (selection.isValid) {
    final lineBreak = '\n---\n'; // Line break Markdown syntax

    controller.value = controller.value.copyWith(
      text: controller.text
          .replaceRange(selection.start, selection.end, lineBreak),
      selection:
          TextSelection.collapsed(offset: selection.start + lineBreak.length),
    );
    updateSelection(controller.selection);
  }
}

void applyMarkdown(TextEditingController controller, TextSelection selection,
    String prefix, String suffix, Function(TextSelection) updateSelection) {
  if (selection.isValid) {
    final selectedText =
        controller.text.substring(selection.start, selection.end);
    String newText = '$prefix$selectedText$suffix';

    controller.value = controller.value.copyWith(
      text:
          controller.text.replaceRange(selection.start, selection.end, newText),
      selection:
          TextSelection.collapsed(offset: selection.start + newText.length),
    );
    updateSelection(controller.selection);
  }
}

// void applyLinkOrImage(
//   BuildContext context,
//   TextEditingController controller,
//   TextSelection selection,
//   String prefix,
//   String suffix,
//   Function(TextSelection) updateSelection,
// ) async {
//   if (selection.isValid) {
//     final selectedText =
//         controller.text.substring(selection.start, selection.end);
//     String linkOrImageMarkdown = '$prefix$selectedText$suffix';

//     controller.value = controller.value.copyWith(
//       text: controller.text
//           .replaceRange(selection.start, selection.end, linkOrImageMarkdown),
//       selection: TextSelection.collapsed(
//           offset: selection.start + linkOrImageMarkdown.length),
//     );
//     updateSelection(controller.selection);
//   }
// }





void applyLinkOrImage(BuildContext context, TextEditingController controller,
    String prefix, String suffix) {
  final TextSelection selection = controller.selection;

  if (selection.isValid) {
    final selectedText =
        controller.text.substring(selection.start, selection.end);
    final textBeforeSelection = controller.text.substring(0, selection.start);
    final textAfterSelection = controller.text.substring(selection.end);

    final isLink = suffix.contains('url');
    final prompt = isLink ? 'Enter URL' : 'Enter Image URL';
    final userInput =
        isLink ? 'https://example.com' : 'https://example.com/image.png';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController urlController = TextEditingController();
        urlController.text = userInput;

        return AlertDialog(
          title: Text(prompt),
          content: TextField(
            controller: urlController,
            decoration: InputDecoration(hintText: 'URL'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final url = urlController.text;
                final newText =
                    '$prefix$selectedText${suffix.replaceAll('url', url)}';
                controller.value = controller.value.copyWith(
                  text: '$textBeforeSelection$newText$textAfterSelection',
                  selection: TextSelection.collapsed(
                      offset: selection.start + newText.length),
                );
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
