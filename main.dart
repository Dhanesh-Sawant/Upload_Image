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
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color(0xffE5E5E5)
      ),
      home: const MyHomePage(title: 'Drishti'),
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
                    Uint8List? temp = await pickImage(ImageSource.camera);
                    setState(()  {
                      MyFile = temp;
                    });
                  }
              ),
              SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Gallery'),
                  onPressed: ()async{
                    Navigator.of(context).pop();
                    Uint8List? temp = await pickImage(ImageSource.gallery);
                    setState(()  {
                      MyFile = temp;
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
        title: Text(widget.title,style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xffE5E5E5),
      ),
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: 64),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.4,
                  child:

                      MyFile==null ? Image.network('https://i.pinimg.com/originals/d3/5c/ee/d35cee2b6520f2df4f5aac7dd64b7ae2.jpg',
                        fit: BoxFit.cover,
                      )
                      :
                      Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.4,
                        child: Container(),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(MyFile!)
                          )
                        ),
              ),
              ),
            ),

            SizedBox(height: 90),

            MaterialButton(
              minWidth: MediaQuery.of(context).size.width*0.8,
                onPressed: () => _selectImage(context),
                color: Color(0xff004494),
              child: Text('Choose',style: TextStyle(color: Colors.white),),
            ),

            SizedBox(height: 20),

            MaterialButton(
              minWidth: MediaQuery.of(context).size.width*0.8,
              onPressed: () {

                // if(MyFile==null) showSnackBar('Choose an image first', context);
                // else{
                //   setState(() {
                //     isLoading = true;
                //   });
                //   String downloadUrl = await uploadImageToStorage(MyFile!);
                //
                //   showSnackBar("image uploaded successfully!!", context);
                //
                // }
              },
              color: Color(0xff004494),
              child: Text('Upload',style: TextStyle(color: Colors.white)),
            ),

          ],
        ),
      )
    );
  }
}


