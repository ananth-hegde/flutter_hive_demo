// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TeacherStore on _TeacherStore, Store {
  final _$nameAtom = Atom(name: '_TeacherStore.name');

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

  final _$descriptionAtom = Atom(name: '_TeacherStore.description');

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

  final _$pathToImageAtom = Atom(name: '_TeacherStore.pathToImage');

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

  final _$_TeacherStoreActionController =
      ActionController(name: '_TeacherStore');

  @override
  void changeName(String newName) {
    final _$actionInfo = _$_TeacherStoreActionController.startAction(
        name: '_TeacherStore.changeName');
    try {
      return super.changeName(newName);
    } finally {
      _$_TeacherStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDescription(String newDesc) {
    final _$actionInfo = _$_TeacherStoreActionController.startAction(
        name: '_TeacherStore.changeDescription');
    try {
      return super.changeDescription(newDesc);
    } finally {
      _$_TeacherStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeImagePath(String newImagePath) {
    final _$actionInfo = _$_TeacherStoreActionController.startAction(
        name: '_TeacherStore.changeImagePath');
    try {
      return super.changeImagePath(newImagePath);
    } finally {
      _$_TeacherStoreActionController.endAction(_$actionInfo);
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
