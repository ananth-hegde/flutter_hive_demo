import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class Helper{
  // ignore: unused_element
  void showPicker(context,Function updatePath){  
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext _){
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: (){
                    _uploadImage('gallery',updatePath);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: (){
                    _uploadImage('camera',updatePath);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ),
        );
      }
    );
  }
  void _uploadImage(String type,Function updatePath) async {
    final _picker = ImagePicker();
    var _pickedImage;
    if(type=='camera')
    {
      _pickedImage = await _picker.getImage(source: ImageSource.camera);
    }
    else{
      _pickedImage = await _picker.getImage(source: ImageSource.gallery);
    }
    if(_pickedImage!=null)
      updatePath(_pickedImage.path);
  }
}