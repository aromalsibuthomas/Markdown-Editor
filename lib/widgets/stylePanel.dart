import 'package:flutter/material.dart';
import 'package:markdown_editor/utils/markdownFunctions.dart';

class StylePanel extends StatelessWidget {
  final TextEditingController controller;
  final TextSelection selection;
  final Function(TextSelection) updateSelection;

  const StylePanel({
    Key? key,
    required this.controller,
    required this.selection,
    required this.updateSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Tooltip(
                message: 'Remove Markdown',
                child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    updateSelection(
                      selection.copyWith(
                        baseOffset: selection.baseOffset,
                        extentOffset: selection.extentOffset,
                      ),
                    );
                    controller.text = removeMarkdown(controller.text);
                  },
                ),
              ),
              Tooltip(
                message: 'Bold',
                child: IconButton(
                  icon: Icon(Icons.format_bold),
                  onPressed: () {
                    _applyMarkdown('**', '**');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Italic',
                child: IconButton(
                  icon: Icon(Icons.format_italic),
                  onPressed: () {
                    _applyMarkdown('_', '_');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Inline Code',
                child: IconButton(
                  icon: Icon(Icons.code),
                  onPressed: () {
                    _applyMarkdown('`', '`');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Strikethrough',
                child: IconButton(
                  icon: Icon(Icons.strikethrough_s),
                  onPressed: () {
                    _applyMarkdown('~~', '~~');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Heading 1',
                child: IconButton(
                  icon: Icon(Icons.title),
                  onPressed: () {
                    _applyMarkdown('# ', '');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Heading 2',
                child: IconButton(
                  icon: Icon(Icons.format_size),
                  onPressed: () {
                    _applyMarkdown('## ', '');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Heading 3',
                child: IconButton(
                  icon: Icon(Icons.title_rounded),
                  onPressed: () {
                    _applyMarkdown('### ', '');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Blockquote',
                child: IconButton(
                  icon: Icon(Icons.format_quote),
                  onPressed: () {
                    _applyMarkdown('> ', '');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Ordered List',
                child: IconButton(
                  icon: Icon(Icons.format_list_numbered),
                  onPressed: () {
                    _applyMarkdown('1. ', '');
                  },
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: 'Unordered List',
                child: IconButton(
                  icon: Icon(Icons.format_list_bulleted),
                  onPressed: () {
                    _applyMarkdown('- ', '');
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
                    _applyLinkOrImage(context, '![', '](image-url)');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyMarkdown(String prefix, String suffix) {
    applyMarkdown(controller, selection, prefix, suffix, updateSelection);
  }

  void _applyLinkOrImage(BuildContext context, String prefix, String suffix) {
    // Pass the required parameters to the utility function
    applyLinkOrImage(context, controller, prefix, suffix);
  }

  void _insertLineBreak() {
    insertLineBreak(controller, selection, updateSelection);
  }
}
