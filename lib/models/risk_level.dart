enum RiskLevel {
  low("LOW"),
  medium("MEDIUM"),
  high("HIGH");

  const RiskLevel(this.label);

  final String label;

  static RiskLevel fromScore(int scorePercent) {
    if (scorePercent >= 80) return RiskLevel.low;
    if (scorePercent >= 50) return RiskLevel.medium;
    return RiskLevel.high;
  }
}
