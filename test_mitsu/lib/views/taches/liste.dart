import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../../services/taches.dart';
import 'add_liste.dart';
import 'details_tache.dart';

class ListeTachePage extends StatefulWidget {
  @override
  _ListeTachePageState createState() => _ListeTachePageState();
}

class _ListeTachePageState extends State<ListeTachePage> {
  final TachesService _tachesService = TachesService();
  List<Map<String, dynamic>> _taches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTaches();
  }
  Future<void> _refreshTaches() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final nouvellesTaches = await _tachesService.getTaches();
      setState(() {
        _taches = nouvellesTaches;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l’actualisation : $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _fetchTaches() async {
    try {
      List<Map<String, dynamic>> taches = await _tachesService.getTaches();
      setState(() {
        _taches = taches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> _deleteTache(String id) async {
    try {
      await _tachesService.deleteTache(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tâche supprimée avec succès')),
      );
      _fetchTaches();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Tâches', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFFd40474),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshTaches, // Méthode appelée lors du "pull-to-refresh"
        child: ListView.builder(
          itemCount: _taches.length,
          itemBuilder: (context, index) {
            final tache = _taches[index];
            return Dismissible(
              key: Key(tache['id'] ?? ''),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.topSlide,
                  title: 'Confirmation',
                  desc: 'Êtes-vous sûr de vouloir supprimer cette tâche ?',
                  btnCancelOnPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Suppression annulée')),
                    );
                  },
                  btnOkOnPress: () {
                    _deleteTache(tache['id']).then((_) {
                      setState(() {
                        _taches.removeAt(index);
                      });
                    });
                  },
                ).show();
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(tache['titre'] ?? 'Titre indisponible'),
                  subtitle: Text(tache['description'] ?? 'Description indisponible'),
                  trailing: Text(
                    tache['statut'] ?? 'Statut',
                    style: TextStyle(
                      color: (tache['statut']?.toLowerCase() == 'complété')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTachePage(
                          id: tache['id'] ?? '',
                          titre: tache['titre'] ?? '',
                          description: tache['description'] ?? '',
                          statut: tache['statut'] ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTachePage(),
            ),
          );
        },
        backgroundColor: Color(0xFFd40474),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
