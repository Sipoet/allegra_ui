import 'package:flutter/material.dart';

class SalesDetailLayout extends StatefulWidget {
  const SalesDetailLayout({super.key});

  @override
  State<SalesDetailLayout> createState() => _SalesDetailLayoutState();
}

class _SalesDetailLayoutState extends State<SalesDetailLayout> {
  final TextEditingController _tanggalController = TextEditingController(
    text: '17/10/2026',
  );
  final TextEditingController _waktuController = TextEditingController(
    text: '21:13:05',
  );
  final TextEditingController _jumlahController = TextEditingController(
    text: '1',
  );
  final TextEditingController _kodeItemController = TextEditingController(
    text: '25010003',
  );

  String _selectedPelanggan = 'UMUM/TOKO';
  String _selectedSales = '';

  // Populated cart items matching the screenshot state
  final List<Map<String, dynamic>> _cartItems = [
    {
      'no': 1,
      'kode': '25010001',
      'ket': 'P010-SGL- BANFF SINGLET ABU L',
      'merek': 'BANFF',
      'jenis': 'SGL',
      'jumlah': 1,
      'satuan': 'PCS',
      'harga': '43.500',
      'pot': '0,00',
      'total': '43.500',
    },
    {
      'no': 2,
      'kode': '25010002',
      'ket': 'D009-KPS-BZKSJN0013 BUZZ kemeja sl...',
      'merek': 'BUZZ',
      'jenis': 'KPS',
      'jumlah': 1,
      'satuan': 'PCS',
      'harga': '224.500',
      'pot': '0,00',
      'total': '224.500',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. TOP HEADER SECTION (Metadata & Giant Total Display: 268.000)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Inputs & Dropdowns
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 70,
                            child: Text(
                              'No Transaksi :',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 24,
                            child: TextField(
                              controller: TextEditingController(text: 'Auto'),
                              enabled: false,
                              style: const TextStyle(fontSize: 11),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: -10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: const Text(
                              'GDG',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: const Text(
                              'ADMIN',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const SizedBox(
                            width: 70,
                            child: Text(
                              'Tanggal :',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 24,
                            child: TextField(
                              controller: _tanggalController,
                              style: const TextStyle(fontSize: 11),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: -10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                suffixIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: 90,
                            height: 24,
                            child: TextField(
                              controller: _waktuController,
                              enabled: false,
                              style: const TextStyle(fontSize: 11),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: -10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const SizedBox(
                            width: 70,
                            child: Text(
                              'Pelanggan :',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            height: 24,
                            child: DropdownButtonFormField<String>(
                              value: _selectedPelanggan,
                              items: ['UMUM/TOKO', 'MEMBER A', 'MEMBER B']
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedPelanggan = val!),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: -10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.purple,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.search,
                                size: 14,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const SizedBox(
                            width: 70,
                            child: Text(
                              'Sales :',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            height: 24,
                            child: DropdownButtonFormField<String>(
                              value: _selectedSales.isEmpty
                                  ? null
                                  : _selectedSales,
                              hint: const Text(
                                '',
                                style: TextStyle(fontSize: 11),
                              ),
                              items: ['Sales 1', 'Sales 2']
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedSales = val!),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: -10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.purple,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.search,
                                size: 14,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right Column: Giant Total Display Panel showing 268.000[cite: 3]
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 100,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    child: const Text(
                      '268.000',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // 2. QUICK ENTRY INPUT ROW
          Container(
            color: const Color(0xFFF8F9FA),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                const Text('Jumlah :', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 6),
                SizedBox(
                  width: 50,
                  height: 24,
                  child: TextField(
                    controller: _jumlahController,
                    style: const TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: -10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Kode Item :', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 6),
                SizedBox(
                  width: 250,
                  height: 24,
                  child: TextField(
                    controller: _kodeItemController,
                    style: const TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: -10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // 3. SECONDARY TOOLBAR BUTTONS
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                _buildSmallButton('Hapus Detail'),
                const SizedBox(width: 2),
                _buildSmallButton('Detail Item'),
                const SizedBox(width: 2),
                _buildSmallButton('Data Serial'),
                const SizedBox(width: 2),
                _buildSmallButton('Lihat Harga'),
                const SizedBox(width: 2),
                _buildSmallButton('Buka Laci [F2]'),
                const SizedBox(width: 2),
                _buildSmallButton('Sistem HJ'),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        color: Colors.white,
                        child: const Text(
                          'Rincian',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        color: Colors.grey.shade200,
                        child: const Text(
                          'Potongan',
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // 4. MAIN DATA TABLE & IMAGE PREVIEW PANEL
          Expanded(
            child: Row(
              children: [
                // Item Data Table Grid with populated rows[cite: 3]
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 24,
                          dataRowHeight: 24,
                          columnSpacing: 12,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'No',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Kode Item',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Keterangan',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Merek',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Jenis',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Jumlah',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Satuan',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Harga',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Pot (%)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: _cartItems.map((item) {
                            return DataRow(
                              selected:
                                  item['no'] ==
                                  2, // Highlights the second row like in screenshot[cite: 3]
                              cells: [
                                DataCell(
                                  Text(
                                    item['no'].toString(),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['kode'],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['ket'],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['merek'],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['jenis'],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['jumlah'].toString(),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['satuan'],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['harga'],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['pot'],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['total'],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                // Right Image Placeholder Panel
                Container(
                  width: 140,
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          color: Colors.grey.shade50,
                        ),
                        child: const Text(
                          'Gambar tidak tersedia',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text('-', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // 5. FOOTER SUMMARY & BOTTOM COMMAND BAR
          Container(
            color: const Color(0xFFECEFF1),
            padding: const EdgeInsets.all(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      _buildCmdButton(
                        Icons.add,
                        'Tambah',
                        Colors.green.shade800,
                      ),
                      _buildCmdButton(
                        Icons.save,
                        'Simpan',
                        Colors.orange.shade800,
                      ),
                      _buildCmdButton(
                        Icons.cancel,
                        'Batal',
                        Colors.red.shade800,
                      ),
                      _buildCmdButton(
                        Icons.print,
                        'Cetak',
                        Colors.blue.shade800,
                      ),
                      _buildCmdButton(
                        Icons.payment,
                        'Bayar [END]',
                        Colors.blue.shade900,
                      ),
                      _buildCmdButton(
                        Icons.pending,
                        'Pending [F5]',
                        Colors.indigo.shade800,
                      ),
                      _buildCmdButton(
                        Icons.list,
                        'Dft.Pending [F6]',
                        Colors.teal.shade800,
                      ),
                    ],
                  ),
                ),
                // Calculation Summary Fields (Sub Total = 2 items[cite: 3], Total = 268.000[cite: 3])
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Potongan :',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 6),
                          _buildSmallTextField('0,00', 80),
                          const SizedBox(width: 4),
                          _buildSmallTextField('0,00', 80),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit, size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Pajak :', style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 6),
                          _buildSmallTextField('0', 80),
                          const SizedBox(width: 4),
                          _buildSmallTextField('0', 80),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit, size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Biaya Lain :',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 16,
                            height: 16,
                            color: Colors.amber,
                            alignment: Alignment.center,
                            child: const Text(
                              '1',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.delivery_dining, size: 14),
                          const SizedBox(width: 4),
                          _buildSmallTextField('0', 164),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit, size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Sub Total :',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 6),
                          _buildSmallTextField(
                            '2',
                            80,
                          ), // Item count subtotal[cite: 3]
                          const SizedBox(width: 4),
                          _buildSmallTextField(
                            '268.000',
                            80,
                          ), // Final total amount[cite: 3]
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Selisih Pembulatan :',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 164,
                            height: 22,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: const Text(
                              '0',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _buildCmdButton(
                    Icons.close,
                    'Tutup',
                    Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFFF0F2F5),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: const Text(
              'Ketik Kode Item, [PG DN/PG UP] : Detail/Header, [END] : Bayar, [F11] : Simpan, [F12] : Hapus',
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String label) {
    return SizedBox(
      height: 22,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade400),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        onPressed: () {},
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildCmdButton(IconData icon, String label, Color color) {
    return SizedBox(
      height: 24,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade400),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        onPressed: () {},
        icon: Icon(icon, size: 12, color: color),
        label: Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSmallTextField(String text, double width) {
    return SizedBox(
      width: width,
      height: 22,
      child: TextField(
        controller: TextEditingController(text: text),
        style: const TextStyle(fontSize: 11),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: -10,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
