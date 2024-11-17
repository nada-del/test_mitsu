import 'package:cloud_firestore/cloud_firestore.dart';

class TachesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Récupère toutes les tâches de la collection 'taches'
  Future<List<Map<String, dynamic>>> getTaches() async {
    try {
      // Récupération des documents de Firestore
      QuerySnapshot snapshot = await _firestore.collection('taches').get();

      // Convertir les données en liste de Map
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des tâches : $e');
    }
  }

  Future<void> addTache(String titre, String description, String statut) async {
    try {
      var docRef = await _firestore.collection('taches').add({
        'titre': titre,
        'description': description,
        'statut': statut,
      });

      await docRef.update({
        'id': docRef.id,  // Ajoute l'ID du document au champ 'id'
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la tâche : $e');
    }
  }

  Future<void> updateTache(String id, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('taches').doc(id).update(updatedData);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la tâche : $e');
    }
  }
  Future<void> deleteTache(String id) async {
    try {
      await _firestore.collection('taches').doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la tâche : $e');
    }
  }

}
