import 'package:flutter/material.dart';

/// A dropdown widget with search functionality.
///
/// This widget displays a dropdown with a search option. It allows users
/// to select an item from a list with the ability to filter items by typing
/// in a search box.
class DropdownWithSearch<T> extends StatelessWidget {
  /// The title displayed above the dropdown.
  final String title;

  /// The list of items to select from.
  final List items;

  /// The currently selected item.
  final T selected;

  /// Callback function called when the selection changes.
  final Function onChanged;

  /// Custom Icon to open the dialog.
  final Icon? customIcon;

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

  /// Decoration for the Text Field in dropdown.
  final InputDecoration? inputDecoration;

  /// Decoration for the dropdown when disabled.
  final BoxDecoration? disabledDropdownDecoration;

  /// Radius for the search bar.
  final double? searchBarRadius;

  /// Radius for the dialog.
  final double? dialogRadius;

  /// Whether the dropdown is disabled.
  final bool disabled;

  /// A label for the dropdown.
  final String label;

  /// Creates a [DropdownWithSearch] widget.
  ///
  /// Parameters:
  ///
  /// - [title]: The title displayed above the dropdown.
  /// - [items]: The list of items to select from.
  /// - [selected]: The currently selected item.
  /// - [onChanged]: Callback function called when the selection changes.
  /// - [customIcon]: Custom Icon to open the dialog.
  /// - [selectedItemPadding]: Padding for the selected item.
  /// - [selectedItemStyle]: Style for the selected item.
  /// - [dropdownHeadingStyle]: Style for the dropdown heading.
  /// - [itemStyle]: Style for the items in the dropdown.
  /// - [decoration]: Decoration for the dropdown.
  /// - [inputDecoration]: Decoration for the Text Field in dropdown.
  /// - [disabledDropdownDecoration]: Decoration for the dropdown when disabled.
  /// - [searchBarRadius]: Radius for the search bar.
  /// - [dialogRadius]: Radius for the dialog.
  /// - [label]: A label for the dropdown.
  /// - [disabled]: Whether the dropdown is disabled. Defaults to false.
  const DropdownWithSearch({
    super.key,
    required this.title,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.customIcon,
    this.selectedItemPadding,
    this.selectedItemStyle,
    this.dropdownHeadingStyle,
    this.itemStyle,
    this.decoration,
    this.inputDecoration,
    this.disabledDropdownDecoration,
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
              title: title,
              label: label,
              searchInputRadius: searchBarRadius,
              inputDecoration: inputDecoration,
              dialogRadius: dialogRadius,
              titleStyle: dropdownHeadingStyle,
              itemStyle: itemStyle,
              items: items,
            ),
          ).then((value) => onChanged(value));
        },
        child: Container(
          padding: selectedItemPadding ?? const EdgeInsets.all(10),
          decoration: !disabled
              ? decoration ??
                  BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  )
              : disabledDropdownDecoration ??
                  BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
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
              customIcon ?? const Icon(Icons.keyboard_arrow_down_rounded),
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
  final String label;

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

  /// Decoration for the search input.
  final InputDecoration? inputDecoration; // Added inputDecoration parameter.

  /// Creates a [SearchDialog] widget.
  ///
  /// Parameters:
  ///
  /// - [title]: The title of the dialog.
  /// - [label]: The placeholder text for the search input.
  /// - [items]: The list of items to search from.
  /// - [titleStyle]: Style for the title of the dialog.
  /// - [itemStyle]: Style for the items in the dialog.
  /// - [searchInputRadius]: Radius for the search input.
  /// - [dialogRadius]: Radius for the dialog.
  /// - [inputDecoration]: Decoration for the search input.
  const SearchDialog({
    super.key,
    required this.title,
    required this.label,
    required this.items,
    this.titleStyle,
    this.searchInputRadius,
    this.dialogRadius,
    this.itemStyle,
    this.inputDecoration,
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
    createTextListener();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void createTextListener() {
    textController.addListener(() {
      setState(() {
        if (textController.text.isEmpty) {
          filteredList = widget.items;
        } else {
          filteredList = widget.items
              .where(
                (element) => element.toString().toLowerCase().contains(
                      textController.text.toLowerCase(),
                    ),
              )
              .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.dialogRadius ?? 14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: widget.inputDecoration ??
                    InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search),
                      hintText: widget.label,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          widget.searchInputRadius != null
                              ? Radius.circular(widget.searchInputRadius!)
                              : const Radius.circular(8),
                        ),
                        borderSide: const BorderSide(color: Colors.black26),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          widget.searchInputRadius != null
                              ? Radius.circular(widget.searchInputRadius!)
                              : const Radius.circular(8),
                        ),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                style: widget.itemStyle ?? const TextStyle(fontSize: 16),
                controller: textController,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  widget.dialogRadius != null
                      ? Radius.circular(widget.dialogRadius!)
                      : const Radius.circular(8),
                ),
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
                          vertical: 8,
                          horizontal: 16,
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
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.
  final ShapeBorder? shape;

  /// Creates a [CustomDialog] widget.
  ///
  /// Parameters:
  ///
  /// - [child]: The widget below this widget in the tree.
  /// - [insetAnimationDuration]: The duration of the animation to show when the system keyboard intrudes.
  /// - [insetAnimationCurve]: The curve to use for the animation shown when the system keyboard intrudes.
  /// - [shape]: The shape of this dialog's border.
  const CustomDialog({
    super.key,
    this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
  });

  static const defaultDialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  static const constraints = BoxConstraints(
    minWidth: 280,
    minHeight: 280,
    maxHeight: 400,
    maxWidth: 400,
  );

  @override
  Widget build(BuildContext context) {
    final DialogThemeData dialogTheme = DialogTheme.of(context);

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
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
              elevation: 15,
              color: DialogTheme.of(context).backgroundColor,
              type: MaterialType.card,
              shape: shape ?? dialogTheme.shape ?? defaultDialogShape,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
