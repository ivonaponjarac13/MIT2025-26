import 'package:eventify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:random_string/random_string.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final List<String> eventcategory = [
    "Koncert",
    "Sportski događaj",
    "Pozorišna predstava",
    "Film",
  ];




  String? value;
  final ImagePicker _picker = ImagePicker();
  File? previewImage; 
  String? finalAssetImage; 

 
  Map<String, String> categoryImages = {
    "Koncert": "images/koncert.jpg",
    "Sportski događaj": "images/utakmica.jpg",
    "Pozorišna predstava": "images/predstava.jpg",
    "Film": "images/bioskop.jpeg",
  };

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 0);

  Future pickPreviewImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        previewImage = File(image.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String getFormattedDate() {
    return "${selectedDate.day.toString().padLeft(2,'0')}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.year}";
  }

  String getFormattedTime() {
    return "${selectedTime.hour.toString().padLeft(2,'0')}:${selectedTime.minute.toString().padLeft(2,'0')}";
  }

  void assignAssetImage() {
    finalAssetImage = categoryImages[value] ?? "images/utakmica1.jpeg";
  }

  void addEvent() async {
    assignAssetImage();
    String id = randomAlphaNumeric(10);

    Map<String, dynamic> uploadevent = {
      "ImageURL": finalAssetImage,
      "Name": nameController.text,
      "Price": priceController.text,
      "Category": value,
      "Location": locationController.text,
      "Details": detailsController.text,
      "Date": getFormattedDate(),
      "Time": getFormattedTime(),
    };

    await DatabaseMethods().addEvent(uploadevent, id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Događaj je uspješno dodan!",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      );
      setState(() {
        nameController.text = "";
        priceController.text = "";
        detailsController.text = "";
        previewImage = null;
        value = null;
        selectedDate = DateTime.now();
        selectedTime = TimeOfDay(hour: 10, minute: 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 7.5),
                  Text(
                    "Dodaj novi događaj",
                    style: TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Center(
                child: previewImage != null
                    ? Image.file(
                        previewImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 50,
                            color: Colors.black45,
                          ),
                        ),
                      ),
              ),

              SizedBox(height: 10),

              // dugme Dodaj / Izmijeni
              Center(
                child: GestureDetector(
                  onTap: pickPreviewImage,
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(0xff6351ec),
                    ),
                    child: Center(
                      child: Text(
                        previewImage == null ? "Dodaj sliku" : "Izmjeni",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              Text(
                "Naziv događaja",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Unesite naziv događaja",
                  ),
                ),
              ),

              SizedBox(height: 30),

              Text(
                "Cijena ulaznice",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Unesite cijenu ulaznice",
                  ),
                ),
              ),

              SizedBox(height: 30),
               SizedBox(height: 30),

              Text(
                "Lokacija događaja",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Unesite lokaciju događaja",
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Kategorija događaja",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: eventcategory
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: Text("Odaberite kategoriju"),
                    iconSize: 35,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: value,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // ----- DATUM I VRIJEME -----
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.black54),
                            SizedBox(width: 10),
                            Text(
                              getFormattedDate(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xffececf8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.black54),
                            SizedBox(width: 10),
                            Text(
                              getFormattedTime(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Text(
                "Detaji događaja",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: detailsController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Unesite detalje događaja...",
                  ),
                ),
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: addEvent,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Color(0xff6351ec),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        "Dodaj",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
