import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory/addTrans.dart';
import 'package:inventory/transactionList.dart';

class detailedView extends StatefulWidget {
  final String id;

  detailedView({required this.id});

  @override
  State<detailedView> createState() => _detailedViewState();
}

class _detailedViewState extends State<detailedView> {
  //DatabaseReference dbref = FirebaseDatabase.instance.ref();
  late String partyName = '';
  num sum = 0;
  num total = 0;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('transactions')
        .where('partyId', isEqualTo: widget.id.trim())
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if (element.data()['type'] == 'credit') {
          sum = sum + element.data()['Amount'];
        } else {
          sum = sum - element.data()['Amount'];
        }
      });
      setState(() {
        total = sum;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('clients')
              .where('docId', isEqualTo: widget.id)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                //itemCount: snapshot.data!.docs.length,
                itemCount: 1,
                itemBuilder: (context, index) {
                  DocumentSnapshot client = snapshot.data!.docs[index];
                  return Container(
                    child: Column(
                      children: [
                        Text('Outstanding :${total}'),
                        TextButton(
                            onPressed: () {
                              sum = 0;
                              FirebaseFirestore.instance
                                  .collection('transactions')
                                  .where('partyId', isEqualTo: widget.id.trim())
                                  .get()
                                  .then((querySnapshot) {
                                querySnapshot.docs.forEach((element) {
                                  if (element.data()['type'] == 'credit') {
                                    sum = sum + element.data()['Amount'];
                                  } else {
                                    sum = sum - element.data()['Amount'];
                                  }
                                });
                                setState(() {
                                  total = sum;
                                });
                              });
                            },
                            child: Icon(Icons.refresh)),
                        Text(client['gstn']),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return transactionList(docId: client['docId']);
                              }));
                            },
                            child: Text('View Transaction')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return addTrans(id: client['docId']);
                              }));
                            },
                            child: Text('Record Transaction'))
                      ],
                    ),
                  );
                },
              );
            }
            ;
          },
        ),
      ),
    );
  }
}
