import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/colors.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/ReportService.dart';

class reportDialog extends StatefulWidget {
  const reportDialog({Key? key, required this.userReported, required this.publicationid}) : super(key: key);
  final int userReported;
  final int publicationid;
  @override
  State<reportDialog> createState() => _reportDialogState();
}

class _reportDialogState extends State<reportDialog> {
  AuthService authService = new AuthService();
  String username = "Usuario";
  int userId = 0;

  @override
  void initState() {
    super.initState();
    String tep;

    this.authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = this.authService.GetUsername(tep);

        this.authService.getperson(username).then((result) {
          setState(() {
            userId = result.id;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _newReportController = TextEditingController();
    final ReportService _reportService = ReportService();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ScreenWH(context).width * 0.8,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  height: 4 * 25,
                  child: TextField(
                    controller: _newReportController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: getBorder(false),
                      enabledBorder: getBorder(false),
                      focusedBorder: getBorder(true),
                      hintText: "Enter a report description",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: FloatingActionButton(
                    backgroundColor: Colors.redAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Report',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      _reportService.createforpublication(
                          userId, widget.userReported,widget.publicationid,_newReportController.text);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder getBorder(bool focused) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide:
          BorderSide(width: 2, color: focused ? Colors.black : borderGrey),
      gapPadding: 2,
    );
  }
}
