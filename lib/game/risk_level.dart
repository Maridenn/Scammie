class RiskLevel {
  static String fromScore(int scorePercent) {
    if (scorePercent >= 80) return 'LOW';
    if (scorePercent >= 50) return 'MEDIUM';
    return 'HIGH';
  }

  static String badge(int scorePercent) {
    if (scorePercent >= 80) return 'Cyber Survivor';
    if (scorePercent >= 50) return 'Almost Hacked';
    return 'Data Leaked';
  }
}
