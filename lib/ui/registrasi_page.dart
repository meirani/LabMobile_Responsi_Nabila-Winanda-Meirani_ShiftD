import 'package:flutter/material.dart';
import 'package:responsi_satu/bloc/registrasi_bloc.dart';
import 'package:responsi_satu/widget/success_dialog.dart';
import 'package:responsi_satu/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);
  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registration",
          style: TextStyle(
            fontFamily: 'Comic Sans',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      backgroundColor: const Color.fromARGB(90, 255, 235, 59),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFA8072), // Container berwarna salmon
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _namaTextField(),
                const SizedBox(height: 16.0),
                _emailTextField(),
                const SizedBox(height: 16.0),
                _passwordTextField(),
                const SizedBox(height: 16.0),
                _passwordKonfirmasiTextField(),
                const SizedBox(height: 16.0),
                _isLoading
                    ? const CircularProgressIndicator() // Tampilkan loading saat proses berjalan
                    : _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

//Membuat Textbox Nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Name",
        labelStyle: TextStyle(fontFamily: 'Comic Sans'),
        fillColor: Colors.white, // Isian form tetap putih
        filled: true,
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Name must be filled in at least 3 characters";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Comic Sans'),
    );
  }

//Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(fontFamily: 'Comic Sans'),
        fillColor: Colors.white, // Isian form tetap putih
        filled: true,
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
//validasi harus diisi
        if (value!.isEmpty) {
          return 'Email must be filled in';
        }
//validasi email
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Comic Sans'),
    );
  }

//Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(fontFamily: 'Comic Sans'),
        fillColor: Colors.white, // Isian form tetap putih
        filled: true,
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
//jika karakter yang dimasukkan kurang dari 6 karakter
        if (value!.length < 6) {
          return "Password must be filled in at least 6 characters";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Comic Sans'),
    );
  }

//membuat textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        labelStyle: TextStyle(fontFamily: 'Comic Sans'),
        fillColor: Colors.white, // Isian form tetap putih
        filled: true,
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
//jika inputan tidak sama dengan password
        if (value != _passwordTextboxController.text) {
          return "Confirmation Password not the same";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Comic Sans'),
    );
  }

//Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow, // Tombol berwarna kuning
        ),
        child: const Text(
          "Register",
          style: TextStyle(
            fontFamily: 'Comic Sans',
            color: Color(0xFFFA8072),
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        });
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
            nama: _namaTextboxController.text,
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                },
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Registrasi gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}
