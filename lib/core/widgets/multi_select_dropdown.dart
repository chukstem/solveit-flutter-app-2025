import 'package:flutter/material.dart';

class MultiSelectItem<T> {
  final T value;
  final String label;

  MultiSelectItem(this.value, this.label);
}

class MultiSelectDropdownField<T> extends FormField<List<T>> {
  MultiSelectDropdownField({
    super.key,
    required String title,
    required List<MultiSelectItem<T>> items,
    required Function(List<T>) onConfirm,
    super.validator,
  }) : super(
          builder: (FormFieldState<List<T>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: state.context,
                      builder: (context) {
                        List<T> tempSelected = List.from(state.value ?? []);
                        return AlertDialog(
                          title: Text(title),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: items.map((item) {
                                return CheckboxListTile(
                                  value: tempSelected.contains(item.value),
                                  title: Text(item.label),
                                  onChanged: (checked) {
                                    if (checked == true) {
                                      tempSelected.add(item.value);
                                    } else {
                                      tempSelected.remove(item.value);
                                    }
                                    (context as Element).markNeedsBuild();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                state.didChange(tempSelected);
                                onConfirm(tempSelected);
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(title),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(state.context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if ((state.value?.isNotEmpty ?? false) && !state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8),
                    child: Wrap(
                      spacing: 8,
                      children: items.where((item) => state.value!.contains(item.value)).map((item) => Chip(label: Text(item.label))).toList(),
                    ),
                  ),
              ],
            );
          },
        );
}
