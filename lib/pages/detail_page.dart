import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "images/koncert.jpg",
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(top: 40.0, left: 30.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 20.0, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            BoxDecoration(color: Colors.black45),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Koncert Zdravka Čolića",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_month,
                                    color: Colors.white),
                                SizedBox(width: 10.0),
                                Text(
                                  "20 Feb 2026",
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                        199, 255, 255, 255),
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Icon(Icons.location_on,
                                    color: Colors.white),
                                SizedBox(width: 10.0),
                                Text(
                                  "Beogradska Arena",
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                        199, 255, 255, 255),
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "O događaju",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                "Zdravko Čolić stiže u Arenu i donosi veče vrhunske energije, emocija i najvećih hitova koje publika zna napamet. Njegovi koncerti poznati su po snažnoj atmosferi i posebnoj povezanosti sa publikom, gdje se svaka pjesma pjeva u glas. Očekuje vas muzički spektakl koji nadilazi običan koncert i ostaje dugo u sjećanju.",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20.0, right: 30.0, top: 20),
              child: Row(
                children: [
                  Text(
                    "Broj ulaznica",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40.0),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black54, width: 2.0),
                      borderRadius:
                          BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Text("+",
                            style: TextStyle(fontSize: 25)),
                        Text(
                          "3",
                          style: TextStyle(
                            color: Color(0xff6351ec),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("-",
                            style: TextStyle(fontSize: 25)),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left:10, right:10),
            child: Row(children: [
              Text("Cijena: \90€",
              style: TextStyle(
                color: Color(0xff6351ec),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              )
              ),
              SizedBox(width:20),
              Container(
                width:170,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff6351ec), borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: Text(
                      "Kupi ulaznice",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                
              )
            ],))
          ],
        ),
      ),
    );
  }
}
