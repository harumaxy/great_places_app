import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final void Function(File) onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  _takePicture() async {
    // pickImageを実行するには、iosの場合はplistへ Usage Descriptionを書かなければならない
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      // 最近のカメラは解像度が大きいので、高めの値を指定する。
      maxWidth: 600,
    );
    // 取得できなかったら終了
    if (imageFile == null) {
      return;
    }

    setState(() {
      _storedImage = imageFile;
    });

    // app専用のデータ保存ディレクトリのパス取得
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(imageFile.path);
    // File.copy(path) : 指定したpathにコピーする(ファイル名込)
    final savedImage = await imageFile.copy("${appDir.path}/$filename");
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "No Image Taken",
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Take Picture"),
            textColor: Theme.of(context).primaryColor,
            // ボタンを押したら、カメラを起動して画像を取得する
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
