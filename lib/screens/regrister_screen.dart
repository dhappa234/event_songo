import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart'; // Akses supabase client

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _angkatanController = TextEditingController();
  final _fakultasController = TextEditingController(); // Controller baru

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _angkatanController.dispose();
    _fakultasController.dispose();
    super.dispose();
  }

  // === FUNGSI REGISTRASI SUPABASE ===
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // --- Tahap 1: Registrasi Pengguna (Auth) ---
      // Ini membuat entri di auth.users dan mengirim email verifikasi (jika diaktifkan)
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        // Ini menangkap error jika sign up gagal tanpa throw exception (misal: RLS Auth error)
        throw Exception('Registrasi Auth gagal. Cek kembali setting Supabase Auth.');
      }

      // --- Tahap 2: Simpan Data Profil Tambahan (Database) ---
      final profileData = {
        'id': user.id, // Kunci utama dan foreign key ke auth.users
        'email': email,
        'nama_lengkap': _nameController.text.trim(),
        'angkatan': _angkatanController.text.trim(),
        // Sesuaikan kolom di Supabase: kita asumsikan kolomnya 'jurusan'
        'jurusan': _fakultasController.text.trim(),
      };

      // Pastikan RLS di tabel 'profiles' mengizinkan INSERT oleh pengguna yang baru terautentikasi.
      await supabase.from('profiles').insert(profileData);

      // --- Tahap 3: Selesai ---
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.')),
        );
        Navigator.of(context).pushReplacementNamed('/'); // Kembali ke halaman Login
      }

    } catch (e) {
      if (mounted) {
        // Tampilkan pesan error yang lebih bersih
        final errorMessage = e.toString().contains('message: ')
            ? e.toString().split('message: ').last.split(', statusCode:')[0]
            : e.toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Widget Input Field ---
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return '$label wajib diisi.';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Masukkan $label',
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.7)),
            filled: true,
            fillColor: kCardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR AKUN', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Buat Akun EVENTSONGO!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),

                // Nama Lengkap
                _buildInputField(
                  label: 'Nama Lengkap',
                  controller: _nameController,
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),

                // Email
                _buildInputField(
                  label: 'Email',
                  controller: _emailController,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password
                _buildInputField(
                  label: 'Password',
                  controller: _passwordController,
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 20),

                // Angkatan
                _buildInputField(
                  label: 'Angkatan',
                  controller: _angkatanController,
                  icon: Icons.school,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Fakultas/Jurusan
                _buildInputField(
                  label: 'Fakultas/Jurusan',
                  controller: _fakultasController,
                  icon: Icons.apartment,
                ),
                const SizedBox(height: 30),


                // Tombol Register
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                        : const Text(
                      'DAFTAR',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke Login
                  },
                  child: const Text(
                    'Sudah punya akun? Login di sini',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}