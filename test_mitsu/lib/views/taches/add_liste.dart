import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../../services/taches.dart';
import 'liste.dart';

class AddTachePage extends StatefulWidget {
  @override
  _AddTachePageState createState() => _AddTachePageState();
}

class _AddTachePageState extends State<AddTachePage> {
  final _formKey = GlobalKey<FormState>();
  final _tachesService = TachesService();

  String _titre = '';
  String _description = '';
  String? _statut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Tâche',style: TextStyle(color:Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFFd40474),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSaved: (value) => _titre = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le titre est obligatoire.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSaved: (value) => _description = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La description est obligatoire.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Statut',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: _statut,
                  items: [
                    DropdownMenuItem(value: 'Complété', child: Text('Complété')),
                    DropdownMenuItem(value: 'Non complété', child: Text('Non complété')),
                  ],
                  onChanged: (value) => setState(() => _statut = value),
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un statut.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('VALIDER',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(350, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        await _tachesService.addTache(_titre, _description, _statut!);
       // Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tâche a été ajouté avec succès.')),
          );

        } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }
}
