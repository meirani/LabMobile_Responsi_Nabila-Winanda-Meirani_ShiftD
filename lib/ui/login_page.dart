import 'package:flutter/material.dart';
import 'package:responsi_satu/bloc/login_bloc.dart';
import 'package:responsi_satu/helpers/user_info.dart';
import 'package:responsi_satu/ui/genre_page.dart';
import 'package:responsi_satu/ui/registrasi_page.dart';
import 'package:responsi_satu/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'Comic Sans',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow, // AppBar berwarna kuning
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
                _emailTextField(),
                const SizedBox(height: 16.0),
                _passwordTextField(),
                const SizedBox(height: 16.0),
                _buttonLogin(),
                const SizedBox(height: 16.0),
                _menuRegistrasi(),
              ],
            ),
          ),
        ),
      ),
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
        if (value!.isEmpty) {
          return "Password must be filled in";
        }
        return null;
      },
      style: const TextStyle(fontFamily: 'Comic Sans'),
    );
  }

//Membuat Tombol Login
//Membuat Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow, // Tombol berwarna kuning
        ),
        child: const Text(
          "Login",
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
    LoginBloc.login(
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProdukPage()));
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const WarningDialog(
                  description: "Login failed, please try again",
                ));
      }
    }, onError: (error) {
      print(error);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Login failed, please try again",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

// Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 235, 59),
              fontFamily: 'Comic Sans'),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegistrasiPage()));
        },
      ),
    );
  }
}
