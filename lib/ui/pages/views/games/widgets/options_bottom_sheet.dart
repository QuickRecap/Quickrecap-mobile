import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../domain/entities/activity.dart';
import 'dart:convert';

class OptionsBottomSheet {
  final BuildContext context;
  final Activity activity;
  final Function(bool) onPrivacyChanged;
  final Function(bool) onFavoriteChanged;
  bool _localIsPrivate;
  bool _isFavorite;

  OptionsBottomSheet({
    required this.context,
    required this.activity,
    required this.onPrivacyChanged,
    required this.onFavoriteChanged,
  }) : _localIsPrivate = activity.private,
        _isFavorite = activity.favorite;

  void show() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  _buildOptions(setModalState),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.close, size: 30, weight: 700),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Configuración de la actividad',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildOptions(StateSetter setModalState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFavoriteOption(setModalState),
          _buildPrivacyOption(setModalState),
        ],
      ),
    );
  }

  Widget _buildFavoriteOption(StateSetter setModalState) {
    return GestureDetector(
      onTap: () => _toggleFavorite(setModalState),
      child: Row(
        children: [
          Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.grey,
          ),
          SizedBox(width: 10),
          Text('Favorito'),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(StateSetter setModalState) {
    return GestureDetector(
      onTap: () => _togglePrivacy(setModalState),
      child: Row(
        children: [
          Icon(
            _localIsPrivate ? Icons.lock : Icons.lock_open,
            color: _localIsPrivate ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 10),
          Text(_localIsPrivate ? 'Privado' : 'Público'),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(StateSetter setModalState) async {
    bool success = await _updateActivityProperty('favorito', !_isFavorite);
    if (success) {
      setModalState(() {
        _isFavorite = !_isFavorite;
      });
      onFavoriteChanged(_isFavorite);
    }
  }

  Future<bool> changePrivacy(bool newPrivacyStatus) async {
    bool success = await _updateActivityProperty('private', newPrivacyStatus);
    if (success) {
      _localIsPrivate = newPrivacyStatus;
      onPrivacyChanged(_localIsPrivate);
    }
    return success;
  }

  Future<void> _togglePrivacy(StateSetter setModalState) async {
    bool success = await changePrivacy(!_localIsPrivate);
    if (success) {
      setModalState(() {
        _localIsPrivate = !_localIsPrivate;
      });
    }
  }

  Future<bool> _updateActivityProperty(String property, dynamic value) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/quickrecap/activity/update/${activity.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          property: value.toString(),
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _showErrorSnackBar('No pudimos actualizar la actividad');
        return false;
      }
    } catch (e) {
      _showErrorSnackBar('Error de conexión: $e');
      return false;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}