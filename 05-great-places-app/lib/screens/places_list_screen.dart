import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../routes.dart';
import '../widgets/custom_future_builder.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(Routes.addPlace()),
          )
        ],
      ),
      body: CustomFutureBuilder(
        future: (_) => Provider.of<GreatPlaces>(context, listen: false).fetchAndSetPlaces(),
        successBuilder: (_, __) => Consumer<GreatPlaces>(
          child: const Center(child: Text('Got no places yet, start adding some!')),
          builder: (_, greatPlaces, child) {
            if (greatPlaces.items.isEmpty) {
              return child!;
            }
            return ListView.builder(
              itemCount: greatPlaces.items.length,
              itemBuilder: (ctx, index) {
                final place = greatPlaces.items[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: FileImage(place.image)),
                  title: Text(place.title),
                  subtitle: Text(place.location.address!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(ctx).errorColor,
                    onPressed: () => greatPlaces.removePlace(place.id),
                  ),
                  onTap: () => Navigator.of(context).push(Routes.placeDetail(place)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
