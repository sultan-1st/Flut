import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicketHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TicketHomePage extends StatefulWidget {
  const TicketHomePage({super.key});

  @override
  TicketHomePageState createState() => TicketHomePageState();
}

class TicketHomePageState extends State<TicketHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _innerTapController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _innerTapController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _innerTapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 251, 251), // Set the background color
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tickets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(50)),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorPadding: EdgeInsets.all(0),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(color: const Color.fromARGB(255, 56, 141, 35), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(50)),
                  labelColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  tabs: [Tab(text: 'My Tickets'), Tab(text: 'Buy Ticket')],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset('assets/icons/create-ticket-icon.png'),
                      Text(
                        'No ticket \navailable',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'You have no tickets, purchase a new\nticket to be displayed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 56, 141, 35),
                          minimumSize: Size(170, 50),
                        ),
                        child: Text(
                          'Buy a Ticket',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TabBar(
                          controller: _innerTapController,
                          indicatorColor: Colors.black,
                          indicatorPadding: EdgeInsets.all(0),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.black,
                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          tabs: [Tab(text: 'Pay By Distance'), Tab(text: 'Pay By Time')],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _innerTapController,
                          children: [
                            ListView(
                              children: [
                                PayByDistanceWidget(
                                    data: DistanceData(
                                  title: 'REGULAR CLASS',
                                  price: 4,
                                  distance: 2,
                                )),
                                PayByDistanceWidget(
                                    data: DistanceData(
                                  title: 'REGULAR CLASS',
                                  price: 8,
                                  distance: 5,
                                )),
                                PayByDistanceWidget(
                                    data: DistanceData(
                                  title: 'REGULAR CLASS',
                                  price: 16,
                                  distance: 12,
                                )),
                                PayByDistanceWidget(
                                    data: DistanceData(
                                  title: 'REGULAR CLASS',
                                  price: 30,
                                  distance: 25,
                                )),
                                PayByDistanceWidget(
                                    data: DistanceData(
                                  title: 'REGULAR CLASS',
                                  price: 50,
                                  distance: 45,
                                )),
                              ],
                            ),
                            ListView(
                              children: [
                                TicketWidget(
                                    data: Data(
                                  title: 'REGULAR CLASS',
                                  price: 5,
                                  isHours: true,
                                  hours: 2,
                                )),
                                TicketWidget(
                                    data: Data(
                                  title: 'REGULAR CLASS',
                                  price: 12,
                                  hours: 24,
                                  isHours: true,
                                )),
                                TicketWidget(
                                    data: Data(
                                  title: 'REGULAR CLASS',
                                  price: 30,
                                  days: 4,
                                )),
                                TicketWidget(
                                    data: Data(
                                  title: 'REGULAR CLASS',
                                  price: 50,
                                  days: 7,
                                )),
                                TicketWidget(
                                    data: Data(
                                  title: 'REGULAR CLASS',
                                  price: 150,
                                  days: 30,
                                )),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayByDistanceWidget extends StatelessWidget {
  const PayByDistanceWidget({super.key, required this.data});

  final DistanceData data;
  void _showPaymentOptions(BuildContext context, DistanceData data) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'This ${data.distance}-Stations ticket allows unlimited bus and metro rides for ${data.price} SAR after activation.',
              //   style: TextStyle(fontSize: 16),
              // ),
              SizedBox(height: 20),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(Icons.credit_card),
                title: Text('Payment Card'),
                onTap: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.white,
                leading: Icon(Icons.apple),
                title: Text('Apple Pay'),
                onTap: () {},
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 56, 141, 35),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPaymentOptions(context, data),
      child: Card(
        color: data.title == 'REGULAR CLASS' ? Colors.white : const Color.fromARGB(255, 171, 143, 89),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: data.title == 'REGULAR CLASS' ? Colors.grey[300] : const Color.fromARGB(255, 142, 111, 49),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      data.title ?? "",
                      style: TextStyle(
                        color: data.title == 'REGULAR CLASS' ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      fillColor: WidgetStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
                      value: false,
                      onChanged: (bool? value) {}),
                ],
              ),
              Text(
                '${data.distance}-Stations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${data.price} SAR',
                style: TextStyle(
                  fontSize: 20,
                  color: data.title == 'REGULAR CLASS' ? Color.fromARGB(255, 56, 141, 35) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                data.description ?? "",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketWidget extends StatelessWidget {
  const TicketWidget({super.key, required this.data});

  final Data data;
  void _showPaymentOptions(BuildContext context, Data data) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.isHours ? '${data.hours}-hour pass' : '${data.days}-day pass',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Text(
              //   data.isHours ? 'This ${data.hours}-hour ticket allows unlimited bus and metro rides for ${data.hours} hours after activation.' : 'This ${data.days}-day ticket allows unlimited bus and metro rides for ${data.days} days after activation.',
              //   style: TextStyle(fontSize: 16),
              // ),
              SizedBox(height: 20),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(Icons.credit_card),
                title: Text('Payment Card'),
                onTap: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Colors.white,
                leading: Icon(Icons.apple),
                title: Text('Apple Pay'),
                onTap: () {},
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 56, 141, 35),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPaymentOptions(context, data),
      child: Card(
        color: data.title == 'REGULAR CLASS' ? Colors.white : const Color.fromARGB(255, 171, 143, 89),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: data.title == 'REGULAR CLASS' ? Colors.grey[300] : const Color.fromARGB(255, 142, 111, 49),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      data.title ?? "",
                      style: TextStyle(
                        color: data.title == 'REGULAR CLASS' ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      fillColor: WidgetStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
                      value: false,
                      onChanged: (bool? value) {}),
                ],
              ),
              Text(
                data.isHours ? '${data.hours}-hour pass' : '${data.days}-days pass',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${data.price} SAR',
                style: TextStyle(
                  fontSize: 20,
                  color: data.title == 'REGULAR CLASS' ? Color.fromARGB(255, 56, 141, 35) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                data.description ?? "",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Data {
  String? title;
  String? description;
  double? price;
  int? days;
  int? hours;
  bool isHours;

  Data({this.title, this.description, this.price, this.days, this.hours, this.isHours = false});
}

class DistanceData {
  String? title;
  String? description;
  double? price;
  int? distance;

  DistanceData({this.title, this.description, this.price, this.distance});
}
