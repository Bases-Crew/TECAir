import 'package:emiratec/components/class_selection.dart';
import 'package:emiratec/components/flight_detail_page.dart';
import 'package:emiratec/objects/flight.dart';
import 'package:emiratec/objects/promotion.dart';
import 'package:flutter/material.dart';

Expanded flightListview(List<Flight>? flightList, seatType seatType_) {
  return Expanded(
    flex: 4,
    child: FutureBuilder<List<Flight>>(
      future: getFlightsList(
          flightList), // Aquí se supone que tendrías una función que retorna Future<List<Movie>>
      builder: (BuildContext context, AsyncSnapshot<List<Flight>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Muestra un indicador de progreso mientras se espera.
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Muestra un mensaje de error si algo sale mal.
        } else {
          List<Flight>? flights = snapshot.data;

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: flights!.length,
            itemBuilder: (context, index) {
              Flight currentFlight = flights[index];

              return InkWell(
                // Lógica para navegar a la nueva página
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlightDetailsPage(
                        reservedflight: currentFlight,
                        seatType__: seatType_,
                      ),
                    ),
                  );
                },

                child: SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex:
                                1, // Puedes ajustar el flex según el espacio que desees que ocupe la imagen en relación al texto
                            child: Image.network(
                                currentFlight.stoImage), // Usa Image.network si es una URL
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Fecha: ${currentFlight.fdate}",
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                  style:
                                      const TextStyle(color: Color(0xFFfdfcfc)),
                                ),
                                Text(
                                  "Ciudad de salida: ${currentFlight.sfromCity}",
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                  style:
                                      const TextStyle(color: Color(0xFFfdfcfc)),
                                ),
                                Text(
                                  "Ciudad de llegada: ${currentFlight.stoCity}",
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                  style:
                                      const TextStyle(color: Color(0xFFfdfcfc)),
                                ),
                                Text(
                                  "No. de vuelo: ${currentFlight.fNumber}",
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                  style:
                                      const TextStyle(color: Color(0xFFfdfcfc)),
                                ),
                                Text(
                                  "Precio: \$${currentFlight.fPrice}",
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                  style:
                                      const TextStyle(color: Color(0xFFfdfcfc)),
                                ),
                                Text(
                                  "Tipo de asiento: ${seatType_.name}",
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                  style:
                                      const TextStyle(color: Color(0xFFfdfcfc)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        }
      },
    ),
  );
}

Future<List<Flight>> getFlightsList(List<Flight>? flightList) async {
  if (flightList != null) {
    return flightList;
  } else {
    return [];
  }
}
