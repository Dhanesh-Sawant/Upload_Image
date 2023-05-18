import 'dart:io';
import 'dart:typed_data';
import 'package:eyetracker/snackbar.dart';
import 'package:eyetracker/upload_image.dart';

import 'picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';



void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black
      ),
      home: const MyHomePage(title: 'Demo image picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Uint8List? MyFile;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  bool isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            title: const Text('Choose an image from :'),
            children: [
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Camera'),
                  onPressed: ()async{
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      MyFile = file;
                    });
                  }
              ),
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Gallery'),
                  onPressed: ()async{
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      MyFile = file;
                    });
                  }
              ),
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context)  {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: 40),

            SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.35,
                child:

                    MyFile==null ? Image.network('https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1887&q=80',
                      fit: BoxFit.cover,
                    )
                    :

                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.35,
                      child: Container(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(MyFile!)
                        )
                      ),
                    )


            ),

            SizedBox(height: 40),

            MaterialButton(
                onPressed: () => _selectImage(context),
                color: Colors.blueAccent,
              child: Text('Choose'),
            ),

            SizedBox(height: 20),

            MaterialButton(
              onPressed: () async {

                if(MyFile==null) showSnackBar('Choose an image first', context);
                else{
                  setState(() {
                    isLoading = true;
                  });
                  String downloadUrl = await uploadImageToStorage(MyFile!);

                  showSnackBar("image uploaded successfully!!", context);

                }
              },
              color: Colors.blueAccent,
              child: Text('Upload'),
            ),

          ],
        ),
      )
    );
  }
}


