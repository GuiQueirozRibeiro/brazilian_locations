import 'package:flutter/material.dart';

/// A dropdown widget with search functionality.
///
/// This widget displays a dropdown with a search option. It allows users
/// to select an item from a list with the ability to filter items by typing
/// in a search box.
class DropdownWithSearch<T> extends StatelessWidget {
  /// The title displayed above the dropdown.
  final String title;

  /// The placeholder text for the search input.
  final String placeHolder;

  /// The currently selected item.
  final T selected;

  /// The list of items to select from.
  final List items;

  /// Padding for the selected item.
  final EdgeInsets? selectedItemPadding;

  /// Style for the selected item.
  final TextStyle? selectedItemStyle;

  /// Style for the dropdown heading.
  final TextStyle? dropdownHeadingStyle;

  /// Style for the items in the dropdown.
  final TextStyle? itemStyle;

  /// Decoration for the dropdown.
  final BoxDecoration? decoration;

  /// Decoration for the dropdown when disabled.
  final BoxDecoration? disabledDecoration;

  /// Radius for the search bar.
  final double? searchBarRadius;

  /// Radius for the dialog.
  final double? dialogRadius;

  /// Whether the dropdown is disabled.
  final bool disabled;

  /// A label for the dropdown.
  final String label;

  /// Callback function called when the selection changes.
  final Function onChanged;

  /// Creates a [DropdownWithSearch] widget.
  const DropdownWithSearch({
    super.key,
    required this.title,
    required this.placeHolder,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.selectedItemPadding,
    this.selectedItemStyle,
    this.dropdownHeadingStyle,
    this.itemStyle,
    this.decoration,
    this.disabledDecoration,
    this.searchBarRadius,
    this.dialogRadius,
    required this.label,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => SearchDialog(
              placeHolder: placeHolder,
              title: title,
              searchInputRadius: searchBarRadius,
              dialogRadius: dialogRadius,
              titleStyle: dropdownHeadingStyle,
              itemStyle: itemStyle,
              items: items,
            ),
          ).then((value) => onChanged(value));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: !disabled
              ? decoration ??
                  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  )
              : disabledDecoration ??
                  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selected.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: selectedItemStyle ?? const TextStyle(fontSize: 16),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded)
            ],
          ),
        ),
      ),
    );
  }
}

/// A dialog widget with search functionality.
class SearchDialog extends StatefulWidget {
  /// The title of the dialog.
  final String title;

  /// The placeholder text for the search input.
  final String placeHolder;

  /// The list of items to search from.
  final List items;

  /// Style for the title of the dialog.
  final TextStyle? titleStyle;

  /// Style for the items in the dialog.
  final TextStyle? itemStyle;

  /// Radius for the search input.
  final double? searchInputRadius;

  /// Radius for the dialog.
  final double? dialogRadius;

  /// Creates a [SearchDialog] widget.
  const SearchDialog({
    super.key,
    required this.title,
    required this.placeHolder,
    required this.items,
    this.titleStyle,
    this.searchInputRadius,
    this.dialogRadius,
    this.itemStyle,
  });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState<T> extends State<SearchDialog> {
  TextEditingController textController = TextEditingController();
  late List filteredList;

  @override
  void initState() {
    super.initState();

    filteredList = widget.items;
    textController.addListener(() {
      setState(() {
        if (textController.text.isEmpty) {
          filteredList = widget.items;
        } else {
          filteredList = widget.items
              .where((element) => element
                  .toString()
                  .toLowerCase()
                  .contains(textController.text.toLowerCase()))
              .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      shape: RoundedRectangleBorder(
          borderRadius: widget.dialogRadius != null
              ? BorderRadius.circular(widget.dialogRadius!)
              : BorderRadius.circular(14)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.title,
                    style: widget.titleStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.search),
                  hintText: widget.placeHolder,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        widget.searchInputRadius != null
                            ? Radius.circular(widget.searchInputRadius!)
                            : const Radius.circular(8)),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        widget.searchInputRadius != null
                            ? Radius.circular(widget.searchInputRadius!)
                            : const Radius.circular(8)),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
                style: widget.itemStyle ?? const TextStyle(fontSize: 16),
                controller: textController,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(widget.dialogRadius != null
                    ? Radius.circular(widget.dialogRadius!)
                    : const Radius.circular(8)),
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context, filteredList[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 18,
                        ),
                        child: Text(
                          filteredList[index].toString(),
                          style:
                              widget.itemStyle ?? const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A customizable dialog widget.
class CustomDialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showDialog].

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  final Curve insetAnimationCurve;

  /// The shape of this dialog's border.
  ///
  /// Defines the dialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.0.
  final ShapeBorder? shape;

  /// Creates a [CustomDialog] widget.
  const CustomDialog({
    super.key,
    this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
  });

  Color _getColor(BuildContext context) {
    return Theme.of(context).dialogBackgroundColor;
  }

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)));

  static const constraints = BoxConstraints(
    minWidth: 280.0,
    minHeight: 280.0,
    maxHeight: 400.0,
    maxWidth: 400.0,
  );

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: constraints,
            child: Material(
              elevation: 15.0,
              color: _getColor(context),
              type: MaterialType.card,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
