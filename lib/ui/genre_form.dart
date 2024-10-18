import 'package:flutter/material.dart';
import 'package:responsi_satu/bloc/genre_bloc.dart';
import 'package:responsi_satu/model/genre.dart';
import 'package:responsi_satu/ui/genre_page.dart';
import 'package:responsi_satu/widget/warning_dialog.dart';

// ignore: must_be_immutable
class ProdukForm extends StatefulWidget {
  Genre? produk;
  ProdukForm({Key? key, this.produk}) : super(key: key);
  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "ADD BOOK";
  String tombolSubmit = "SAVE";
  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "EDIT BOOK";
        tombolSubmit = "EDIT";
        _kodeProdukTextboxController.text = widget.produk!.book_title!;
        _namaProdukTextboxController.text = widget.produk!.book_genre!;
        _hargaProdukTextboxController.text =
            widget.produk!.cover_type.toString();
      });
    } else {
      judul = "ADD BOOK";
      tombolSubmit = "SAVE";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          judul,
          style: const TextStyle(
            fontFamily: 'Comic Sans',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      backgroundColor: const Color.fromARGB(90, 255, 235, 59),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

// Membuat Textbox Kode Produk
  Widget _kodeProdukTextField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0), // Jarak antar field
      padding: const EdgeInsets.all(10.0), // Padding dalam field
      decoration: BoxDecoration(
        color: Colors.white, // Warna background field
        borderRadius: BorderRadius.circular(10.0), // Membuat sudut melengkung
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0, // Efek bayangan
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: "Title",
          labelStyle: TextStyle(fontFamily: 'Comic Sans'),
          border: InputBorder.none, // Menghilangkan border default
        ),
        keyboardType: TextInputType.text,
        controller: _kodeProdukTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Title must be filled in";
          }
          return null;
        },
      ),
    );
  }

// Membuat Textbox Nama Produk
  Widget _namaProdukTextField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0), // Jarak antar field
      padding: const EdgeInsets.all(10.0), // Padding dalam field
      decoration: BoxDecoration(
        color: Colors.white, // Warna background field
        borderRadius: BorderRadius.circular(10.0), // Membuat sudut melengkung
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0, // Efek bayangan
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: "Genre",
          labelStyle: TextStyle(fontFamily: 'Comic Sans'),
          border: InputBorder.none, // Menghilangkan border default
        ),
        keyboardType: TextInputType.text,
        controller: _namaProdukTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Genre must be filled in";
          }
          return null;
        },
      ),
    );
  }

// Membuat Textbox Harga Produk
  Widget _hargaProdukTextField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0), // Jarak antar field
      padding: const EdgeInsets.all(10.0), // Padding dalam field
      decoration: BoxDecoration(
        color: Colors.white, // Warna background field
        borderRadius: BorderRadius.circular(10.0), // Membuat sudut melengkung
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0, // Efek bayangan
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: "Cover Type",
          labelStyle: TextStyle(fontFamily: 'Comic Sans'),
          border: InputBorder.none, // Menghilangkan border default
        ),
        keyboardType: TextInputType.number,
        controller: _hargaProdukTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Cover Type must be filled in";
          }
          return null;
        },
      ),
    );
  }

// Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0), // Jarak antara tombol dan field terakhir
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFFA8072), // Warna tombol salmon
          side: const BorderSide(
            color: Colors.transparent, // Menghilangkan border
          ),
        ),
        child: Text(
          tombolSubmit,
          style: const TextStyle(
            color: Colors.white, // Teks putih
            fontWeight: FontWeight.bold, // Teks tebal
          ),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.produk != null) {
                // kondisi update produk
                ubah();
              } else {
                // kondisi tambah produk
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Genre createGenre = Genre(id: null);
    createGenre.book_title = _kodeProdukTextboxController.text;
    createGenre.book_genre = _namaProdukTextboxController.text;
    createGenre.cover_type = _hargaProdukTextboxController.text;
    GenreBloc.addGenre(Genre: createGenre).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const ProdukPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Genre updateGenre = Genre(id: widget.produk!.id!);
    updateGenre.book_title = _kodeProdukTextboxController.text;
    updateGenre.book_genre = _namaProdukTextboxController.text;
    updateGenre.cover_type = _hargaProdukTextboxController.text;
    GenreBloc.updateGenre(Genre: updateGenre).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const ProdukPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}
