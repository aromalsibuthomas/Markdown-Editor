import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editor/utils/functions.dart';
import 'package:markdown_editor/utils/markdownFunctions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  TextSelection _selection = TextSelection.collapsed(offset: -1);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _applyLinkOrImage(BuildContext context, String prefix, String suffix) {
    applyLinkOrImage(context, _controller, prefix, suffix);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: StylePanel(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Text Field
              Expanded(
                flex: 3, // Adjust flex as needed
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: _controller,
                      expands: true,

                      maxLines: null, // Allow the TextField to grow vertically
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter text here',
                      ),
                      onChanged: (text) {
                        setState(() {
                          _selection = _controller.selection;
                        });
                      },
                    ),
                  ),
                ),
              ),
              // Markdown Display
              Expanded(
                flex: 3, // Adjust flex as needed
                child: Markdown(data: _controller.text),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column StylePanel() {
    return Column(
      children: [
        Row(
          children: [
            Tooltip(
              message: 'Remove Markdown',
              child: IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  setState(() {
                    _controller.text = removeMarkdown(_controller.text);
                  });
                },
              ),
            ),
            Tooltip(
              message: 'Bold',
              child: IconButton(
                icon: Icon(Icons.format_bold),
                onPressed: () {
                  _applyMarkdown('**', '**'); // Bold
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Italic',
              child: IconButton(
                icon: Icon(Icons.format_italic),
                onPressed: () {
                  _applyMarkdown('_', '_'); // Italic
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Inline Code',
              child: IconButton(
                icon: Icon(Icons.code),
                onPressed: () {
                  _applyMarkdown('`', '`'); // Inline Code
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Strikethrough',
              child: IconButton(
                icon: Icon(Icons.strikethrough_s),
                onPressed: () {
                  _applyMarkdown('~~', '~~'); // Strikethrough
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Heading 1',
              child: IconButton(
                icon: Icon(Icons.title),
                onPressed: () {
                  _applyMarkdown('# ', ''); // Heading 1
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Heading 2',
              child: IconButton(
                icon: Icon(Icons.format_size),
                onPressed: () {
                  _applyMarkdown('## ', ''); // Heading 2
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Heading 3',
              child: IconButton(
                icon: Icon(Icons.title_rounded),
                onPressed: () {
                  _applyMarkdown('### ', ''); // Heading 3
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Blockquote',
              child: IconButton(
                icon: Icon(Icons.format_quote),
                onPressed: () {
                  _applyMarkdown('> ', ''); // Blockquote
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Ordered List',
              child: IconButton(
                icon: Icon(Icons.format_list_numbered),
                onPressed: () {
                  _applyMarkdown('1. ', ''); // Ordered List
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Unordered List',
              child: IconButton(
                icon: Icon(Icons.format_list_bulleted),
                onPressed: () {
                  _applyMarkdown('- ', ''); // Unordered List
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Line Break',
              child: IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () {
                  _insertLineBreak();
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Link',
              child: IconButton(
                icon: Icon(Icons.link),
                onPressed: () {
                  _applyLinkOrImage(context, '[', '](url)');
                },
              ),
            ),
            SizedBox(width: 10),
            Tooltip(
              message: 'Image',
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  _applyLinkOrImage(context, '![', '](image-url)'); // Image
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String removeMarkdown(String markdownText) {
    final markdown = markdownText
        .replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), '') // Remove images
        .replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '') // Remove links
        .replaceAll(
            RegExp(r'```.*?```', dotAll: true), '') // Remove code blocks
        .replaceAll(RegExp(r'`.*?`'), '') // Remove inline code
        .replaceAll(RegExp(r'#\s*'), '') // Remove headers
        .replaceAll(RegExp(r'\*\*|__'), '') // Remove bold
        .replaceAll(RegExp(r'\*|_'), '') // Remove italic
        .replaceAll(
            RegExp(r'^\s*[-*]\s+', multiLine: true), '') // Remove list bullets
        .replaceAll(RegExp(r'^\s*\d+\.\s+', multiLine: true),
            '') // Remove numbered lists
        .replaceAll(RegExp(r'\n\s*\n'), '\n') // Remove empty lines
        .replaceAll(RegExp(r'^\s+|\s+$', multiLine: true),
            ''); // Trim leading/trailing whitespace

    return markdown.trim();
  }

  void _insertLineBreak() {
    final selection = _controller.selection;

    if (selection.isValid) {
      final lineBreak = '\n---\n'; // Line break Markdown syntax

      _controller.value = _controller.value.copyWith(
        text: _controller.text
            .replaceRange(selection.start, selection.end, lineBreak),
        selection:
            TextSelection.collapsed(offset: selection.start + lineBreak.length),
      );
    }
  }

  void _applyMarkdown(String prefix, String suffix) {
    final selection = _controller.selection;

    if (selection.isValid) {
      final selectedText =
          _controller.text.substring(selection.start, selection.end);

      String newText = '${prefix}${selectedText}${suffix}';

      if (prefix == '**' && suffix == '**') {
        newText = '***${selectedText}***'; // Handle nested bold and italic
      } else if (prefix == '_' && suffix == '_') {
        newText = '_${selectedText}_'; // Handle nested italic
      }

      _controller.value = _controller.value.copyWith(
        text: _controller.text
            .replaceRange(selection.start, selection.end, newText),
        selection:
            TextSelection.collapsed(offset: selection.start + newText.length),
      );
    }
  }
}
