import 'package:flutter/material.dart';
import '../../../../core/network/app_client.dart';
import '../../../../core/utils/formatters.dart';

class DetailScreen extends StatefulWidget {
  final dynamic country;
  const DetailScreen({super.key, required this.country});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Map<String, dynamic>> _countryDetails;
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    _countryDetails = _apiClient.getCountryDetails(widget.country.code);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.common),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _countryDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading details: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final data = snapshot.data!;
          final flagUrl = data['flags']?['png'] ?? '';
          final population = data['population'] ?? 0;
          final region = data['region'] ?? 'N/A';
          final subregion = data['subregion'] ?? 'N/A';
          final area = data['area'] ?? 0;
          final timezones = (data['timezones'] as List?) ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Hero animation for flag
                Hero(
                  tag: 'flag-${widget.country.code}',
                  child: Container(
                    height: screenHeight * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(flagUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // ✅ Padded content below image
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Key Statistics",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildStatRow("Area", "${area.toStringAsFixed(0)} sq km"),
                      _buildStatRow("Population", formatPopulation(population)),
                      _buildStatRow("Region", region),
                      _buildStatRow("Sub Region", subregion),

                      const SizedBox(height: 20),
                      const Text(
                        "Timezone",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: timezones
                            .map((tz) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    tz,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              )),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
