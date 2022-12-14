import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory/proformaDetail.dart';

class proinfo extends StatefulWidget {
  late int invno;
  late String partyname;
  late String docId;

  proinfo({required this.invno, required this.partyname, required this.docId});

  @override
  State<proinfo> createState() => _proinfoState();
}

class _proinfoState extends State<proinfo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return proformaDetail(invno: widget.invno);
        }));
      },
      onLongPress: () async {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('proformaInvoices')
                              .doc(widget.docId)
                              .delete();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Row(
                              children: [
                                Text('Deleted Successfully '),
                                Icon(
                                  Icons.done_outlined,
                                  color: Colors.green,
                                )
                              ],
                            )),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            Text('  Delete'),
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            Text('  Edit'),
                          ],
                        )),
                  ],
                ));
      },
      child: Container(
        color: Colors.blueGrey,
        padding: EdgeInsets.fromLTRB(0, 5, 0, 8),
        margin: EdgeInsets.all(10),
        height: 50,
        child: Row(
          children: [
            Icon(Icons.note_add),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Inv No : ${widget.invno.toString()}'),
                SizedBox(
                  height: 5,
                ),
                Text(widget.partyname),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
