import 'dart:io';

List<Map<String, dynamic>> products = [];
List<Map<String, dynamic>> transactions = [];

void main() {
  print('=== Sistem Manajemen Barang & POS ===\n');

  // Tambah data dummy
  products.addAll([
    {'id': 1, 'name': 'Buku', 'price': 5000, 'stock': 50},
    {'id': 2, 'name': 'Pensil', 'price': 2000, 'stock': 100},
  ]);

  while (true) {
    print('\nMenu Utama:');
    print('1. Kelola Barang');
    print('2. Transaksi POS');
    print('3. Lihat Laporan');
    print('4. Keluar');
    print('Pilih menu: ');

    var choice = int.tryParse(stdin.readLineSync() ?? '');

    switch (choice) {
      case 1:
        manageProducts();
        break;
      case 2:
        posTransaction();
        break;
      case 3:
        viewReports();
        break;
      case 4:
        exit(0);
      default:
        print('Input tidak valid!');
    }
  }
}

void manageProducts() {
  while (true) {
    print('\nSubmenu Kelola Barang:');
    print('1. Tambah Barang');
    print('2. Lihat Daftar Barang');
    print('3. Update Barang');
    print('4. Hapus Barang');
    print('5. Kembali ke Menu Utama');
    print('Pilih submenu: ');

    var subChoice = int.tryParse(stdin.readLineSync() ?? '');

    switch (subChoice) {
      case 1:
        addProduct();
        break;
      case 2:
        viewProducts();
        break;
      case 3:
        updateProduct();
        break;
      case 4:
        deleteProduct();
        break;
      case 5:
        return;
      default:
        print('Input tidak valid!');
    }
  }
}

void addProduct() {
  try {
    print('\nMasukkan ID Barang: ');
    int id = int.parse(stdin.readLineSync()!);

    print('Nama Barang: ');
    String name = stdin.readLineSync()!;
    if (name.isEmpty) throw Exception('Nama tidak boleh kosong');

    print('Harga: ');
    double price = double.parse(stdin.readLineSync()!);

    print('Stok: ');
    int stock = int.parse(stdin.readLineSync()!);

    products.add({'id': id, 'name': name, 'price': price, 'stock': stock});
    print('Barang berhasil ditambahkan!');
  } catch (e) {
    print('Error: Input tidak valid! ${e.toString()}');
  }
}

void viewProducts() {
  if (products.isEmpty) {
    print('Daftar barang kosong!');
    return;
  }

  print('\nDaftar Barang:');
  for (var product in products) {
    print('ID: ${product['id']}');
    print('Nama: ${product['name']}');
    print('Harga: Rp${product['price']}');
    print('Stok: ${product['stock']}');
    print('-------------------');
  }
}

void updateProduct() {
  try {
    viewProducts();
    print('\nMasukkan ID barang yang akan diupdate: ');
    int id = int.parse(stdin.readLineSync()!);

    var product = products.firstWhere((p) => p['id'] == id);

    print('Nama Barang Baru (${product['name']}): ');
    String newName = stdin.readLineSync()!;
    if (newName.isNotEmpty) product['name'] = newName;

    print('Harga Baru (${product['price']}): ');
    String priceInput = stdin.readLineSync()!;
    if (priceInput.isNotEmpty) product['price'] = double.parse(priceInput);

    print('Stok Baru (${product['stock']}): ');
    String stockInput = stdin.readLineSync()!;
    if (stockInput.isNotEmpty) product['stock'] = int.parse(stockInput);

    print('Barang berhasil diupdate!');
  } catch (e) {
    print('Error: ID tidak ditemukan atau input tidak valid!');
  }
}

void deleteProduct() {
  try {
    viewProducts();
    print('\nMasukkan ID barang yang akan dihapus: ');
    int id = int.parse(stdin.readLineSync()!);

    products.removeWhere((p) => p['id'] == id);
    print('Barang berhasil dihapus!');
  } catch (e) {
    print('Error: ID tidak ditemukan!');
  }
}

void posTransaction() {
  List<Map<String, dynamic>> cart = [];
  double total = 0.0;

  while (true) {
    viewProducts();
    print('\nMasukkan ID barang (0 untuk selesai): ');
    int id = int.parse(stdin.readLineSync() ?? '0');

    if (id == 0) break;

    try {
      var product = products.firstWhere((p) => p['id'] == id);

      print('Masukkan jumlah: ');
      int qty = int.parse(stdin.readLineSync()!);

      if (qty > product['stock']) {
        print('Stok tidak mencukupi!');
        continue;
      }

      cart.add({
        'product': product['name'],
        'price': product['price'],
        'qty': qty,
        'subtotal': product['price'] * qty
      });

      product['stock'] -= qty;
      total += product['price'] * qty;
    } catch (e) {
      print('ID barang tidak valid!');
    }
  }

  if (cart.isNotEmpty) {
    transactions.add({'date': DateTime.now(), 'items': cart, 'total': total});

    print('\nStruk Pembelian:');
    print('Tanggal: ${DateTime.now()}');
    for (var item in cart) {
      print('${item['product']} x${item['qty']}: Rp${item['subtotal']}');
    }
    print('Total: Rp$total');
  }
}

void viewReports() {
  print('\nLaporan Transaksi:');
  if (transactions.isEmpty) {
    print('Belum ada transaksi!');
    return;
  }

  for (var transaction in transactions) {
    print('\nTanggal: ${transaction['date']}');
    print('Items:');
    for (var item in transaction['items']) {
      print('- ${item['product']} x${item['qty']} @Rp${item['price']}');
    }
    print('Total: Rp${transaction['total']}');
  }
}
