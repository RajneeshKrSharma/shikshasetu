import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_payment.dart';
import '../../domain/repository/receipt_repository.dart';

/// Builds a one-page PDF receipt.
///
/// Labels are English and amounts use "Rs." because the PDF's built-in font
/// has no Devanagari or rupee glyphs.
class PdfReceiptRepository implements ReceiptRepository {
  static String _headName(FeeHead h) => switch (h) {
    FeeHead.academic => 'Academic fee',
    FeeHead.dress => 'Dress fee',
    FeeHead.books => 'Books fee',
    FeeHead.van => 'Van fee',
    FeeHead.payment => 'Payment',
  };

  static String _modeName(PaymentMode m) => switch (m) {
    PaymentMode.cash => 'Cash',
    PaymentMode.upi => 'UPI',
    PaymentMode.cheque => 'Cheque',
    PaymentMode.bank => 'Bank transfer',
  };

  @override
  Future<String> create({
    required String schoolName,
    required FeeAccount account,
    required FeePayment payment,
    required int balanceAfter,
  }) async {
    final money = NumberFormat.decimalPattern('en_IN');
    final when = DateFormat('d MMM y, h:mm a').format(payment.paidAt);

    pw.Widget row(String label, String value, {bool bold = false}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(label),
              pw.Text(
                value,
                style: bold
                    ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
                    : null,
              ),
            ],
          ),
        );

    final doc = pw.Document()
      ..addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a5,
          build: (_) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                schoolName,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text('Fee receipt'),
              pw.Divider(),
              row('Receipt no.', payment.receiptNo),
              row('Date', when),
              row('Received from', account.name),
              row('Details', account.subtitle),
              row('Fee for', _headName(account.head)),
              row('Paid by', _modeName(payment.mode)),
              if (payment.reference != null)
                row('Reference', payment.reference!),
              pw.Divider(),
              row(
                'Amount received',
                'Rs. ${money.format(payment.amount)}',
                bold: true,
              ),
              row('Total fee', 'Rs. ${money.format(account.total)}'),
              row(
                'Balance after this payment',
                'Rs. ${money.format(balanceAfter)}',
              ),
            ],
          ),
        ),
      );

    final dir = Directory(
      p.join((await getTemporaryDirectory()).path, 'receipts'),
    );
    await dir.create(recursive: true);
    final path = p.join(dir.path, '${payment.receiptNo}.pdf');
    await File(path).writeAsBytes(await doc.save());
    return path;
  }
}
