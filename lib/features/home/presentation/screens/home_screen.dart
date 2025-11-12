import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/formatters.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import '../../../../features/details/presentation/screens/detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late HomeCubit homeCubit;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    homeCubit = HomeCubit(RepositoryProvider.of(context))..fetchCountries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeTab(),
      const FavoritesScreen(),
    ];

    return BlocProvider.value(
      value: homeCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_selectedIndex == 0 ? 'Countries' : 'Favorites'),
          centerTitle: true,
        ),
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1 ? Icons.favorite : Icons.favorite_border,
              ),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a country',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) => setState(() {}),
            ),
          ),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final isSearching = _searchController.text.isNotEmpty;
                final filteredCountries = state.countries
                    .where((c) => c.common
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                    .toList();

                if (state.status == HomeStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == HomeStatus.failure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.errorMessage),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<HomeCubit>().fetchCountries(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.status == HomeStatus.success) {
                  if (filteredCountries.isEmpty) {
                    return const Center(child: Text('No countries found.'));
                  }

                  // ✅ Pull-to-refresh added here
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<HomeCubit>().fetchCountries();
                    },
                    child: ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        return ListTile(
                          leading: Hero(
                            tag: 'flag-${country.code}', // ✅ Hero tag
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                country.flagUrl,
                                width: 50,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(country.common),
                          subtitle: isSearching
                              ? null
                              : Text(
                                  'Population: ${formatPopulation(country.population)}',
                                ),
                          trailing: isSearching
                              ? null
                              : IconButton(
                                  icon: Icon(
                                    country.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: country.isFavorite
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () => context
                                      .read<HomeCubit>()
                                      .toggleFavorite(country.code),
                                ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(country: country),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
