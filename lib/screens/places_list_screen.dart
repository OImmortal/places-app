import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Lugares Favoritos"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                child: const Center(
                  child: Text("Nenhum local cadastrado"),
                ),
                builder: (ctx, greatPlaces, ch) {
                  return greatPlaces.itemsCount == 0
                      ? ch!
                      : ListView.builder(
                          itemCount: greatPlaces.itemsCount,
                          itemBuilder: (ctx, i) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                greatPlaces.getItemByIndex(i).image,
                              ),
                            ),
                            title: Text(greatPlaces.getItemByIndex(i).title),
                            subtitle: Text(greatPlaces
                                .getItemByIndex(i)
                                .location!
                                .address!),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.PLACE_DETAIL,
                                arguments: greatPlaces.getItemByIndex(i),
                              );
                            },
                          ),
                        );
                },
              ),
      ),
    );
  }
}
