// class_bloc.dart
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassRepository classRepository;

  ClassBloc(this.classRepository) : super(ClassInitial()) {
    on<LoadClassesEvent>((event, emit) async {
      try {
        final classes = await classRepository.fetchClasses();
        emit(ClassesLoaded(classes));
      } catch (error) {
        emit(ClassError("Failed to load classes"));
      }
    });

on<AddClassEvent>((event, emit) async {
  try {
    final newClass = ClassModel(
      id: '',  // Might be generated by the backend, so this can stay empty
      grade: event.grade,  // Get this value from the user
      className: event.className,  // Get this from the event
      classCode: event.classCode,  // Set this
      school: event.school,  // Set this value appropriately
      students: [],  // Assuming empty for now
      teachers: [],  // Assuming empty for now
      guardians: [],
      announcements: [],
    );
    await classRepository.createClass(newClass);
    final classes = await classRepository.fetchClasses();  // Fetch updated classes list
    emit(ClassesLoaded(classes));
  } catch (error) {
    emit(ClassError("Failed to add class"));
  }
});


    on<DeleteClassEvent>((event, emit) async {
      try {
        await classRepository.deleteClass(event.className);
        final classes = await classRepository.fetchClasses();
        emit(ClassesLoaded(classes));
      } catch (error) {
        emit(ClassError("Failed to delete class"));
      }
    });
  }
}
