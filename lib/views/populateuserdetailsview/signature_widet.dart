import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

bool isSignatureDone = false;

class SignatureWidget extends StatefulWidget {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey;
  final String labelText;
  final String buttonLabel;
  final double height;
  final Color backgroundColor;
  final Color strokeColor;

  const SignatureWidget({
    super.key,
    required this.signatureGlobalKey,
    this.labelText = "Signature",
    this.buttonLabel = "Clear",
    this.height = 100,
    this.backgroundColor = Colors.white,
    this.strokeColor = Colors.black,
  });

  @override
  _SignatureWidgetState createState() => _SignatureWidgetState();
}

class _SignatureWidgetState extends State<SignatureWidget> {
  // Local state to track if the signature is done

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label and Clear button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.labelText,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (isSignatureDone) {
                  widget.signatureGlobalKey.currentState?.clear();
                  setState(() {
                    isSignatureDone = false; // Reset signature done status
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(83, 213, 227, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SizedBox(
                width: 40,
                height: 20,
                child: Center(
                  child: Text(
                    widget.buttonLabel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Signature Pad
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SfSignaturePad(
              key: widget.signatureGlobalKey,
              backgroundColor: widget.backgroundColor,
              strokeColor: widget.strokeColor,
              minimumStrokeWidth: 1.0,
              maximumStrokeWidth: 4.0,
              onDrawEnd: () {
                setState(() {
                  isSignatureDone =
                      true; // Mark signature as done when drawing ends
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
