import 'package:fortloom/core/framework/colors.dart';
import 'package:flutter/material.dart';

class txtForm extends StatefulWidget {
  final String? title;
  final String? placeholder;
  final InputType inputType;
  final TextEditingController controller;
  final String? errorMessage;
  final int? maxLength;
  final Icon? prefixIcon;
  final Icon? sufixIcon;
  final Color? txtColor;
  txtForm(
      {Key? key,
      this.title,
      required this.controller,
      required this.inputType,
      this.placeholder = '',
      this.errorMessage,
      this.maxLength,
      this.prefixIcon,
      this.sufixIcon,
      this.txtColor = txtPrimary})
      : super(key: key);

  @override
  State<txtForm> createState() => _txtFormState();
}

class _txtFormState extends State<txtForm> {
  bool _isValidate = true;
  String validationMessage = '';
  bool visibility = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.title != null
            ? Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: widget.txtColor,
                      decoration: TextDecoration.none),
                ))
            : Container(),
        Material(
          color: Colors.transparent,
          child: TextField(
            cursorColor: goldPrimary,
            controller: widget.controller,
            decoration: InputDecoration(
              errorText: _isValidate ? null : validationMessage,
              border: getBorder(false),
              enabledBorder: getBorder(false),
              focusedBorder: getBorder(true),
              filled: true,
              hintText: widget.placeholder,
              fillColor: Colors.white,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.sufixIcon ?? getSuffixIcon(),
            ),
            onSubmitted: checkValidation,
            keyboardType: getInputType(),
            obscureText: widget.inputType == InputType.Password && !visibility,
          ),
        )
      ],
    );
  }

  getSuffixIcon() {
    if (widget.inputType == InputType.Password) {
      return IconButton(
        onPressed: () {
          visibility = !visibility;
          setState(() {});
        },
        icon: Icon(
          visibility ? Icons.visibility : Icons.visibility_off,
          color: goldPrimary.withOpacity(0.5),
        ),
      );
    }
  }

  //get border of textinput filed
  OutlineInputBorder getBorder(bool focused) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide:
          BorderSide(width: 2, color: focused ? goldPrimary : borderGrey),
      gapPadding: 2,
    );
  }

  // input validations
  void checkValidation(String textFieldValue) {
    if (widget.inputType == InputType.Email) {
      //email validation
      _isValidate = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(textFieldValue);
      validationMessage = widget.errorMessage ?? 'Email no es valido';
    } else if (widget.inputType == InputType.Number) {
      //contact number validation
      _isValidate = textFieldValue.length == widget.maxLength;
      validationMessage = widget.errorMessage ?? 'Numero no es valido';
    } else if (widget.inputType == InputType.Password) {
      //password validation
      _isValidate = RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
          .hasMatch(textFieldValue);
      validationMessage = widget.errorMessage ?? 'Contraseña no es valido';
    }
    _isValidate = textFieldValue.isNotEmpty;
    validationMessage = widget.errorMessage ?? 'Dato obligatorio';
    //change value in state
    setState(() {});
  }

  // return input type for setting keyboard
  TextInputType getInputType() {
    switch (widget.inputType) {
      case InputType.Default:
        return TextInputType.text;
        break;

      case InputType.Email:
        return TextInputType.emailAddress;
        break;

      case InputType.Number:
        return TextInputType.number;
        break;

      default:
        return TextInputType.text;
        break;
    }
  }
}

//input types
enum InputType { Default, Email, Number, Password, PaymentCard }
