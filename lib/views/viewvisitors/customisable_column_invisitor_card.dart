import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomisableColumnInVisitorCard extends StatefulWidget {
  final String title;
  final String value;
  final bool isEditable;
  final TextEditingController? controller;
  final Function(String)? onArrowIconTap;
  final List<String>? dropdownItems;
  const CustomisableColumnInVisitorCard({
    super.key,
    required this.title,
    required this.value,
    this.isEditable = false,
    this.controller,
    this.onArrowIconTap,
    this.dropdownItems,
  });

  @override
  CustomisableColumnInVisitorCardState createState() =>
      CustomisableColumnInVisitorCardState();
}
class CustomisableColumnInVisitorCardState
    extends State<CustomisableColumnInVisitorCard> {
  bool _isEditing = false;
  late FocusNode _focusNode;
  late String currentValue;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    currentValue = widget.value;
    setState(() {
       if (widget.controller != null) {
      widget.controller!.text = widget.value;
    }
    });
   
  }

  @override 
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomisableColumnInVisitorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        currentValue = widget.value;
        if (widget.controller != null) {
          widget.controller!.text = widget.value;
        }
      });
    }
  }
  void _handleIconTap() {
  setState(() {
    if (_isEditing) {
      _isEditing = false;
      // Save the current value before losing focus
      currentValue = widget.controller?.text ?? currentValue;
      _focusNode.unfocus();

      // Check if the value has changed
      if (currentValue != widget.value && widget.onArrowIconTap != null) {
        widget.onArrowIconTap!(currentValue);
      }
    } else {
      _isEditing = true;
      _focusNode.requestFocus();
    }
  });
}


  // void _handleIconTap() {
  //   setState(() {
  //     if (_isEditing) {
  //       _isEditing = false;
  //       currentValue = widget.controller?.text ?? currentValue;
  //       _focusNode.unfocus();

  //       if (widget.onArrowIconTap != null) {
  //         widget.onArrowIconTap!(currentValue);
  //       }
  //     } else {
  //       _isEditing = true;
  //       _focusNode.requestFocus();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 13,
                  fontFamily: 'Albert Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _isEditing
                    ? (widget.dropdownItems != null && widget.dropdownItems!.isNotEmpty
                        ? DropdownButton<String>(
                            value: currentValue,
                            items: widget.dropdownItems!
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            onChanged: (newValue) {
                              setState(() {
                                currentValue = newValue!;
                                if (widget.controller != null) {
                                  widget.controller!.text = currentValue;
                                }
                              });
                            },
                            isExpanded: true,
                          )
                        : TextField(
                            focusNode: _focusNode,
                            controller: widget.controller,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: widget.title,
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 13,
                              fontFamily: 'Albert Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                    : Text(
                        currentValue,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 13,
                          fontFamily: 'Albert Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              if (widget.isEditable)
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.arrow_forward : Icons.edit,
                    size: 16,
                    color: const Color(0xFF666666),
                  ),
                  onPressed: _handleIconTap,
                ),
            ],
          ),

        ],
      ),
    );
  }
}