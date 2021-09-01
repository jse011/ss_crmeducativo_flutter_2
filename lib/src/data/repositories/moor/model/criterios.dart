import 'package:moor_flutter/moor_flutter.dart';

class Criterio extends Table{
  
IntColumn get sesionAprendizajeId => integer()();
IntColumn get unidadAprendiajeId => integer()();
IntColumn get silaboEventoId => integer()();

IntColumn get sesionAprendizajePadreId => integer().nullable()();

TextColumn get tituloSesion => text().nullable()();
IntColumn get rolIdSesion => integer().nullable()();
IntColumn get nroSesion => integer().nullable()();
TextColumn get propositoSesion => text().nullable()();
TextColumn get tituloUnidad => text().nullable()();
IntColumn get nroUnidad => integer().nullable()();
/// <summary>
/// Tabla Competencias
/// </summary>
IntColumn get competenciaId => integer()();
TextColumn get competenciaNombre => text().nullable()();
TextColumn get competenciaDescripcion => text().nullable()();
IntColumn get competenciaTipoId => integer().nullable()();
IntColumn get superCompetenciaId => integer().nullable()();
TextColumn get superCompetenciaNombre => text().nullable()();
TextColumn get superCompetenciaDescripcion => text().nullable()();
IntColumn get superCompetenciaTipoId => integer().nullable()();


/// <summary>
/// Tabla DesempenioIcd Desempenio Icd
/// </summary>
IntColumn get desempenioIcdId => integer()();
TextColumn get DesempenioDescripcion => text().nullable()();
IntColumn get peso => integer().nullable()();
TextColumn get codigo => text().nullable()();
IntColumn get tipoId => integer().nullable()();
TextColumn get url => text().nullable()();
IntColumn get desempenioId => integer().nullable()();
TextColumn get desempenioIcdDescripcion => text().nullable()();
IntColumn get icdId => integer().nullable()();
TextColumn get icdTitulo => text().nullable()();
TextColumn get icdDescripcion => text().nullable()();
TextColumn get icdAlias => text().nullable()();

/// <summary>
/// Tabla CampoTematico
/// </summary>
/// 

IntColumn get campoTematicoId => integer()();
TextColumn get campoTematicoTitulo => text().nullable()();
TextColumn get campoTematicoDescripcion => text().nullable()();
IntColumn get campoTematicoEstado => integer().nullable()();
IntColumn get campoTematicoParentId => integer().nullable()();
TextColumn get campoTematicoParentTitulo => text().nullable()();
TextColumn get campoTematicoParentDescripcion => text().nullable()();
IntColumn get campoTematicoParentEstado => integer().nullable()();
IntColumn get campoTematicoParentParentId => integer().nullable()();
IntColumn get calendarioPeriodoId => integer().nullable()();

@override
  Set<Column> get primaryKey => { silaboEventoId, unidadAprendiajeId, sesionAprendizajeId, competenciaId, desempenioIcdId, campoTematicoId};
}