// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:appwrite/appwrite.dart';
import '../services/appwrite_service.dart';
import '../repositories/auth_repository.dart';
import '../repositories/database_repository.dart';

// final getIt = GetIt.instance;

void setupServiceLocator() {
  // Appwrite client
  // getIt.registerLazySingleton<Client>(() => Client()
  //   ..setEndpoint('https://cloud.appwrite.io/v1') // Your endpoint
  //   ..setProject('YOUR_PROJECT_ID'));
  //
  // // Appwrite services
  // getIt.registerLazySingleton<Account>(() => Account(getIt<Client>()));
  // getIt.registerLazySingleton<Databases>(() => Databases(getIt<Client>()));
  //
  // // Repositories
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  // // getIt.registerLazySingleton<DatabaseRepository>(() => DatabaseRepository());
}