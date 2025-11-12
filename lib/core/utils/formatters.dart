String formatPopulation(int population) {
  if (population >= 1000000) {
    return '${(population / 1000000).toStringAsFixed(1)}M';
  } else if (population >= 1000) {
    return '${(population / 1000).toStringAsFixed(1)}K';
  } else {
    return population.toString();
  }
}
