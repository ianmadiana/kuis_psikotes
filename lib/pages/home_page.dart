import 'package:flutter/material.dart';
import 'package:kuis_psikotes/pages/quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controller untuk menampung input nama user
  final _nameController = TextEditingController();

  // variabel awal username
  String _userName = 'No Name';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Text(_userName),
            const SizedBox(height: 20),
            TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Enter your name',
                    labelStyle: Theme.of(context).textTheme.titleMedium),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 300),
            ElevatedButton(
              onPressed: () {
                // jika user tidak memasukkan nama (kosong) atau user memasukkan input selain huruf dan menekan tombol submit maka akan menampikan Alert Dialog
                if (_nameController.text.isEmpty ||
                    !RegExp(r'^[a-zA-Z\s]+$').hasMatch(_nameController.text)) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: const Text('Masukkan nama yang sesuai'),
                              content: const Text('Input tidak valid'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Okay'))
                              ]));
                } else {
                  // jika user input nama dengan benar maka akan mengeset username sesuai inputan
                  // dan menuju ke halaman kuis menggunakan Navigator
                  setState(() {
                    _userName = _nameController.text.isNotEmpty
                        ? _nameController.text
                        : 'No Name';
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(name: _userName),
                    ),
                  );
                }
              },
              child: const Text('Mulai kuis'),
            ),
          ],
        ),
      ),
    );
  }
}
