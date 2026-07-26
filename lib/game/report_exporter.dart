import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/game_result.dart';
import 'risk_level.dart';

class ReportExporter {
  /// Builds the report as a PDF, writes it to the device, then opens the system share sheet so the user can send it anywhere.
  static Future<void> shareReport(GameResult r) async {
    final level = RiskLevel.fromScore(r.scorePercent);

    // colour the score by risk level
    final PdfColor scoreColor = r.scorePercent >= 80
        ? PdfColors.green700
        : (r.scorePercent >= 50 ? PdfColors.orange700 : PdfColors.red700);

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'SCAMMIE - RISK REPORT',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(thickness: 2),
            pw.SizedBox(height: 16),

            pw.Text('Scenario: ${r.scenarioTitle}',
                style: const pw.TextStyle(fontSize: 14)),
            pw.Text('Difficulty: ${r.difficulty}',
                style: const pw.TextStyle(fontSize: 14)),
            pw.Text(
              'Played: ${r.playedAt.day}/${r.playedAt.month}/${r.playedAt.year}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 24),

            // big score line
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  '${r.scorePercent}%',
                  style: pw.TextStyle(
                    fontSize: 48,
                    fontWeight: pw.FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text(
                    '$level RISK',
                    style: pw.TextStyle(fontSize: 16, color: scoreColor),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text('Safe actions: ${r.safeActions}    '
                'Risky actions: ${r.riskyActions}'),
            pw.SizedBox(height: 24),

            // the lessons
            if (r.mistakes.isEmpty)
              pw.Text(
                'Perfect run - no risky choices!',
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green700),
              )
            else ...[
              pw.Text(
                'WHAT TO REMEMBER',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              ...r.mistakes.map(
                (rule) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('* '),
                      pw.Expanded(child: pw.Text(rule)),
                    ],
                  ),
                ),
              ),
            ],

            pw.Spacer(),
            pw.Divider(),
            pw.Text(
              'Trained with Scammie - learn to spot scams before they get you.',
              style: pw.TextStyle(
                  fontSize: 10, fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey700),
            ),
          ],
        ),
      ),
    );

    // 1) File storage: write a real PDF file on the device
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/scammie_report.pdf');
    await file.writeAsBytes(await doc.save());

    // 2) Hand it to the system share sheet
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/pdf')],
        text: 'My Scammie risk report - ${r.scorePercent}%',
      ),
    );
  }
}