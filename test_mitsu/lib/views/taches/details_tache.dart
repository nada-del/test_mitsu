import 'package:flutter/material.dart';
import '../../services/taches.dart';
import 'liste.dart';

class DetailTachePage extends StatefulWidget {
  final String id;
  final String titre;
  final String description;
  final String statut;

  DetailTachePage({
    required this.id,
    required this.titre,
    required this.description,
    required this.statut,
  });

  @override
  _DetailTachePageState createState() => _DetailTachePageState();
}

class _DetailTachePageState extends State<DetailTachePage> {
  final TachesService _tachesService = TachesService();
  late TextEditingController _titreController;
  late TextEditingController _descriptionController;
  late TextEditingController _statutController;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.titre);
    _descriptionController = TextEditingController(text: widget.description);
    _statutController = TextEditingController(text: widget.statut);
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _statutController.dispose();
    super.dispose();
  }

  Future<void> _modifierTache() async {
    try {
      final updatedData = {
        'titre': _titreController.text.trim(),
        'description': _descriptionController.text.trim(),
        'statut': _statutController.text.trim(),
      };

      await _tachesService.updateTache(widget.id, updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tâche mise à jour avec succès !')),
      );
      //Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail de la tâche',style: TextStyle(color:Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFFd40474),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titreController,
              decoration: InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _statutController,
              decoration: InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _modifierTache,
              child: Text('MODIFIER', style: TextStyle(
                color: Colors.white,
              ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
