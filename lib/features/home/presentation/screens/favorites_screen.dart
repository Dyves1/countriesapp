import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final favorites = state.countries
            .where((c) => c.isFavorite)
            .where((c) => c.common
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();

        if (favorites.isEmpty) {
          return Scaffold(
            // appBar: AppBar(title: const Text('Favorites')),
            body: const Center(
              child: Text('No favorite countries yet.'),
            ),
          );
        }

        return Scaffold(

          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search in favorites',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final country = favorites[index];
return ListTile(
  leading: ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: Image.network(
      country.flagUrl,
      width: 50,
      height: 35,
      fit: BoxFit.cover,
    ),
  ),
  title: Text(country.common),
  subtitle: Text('Capital: ${country.capital ?? 'N/A'}'),
  trailing: IconButton(
    icon: const Icon(Icons.favorite, color: Colors.red),
    onPressed: () =>
        context.read<HomeCubit>().toggleFavorite(country.code),
  ),
);

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
