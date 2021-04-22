// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StudentStore on _StudentStore, Store {
  final _$nameAtom = Atom(name: '_StudentStore.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$descriptionAtom = Atom(name: '_StudentStore.description');

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  final _$pathToImageAtom = Atom(name: '_StudentStore.pathToImage');

  @override
  String get pathToImage {
    _$pathToImageAtom.reportRead();
    return super.pathToImage;
  }

  @override
  set pathToImage(String value) {
    _$pathToImageAtom.reportWrite(value, super.pathToImage, () {
      super.pathToImage = value;
    });
  }

  final _$_StudentStoreActionController =
      ActionController(name: '_StudentStore');

  @override
  void changeName(String newName) {
    final _$actionInfo = _$_StudentStoreActionController.startAction(
        name: '_StudentStore.changeName');
    try {
      return super.changeName(newName);
    } finally {
      _$_StudentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDescription(String newDesc) {
    final _$actionInfo = _$_StudentStoreActionController.startAction(
        name: '_StudentStore.changeDescription');
    try {
      return super.changeDescription(newDesc);
    } finally {
      _$_StudentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeImagePath(String newImagePath) {
    final _$actionInfo = _$_StudentStoreActionController.startAction(
        name: '_StudentStore.changeImagePath');
    try {
      return super.changeImagePath(newImagePath);
    } finally {
      _$_StudentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
description: ${description},
pathToImage: ${pathToImage}
    ''';
  }
}
