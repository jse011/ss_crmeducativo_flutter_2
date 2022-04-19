import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_data.dart';

class GetLocalJson{

  GetLocalJson();

  // Fetch content from the json file
  Future<List<String>> readAnimalesJson() async {
    final String response = await rootBundle.loadString(DomainData.array_animales);
    Iterable l = await json.decode(response);
    return List<String>.from(l.map((model)=> model as String));
  }

  Future<List<String>> readColoresJson() async {
    final String response = await rootBundle.loadString(DomainData.array_colores);
    Iterable l = await json.decode(response);
    return List<String>.from(l.map((model)=> model as String));
  }

  Future<List<String>> readPaisesJson() async {
    final String response = await rootBundle.loadString(DomainData.array_paises);
    Iterable l = await json.decode(response);
    return List<String>.from(l.map((model)=> model as String));
  }

}