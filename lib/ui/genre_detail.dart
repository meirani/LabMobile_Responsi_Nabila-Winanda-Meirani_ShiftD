import 'package:flutter/material.dart';
import 'package:responsi_satu/bloc/genre_bloc.dart';
import 'package:responsi_satu/model/genre.dart';
import 'package:responsi_satu/ui/genre_form.dart';
import 'package:responsi_satu/ui/genre_page.dart';
import 'package:responsi_satu/widget/warning_dialog.dart';

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget {
  Genre? produk;
  ProdukDetail({Key? key, this.produk}) : super(key: key);
  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            fontFamily: 'Comic Sans',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      backgroundColor: const Color.fromARGB(90, 255, 235, 59),
      body: Center(
        child: Column(
          children: [
            _detailProduk(),
            const SizedBox(height: 20.0), // Jarak antara detail dan tombol
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _detailProduk() {
    return Container(
      width: 500.0, // Lebar tetap
      height: 160.0, // Tinggi tetap
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title : ${widget.produk!.book_title}",
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 8.0), // Jarak antara teks
          Text(
            "Genre : ${widget.produk!.book_genre}",
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 8.0), // Jarak antara teks
          Text(
            "Cover Type : ${widget.produk!.cover_type.toString()}",
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Edit
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFA8072), // Warna tombol salmon
                side: const BorderSide(
                    color: Colors.transparent), // Menghilangkan border
              ),
              child: const Text(
                "EDIT",
                style: TextStyle(
                  color: Colors.white, // Teks putih
                  fontWeight: FontWeight.bold, // Teks tebal
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProdukForm(
                      produk: widget.produk!,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8.0), // Spasi antara tombol

            // Tombol Hapus
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFA8072), // Warna tombol salmon
                side: const BorderSide(
                    color: Colors.transparent), // Menghilangkan border
              ),
              child: const Text(
                "DELETE",
                style: TextStyle(
                  color: Colors.white, // Teks putih
                  fontWeight: FontWeight.bold, // Teks tebal
                ),
              ),
              onPressed: () => confirmHapus(),
            ),
          ],
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Are you sure want to delete this data?"),
      actions: [
        // Tombol Hapus di dalam dialog
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFFFA8072),
            side: const BorderSide(color: Colors.transparent),
          ),
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.white, // Teks putih
              fontWeight: FontWeight.bold, // Teks tebal
            ),
          ),
          onPressed: () {
            GenreBloc.deleteGenre(id: widget.produk!.id!).then(
              (value) => {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProdukPage()))
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Delete failed, please try again",
                  ),
                );
              },
            );
          },
        ),
        // Tombol Batal di dalam dialog
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFFFA8072),
            side: const BorderSide(color: Colors.transparent),
          ),
          child: const Text(
            "No",
            style: TextStyle(
              color: Colors.white, // Teks putih
              fontWeight: FontWeight.bold, // Teks tebal
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
