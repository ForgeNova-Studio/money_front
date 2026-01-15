import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/thousands_separator_input_formatter.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/transaction_form_card.dart';

class AmountInputCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final Color amountColor;
  final Color unitColor;
  final List<TextInputFormatter>? inputFormatters;

  const AmountInputCard({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.amountColor,
    required this.unitColor,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => focusNode.requestFocus(),
      child: TransactionFormCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              IntrinsicWidth(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  validator: validator,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onTap: () => focusNode.requestFocus(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: context.appColors.gray300,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorStyle: const TextStyle(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: inputFormatters ??
                      [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                  autofocus: false,
                  showCursor: false,
                  cursorColor: Colors.transparent,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '원',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: unitColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
