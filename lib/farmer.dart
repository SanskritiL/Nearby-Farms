
import 'package:earth_hack/utils.dart';
import 'package:flutter/material.dart';
import 'package:earth_hack/widgets/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_hack/widgets/taskcontainer.dart';
// import 'package:firebase_database/firebase_database.dart';

void main() => runApp(Farmer());

class Farmer extends StatefulWidget {

  @override
  _FarmerState createState() => _FarmerState();

}

class _FarmerState extends State<Farmer> {

 List<TaskContainer> completedOrders = [];
 List<TaskContainer> pendingOrders = [];

final databaseReference = Firestore.instance;

void initState(){
   
   super.initState();
   //completedOrders=[];
   databaseReference
      .collection("completedOrders")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
       snapshot.documents.forEach((item) => {
          completedOrders.add(new TaskContainer(
             title: item.data["customer_name"],
             subtitle: item.data["order_history"] + "("+item.data["total"]+ ")",
             boxColor: Colors.green[200]
          ))
        });
  });

  

  completedOrders.forEach((item) => print(item.title));
  
  

  
 }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nearby Farms',
        home: Scaffold(
            drawer: NavDrawer(),
            appBar: AppBar(
                title: Text('Nearby Farms'), backgroundColor: primaryColor) ,               
            body: 
              Column(
                children: <Widget>[
                  Text('Pending Orders'),
                  //IconButton(icon: Icon(Icons.check_circle), onPressed: fetch()),


                 // getTextWidgets(completedOrders),

                  Text('Completed Orders'),
                  
                  for(var item in completedOrders) item
                  
                ],
              )
              //child: TaskContainer(title: "Sans", subtitle: "yellow",boxColor: Colors.redAccent,),
              
              
              //IconButton(icon: Icon(Icons.check_circle), onPressed: null),
            ,    
                
                ));
        
 
  }
}
