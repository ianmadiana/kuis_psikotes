import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.name});

  final String name;

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // list dari pertanyaan
  // menggunakan ? karena variabel kosong dan akan terisi jika dilakukan fetch API
  List<dynamic>? _questions;

  // awal nilai score
  int _score = 0;

  // list untuk menampung jawaban yang dipilih user
  // awal-awal list kosong
  final List _userAnswer = [];

  // fungsi pengacakan Fisher-Yates
  List<dynamic> _fisherYatesShuffle(List<dynamic> list) {
    List<dynamic> shuffledList = List.from(list);

    // memanggil nilai random dari library math.dart untuk digunakan sebagai nilai pengacakan
    Random random = Random();

    for (int i = shuffledList.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      var temp = shuffledList[i];
      shuffledList[i] = shuffledList[j];
      shuffledList[j] = temp;
    }

    return shuffledList;
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // fungsi fetch API
  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://kuis-psikotes1-default-rtdb.firebaseio.com/question.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      print('Respon body = $data');
      print(data.values);

      // variabel untuk menampung data question dan diubah ke bentuk List
      List<dynamic> questions = data.values.toList();

      // Menggunakan fisherYatesShuffle untuk mengacak daftar pertanyaan
      List<dynamic> shuffledQuestions = _fisherYatesShuffle(questions);

      // Menggunakan fungsi untuk mengacak opsi jawaban di setiap pertanyaan
      List<dynamic> shuffledOptions = shuffledQuestions.map((question) {
        List<dynamic> options = question['options'];

        // spread operator (...) digunakan untuk menggabungkan list jawaban dan pertanyaan
        return {
          ...question,
          'options': _fisherYatesShuffle(options),
        };
      }).toList();

      print("Sebelum diacak: ");
      print(questions);
      print('Sesudah diacak: ');
      print(shuffledOptions);

      setState(() {
        _questions = shuffledOptions;
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // judul app bar sesuai nama yang dimasukkan user di home page
        title: Text('Mulai kuis - ${widget.name}'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      // jika _questions bernilai null atau kosong maka akan menampilkan widget loading
      // jika tidak, maka menampilkan listview builder
      body: _questions == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              // menampilkan list view sesuai banyaknya pertanyaan di database
              itemCount: _questions!.length,
              itemBuilder: (context, index) {
                // variabel untuk menampung pertanyaan mulai dari index ke-0
                final question = _questions![index];

                // variabel untuk menampung list jawaban
                final options = question['options'] as List<dynamic>;

                // variabel untuk menampung pertanyaan yang benar
                final correctAnswer = question['correct_answer'];

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: kColorSchemeBlue.onPrimaryContainer),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['question_text'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kColorSchemeBlue.secondary),
                      ),
                      const SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, optionIndex) {
                          final option = options[optionIndex];
                          return ListTile(
                            title: Text(
                              option,
                              style:
                                  TextStyle(color: kColorSchemeBlue.secondary),
                            ),
                            onTap: () {
                              // Handle option selection
                              print(option);

                              if (option == correctAnswer) {
                                print('benar');
                                setState(() {
                                  _score++;
                                });
                              } else {
                                print('salah');
                              }

                              _userAnswer.add(option);

                              print(_userAnswer);
                              print(_score);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
