import 'package:emiratec/BD/database_service.dart';
import 'package:emiratec/BD/todo_db.dart';
import 'package:emiratec/components/ads_home_page.dart';
import 'package:emiratec/components/class_selection.dart';
import 'package:emiratec/components/promotions_home_page.dart';
import 'package:emiratec/components/reservation_page.dart';
import 'package:emiratec/objects/flight.dart';
import 'package:emiratec/objects/promotion.dart';
import 'package:emiratec/screens/scheduled.dart';
import 'package:flutter/material.dart';
import 'package:emiratec/screens/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TecAir mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: const Color(0xFFC42F17),
          seedColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Emiratec'),
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
  int _selectedIndex = 3;

  String? selectedOrigin;

  String? selectedDestination;

  classSelection seatSelection = classSelection();

  final dbService = DatabaseService();

  List<Promotion> promo = [];

  List<String> airportsNames = [];

  int? selectedOriginID;

  int? selectedDestinationID;

  /// The function updates the selected index and triggers a state change in the widget.
  ///
  /// Args:
  ///   index (int): The index parameter represents the index of the item that was tapped. It is used to
  /// update the _selectedIndex variable, which is typically used to keep track of the currently selected
  /// item in a list or menu.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// The initState function is called when the widget is first created and it calls the _loadInitialData
  /// function.
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// The function `_loadInitialData` loads initial promotions and airport names from a database and
  /// updates the state with the retrieved data.
  _loadInitialData() async {
    List<Promotion> initialPromos = await dbService.getPromotions();
    List<String> initialAirports = await dbService.getAirportsNames();
    setState(() {
      promo = initialPromos;
      airportsNames = initialAirports;
    });
  }

  /// The function `_updateData()` retrieves updated promotions from a database service and updates the
  /// state with the new data.
  _updateData() async {
    List<Promotion> updatedPromos = await dbService.getPromotions();
    setState(() {
      promo = updatedPromos;
    });
  }

//   Future<List<Map<String, dynamic>>> getAirports() async {
//   final db = await database;
//   return await TodoDB().fetchAirports(db);
// }


  /// This function builds a Scaffold widget with an AppBar, a bottomNavigationBar, and a body that
  /// displays different widgets based on the selected index.
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter is a reference to the current build context. It is
  /// typically used to access the theme, localization, and other information related to the widget tree.
  ///
  /// Returns:
  ///   The `build` method is returning a `Scaffold` widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
            child: Text(
          widget.title,
          style: const TextStyle(color: Color(0xFFfdfcfc)),
        )),
      ),
      bottomNavigationBar: homeNavigationBar(),
      body: <Widget>[
        homePage(promo),
        flightSearchBar(),
        Scheduled(),
        Profile(
          onVerified: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        )
      ][_selectedIndex],
    );
  }

  Container flightSearchBar() {
    return Container(
      color: const Color(0xFF222222),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text(
            'Buscar vuelos',
            style: TextStyle(fontSize: 20, color: Color(0xFFfdfcfc)),
          ),
          Container(
            color: Colors.grey[400],
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text("Desde"),
                            DropdownButton<String>(
                              value: selectedOrigin,
                              hint: const Text("Origen"),
                              items: airportsNames.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOrigin = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        Column(
                          children: [
                            const Text("A"),
                            DropdownButton<String>(
                              value: selectedDestination,
                              hint: const Text("Destino"),
                              items: airportsNames.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDestination = newValue;
                                });
                              },
                            ),
                          ],
                        )
                      ]),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                const Text(
                  "Seleccione el tipo de asiento",
                  style: TextStyle(fontSize: 18),
                ),
                seatSelection,
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedOrigin != null && selectedDestination != null) {
                List<Map<String, dynamic>> availableFlights =
                    await DatabaseService().getAvailableFlights(
                        selectedOrigin!, selectedDestination!);
                List<Flight> flightsList =
                    availableFlights.map((map) => Flight.fromMap(map)).toList();
                print(availableFlights);
                // Ahora puedes usar 'flightsList' para mostrar los resultados en la siguiente pantalla o hacer lo que necesites con la lista de vuelos disponibles.
                // Por ejemplo, podrías pasar 'flightsList' a la página 'reservationPage'.

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => reservationPage(
                      title: "Reservación",
                      origin: selectedOrigin!,
                      destination: selectedDestination!,
                      seatType_: seatSelection.getType()!,
                      availableFlights: flightsList,
                    ),
                  ),
                );
              }
            },
            child: const Text("Buscar"),
          ),
        ],
      ),
    );
  }

  Column homePage(List<Promotion> promoss) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        adsHomePage(),
        const Divider(),
        ElevatedButton(
            onPressed: () async {
              _updateData();
            },
            child: const Text("Actualizar promos")),
        promotionsHomePage(promoss),
      ],
    );
  }

  BottomNavigationBar homeNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF222222),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
          activeIcon: Icon(Icons.home, color: Colors.red),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplanemode_active),
          label: "Reservar",
          activeIcon: Icon(Icons.airplanemode_active, color: Colors.red),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplane_ticket),
          label: "Mis viajes",
          activeIcon: Icon(Icons.airplane_ticket, color: Colors.red),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Perfil",
          activeIcon: Icon(Icons.person, color: Colors.red),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red, // Color de la letra cuando está activo
      unselectedItemColor:
          Colors.white, // Color de la letra cuando no está activo
      onTap: _onItemTapped,
    );
  }
}
