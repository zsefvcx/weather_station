// import 'dart:io';
//
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart'
//         if(dart.library.io.Platform.isWindows)'package:sqflite_common_ffi/sqflite_ffi.dart'
//         if(dart.library.io.Platform.isLinux  )'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:weather_station/common/common.dart';
//
// class DataBaseSqfLiteImpl {
//   static String? _lastUuid;
//   static bool isBusyInit = false;
//
//   final String _uuid;
//
//   DataBaseSqfLiteImpl._({required String uuid}): _uuid = uuid;
//
//   static DataBaseSqfLiteImpl? _db;
//   static Database? _database;
//
//   Future<String> localPath({required String uuid}) async {
//     final directory = await getApplicationSupportDirectory();
//     final path = '${directory.path}/${uuid}_database.db';
//     Logger.print('PathToDataBase:$path');
//     return path;
//   }
//
//   Future<File> localFile({required String uuid}) async {
//     return File(await localPath(uuid: uuid));
//   }
//
//   Future<Database> get database async {
//     if (isBusyInit) {
//       await Future.doWhile(() async {
//         await Future.delayed(const Duration(milliseconds: 100));
//         return isBusyInit;
//       });
//     }
//     isBusyInit = true;
//     final resDB = _database ??= await _initDB(uuid: _uuid);
//     isBusyInit = false;
//     return resDB;
//   }
//
//   Future<Database> _initDB({required String uuid}) async {
//     final path = await localPath(uuid: uuid);
//     _lastUuid = uuid;
//     return openDatabase(path, version: 3, onCreate: _createDB);
//   }
//
//   // ignore: prefer_constructors_over_static_methods
//   static DataBaseSqfLiteImpl db({required String uuid}) {
//     if (_lastUuid != null && _lastUuid != uuid){
//       _database?.close();
//       _database = null;
//       _db = null;
//     }
//     _lastUuid = uuid;
//
//     return _db ??= DataBaseSqfLiteImpl._(uuid: uuid);
//   }
//
//   //v1
//   static const String _tableMonthCurrent = 'MonthCurrent';
//   static const String _id = 'id';
//   static const String _year = 'year';
//   static const String _month = 'month';
//   //v2
//   static const String _tableCategories = 'Categories';
//   static const String _name = 'name';
//   static const String _colorHex = 'colorHex';
//   //v3
//   static const String _tableExpenses = 'Expenses';
//   static const String _idCategory = 'idCategory';
//   static const String _idMonth = 'idMonth';
//   static const String _dateTime = 'dateTime';
//   static const String _sum = 'sum';
//
//   Future<void> _createDB(Database db, int version) async {
//     try {
//       if(version >=1){
//         await db.execute(
//             'CREATE TABLE "$_tableMonthCurrent" ( '
//                 '"$_id" INTEGER PRIMARY KEY AUTOINCREMENT, '
//                 '"$_year" INTEGER, '
//                 '"$_month" INTEGER '
//                 ')'
//         );
//       }
//       if(version >=2){
//         await db.execute(
//             'CREATE TABLE "$_tableCategories" ( '
//                 '"$_id" INTEGER PRIMARY KEY AUTOINCREMENT, '
//                 '"$_name" TEXT, '
//                 '"$_colorHex" TEXT '
//                 ')'
//         );
//       }
//       if(version >=3){
//         await db.execute(
//             'CREATE TABLE "$_tableExpenses" ( '
//                 '"$_id" INTEGER PRIMARY KEY AUTOINCREMENT, '
//                 '"$_idCategory" INTEGER, '
//                 '"$_idMonth" INTEGER, '
//                 '"$_dateTime" TEXT, '
//                 '"$_sum" TEXT '
//                 ')'
//         );
//       }
//     } on Exception catch (e,t){
//       Logger.print('$e\n$t', name: 'err', level: 1, error: true);
//       throw ArgumentError('Error create db!');
//     }
//   }
//
//   // ///READ GROUP
//   // ///Пока получаем все элементы из списка
//   // @override
//   // Future<List<int>> findAllMonthInYear(int year) async {
//   //   final db = await database;
//   //   final List<Map<String, dynamic>> groupsMapList =
//   //       await db.query(_tableMonthCurrent,
//   //         where: '$_year = ?',
//   //         whereArgs: [year],
//   //         orderBy: _month
//   //       );
//   //   final groupList = <int>[];
//   //
//   //   for (final element in groupsMapList) {
//   //     groupList.add(
//   //         MonthCurrent.fromJson(element).month
//   //     );
//   //   }
//   //   return groupList;
//   // }
//   //
//   //
//   // ///INSERT findMonthById
//   // @override
//   // Future<MonthCurrent?> findMonthById(int id) async {
//   //   final db = await database;
//   //   final List<Map<String, dynamic>> groupsMapList =
//   //       await db.query(_tableMonthCurrent,
//   //       where: '$_id = ?',
//   //       whereArgs: [id],
//   //   );
//   //
//   //   for (final element in groupsMapList) {
//   //     return MonthCurrent.fromJson(element);
//   //   }
//   //   return null;
//   // }
//   //
//   // ///INSERT Group
//   // @override
//   // Future<int> insertMonth(MonthCurrent data,
//   //     {
//   //       ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.ignore
//   //     }) async {
//   //   final db = await database;
//   //
//   //   /// должно быть уникальное
//   //   final query = await db.query(_tableMonthCurrent,
//   //        where: '"$_year" = ? and "$_month" = ?',
//   //        whereArgs: [data.year, data.month]);
//   //
//   //   if (query.isNotEmpty){
//   //     if (query[0].isNotEmpty){///только первое вхождение
//   //       final id = query[0][_id];
//   //       if (id != null && id is int){
//   //         return id;
//   //       }
//   //     }
//   //   }
//   //
//   //   return db.insert(
//   //     _tableMonthCurrent,
//   //     data.toJson(),
//   //     conflictAlgorithm: conflictAlgorithm,
//   //   );
//   // }
//   //
//   // ///DELETE GID
//   // @override
//   // Future<int> deleteMonth(int gid) async {
//   //   final db = await database;
//   //   return db.delete(
//   //           _tableMonthCurrent,
//   //           where: '"$_id" = ?',
//   //           whereArgs: [gid]
//   //   );
//   // }
//   //
//   // ///DELETE ALL
//   // Future<void> deleteAll() async {
//   //   await _database?.close();
//   //   _database = null;
//   //   final file = await localFile(uuid: _uuid);
//   //   await file.delete();
//   // }
//   //
//   // @override
//   // Future<CategoriesExpensesModels?> getAllCategoryId() async {
//   //   final db = await database;
//   //   final List<Map<String, dynamic>> groupsMapList =
//   //       await db.query(_tableCategories,
//   //           orderBy: _name
//   //   );
//   //   final allId = <CategoryExpenses>{};
//   //
//   //   for (final element in groupsMapList) {
//   //     allId.add(
//   //         CategoryExpenses.fromJson(element)
//   //     );
//   //   }
//   //   return CategoriesExpensesModels(
//   //     categoriesId: allId
//   //   );
//   // }
//   //
//   // @override
//   // Future<CategoryExpenses?> getCategoryById({required int id}) async {
//   //   final db = await database;
//   //   final List<Map<String, dynamic>> groupsMapList =
//   //       await db.query(_tableCategories,
//   //       where: '$_id = ?',
//   //       whereArgs: [id]
//   //   );
//   //
//   //   for (final element in groupsMapList) {
//   //     return CategoryExpenses.fromJson(element);
//   //   }
//   //   return null;
//   // }
//   //
//   // @override
//   // Future<int> deleteCategory(int id) async {
//   //   final db = await database;
//   //   return db.delete(
//   //       _tableCategories,
//   //       where: '"$_id" = ?',
//   //       whereArgs: [id]
//   //   );
//   // }
//   //
//   // @override
//   // Future<int> insertCategory(CategoryExpenses data, {
//   //   ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.ignore
//   // }) async {
//   //   final db = await database;
//   //
//   //   ///имя должно быть уникальное
//   //   final query = await db.query(_tableCategories,
//   //       where: '"$_name" = ?',
//   //       whereArgs: [data.name]);
//   //
//   //   if (query.isNotEmpty){
//   //     if (query[0].isNotEmpty){///только первое вхождение
//   //       final id = query[0][_id];
//   //       if (id != null && id is int){
//   //         return id;
//   //       }
//   //     }
//   //   }
//   //
//   //   ///имя и цвет тоже должны быть уникальными
//   //   final query2 = await db.query(_tableCategories,
//   //       where: '"$_name" = ? and "$_colorHex" = ?',
//   //       whereArgs: [data.name, data.colorHex]);
//   //
//   //   if (query2.isNotEmpty){
//   //     if (query2[0].isNotEmpty){///только первое вхождение
//   //       final id = query2[0][_id];
//   //       if (id != null && id is int){
//   //         return id;
//   //       }
//   //     }
//   //   }
//   //
//   //   return db.insert(
//   //     _tableCategories,
//   //     data.toJson(),
//   //     conflictAlgorithm: conflictAlgorithm,
//   //   );
//   // }
//   //
//   // @override
//   // Future<int> updateCategory(CategoryExpenses data, {ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.ignore}) async {
//   //   final db = await database;
//   //
//   //   ///имя должно быть уникальное
//   //   final query = await db.query(_tableCategories,
//   //       where: '"$_name" = ?',
//   //       whereArgs: [data.name]);
//   //
//   //   if (query.isNotEmpty){
//   //     if (query[0].isNotEmpty){///только первое вхождение
//   //       final id = query[0][_id];
//   //       if (id != null && id is int){
//   //         if(id != data.id) {
//   //           return -1;
//   //         }
//   //       }
//   //     }
//   //   }
//   //
//   //   ///имя и цвет тоже должны быть уникальными
//   //   final query2 = await db.query(_tableCategories,
//   //       where: '"$_name" = ? and "$_colorHex" = ?',
//   //       whereArgs: [data.name, data.colorHex]);
//   //
//   //   if (query2.isNotEmpty){
//   //     if (query2[0].isNotEmpty){///только первое вхождение
//   //       final id = query2[0][_id];
//   //       if (id != null && id is int){
//   //         return -1;
//   //       }
//   //     }
//   //   }
//   //
//   //   return db.update(
//   //       _tableCategories,
//   //       data.toJson(),
//   //       where: '"$_id" = ?',
//   //       whereArgs: [data.id],
//   //       conflictAlgorithm: conflictAlgorithm,
//   //   );
//   // }
//   //
//   // @override
//   // Future<bool> checkCategory(CategoryExpenses data) async {
//   //   final db = await database;
//   //
//   //   ///имя должно быть уникальное
//   //   final query = await db.query(_tableCategories,
//   //       where: '"$_name" = ?',
//   //       whereArgs: [data.name]);
//   //
//   //   if (query.isNotEmpty){
//   //     if (query[0].isNotEmpty){///только первое вхождение
//   //       final id = query[0][_id];
//   //       if (id != null && id is int){
//   //         if(id != data.id) {
//   //           return false;
//   //         }
//   //       }
//   //     }
//   //   }
//   //
//   //   ///имя и цвет тоже должны быть уникальными
//   //   final query2 = await db.query(_tableCategories,
//   //       where: '"$_name" = ? and "$_colorHex" = ?',
//   //       whereArgs: [data.name, data.colorHex]);
//   //
//   //   if (query2.isNotEmpty){
//   //     if (query2[0].isNotEmpty){///только первое вхождение
//   //       final id = query2[0][_id];
//   //       if (id != null && id is int){
//   //         if(id != data.id) {
//   //           return false;
//   //         }
//   //       }
//   //     }
//   //   }
//   //   return true;
//   // }
//   //
//   // @override
//   // Future<int?> insertExpenses(DayExpense data,{
//   //   ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.ignore
//   // }) async {
//   //   final db = await database;
//   //
//   //   return db.insert(
//   //     _tableExpenses,
//   //     data.toJson(),
//   //     conflictAlgorithm: conflictAlgorithm,
//   //   );
//   // }
//   //
//   // @override
//   // Future<int> deleteIdExpenses(int id) async {
//   //   final db = await database;
//   //   return db.delete(
//   //       _tableExpenses,
//   //       where: '"$_id" = ?',
//   //       whereArgs: [id]
//   //   );
//   // }
//   //
//   // @override
//   // Future<MonthlyExpensesModel?> getAllByIdMonthCategory(int idMonth, int idCategory) async {
//   //   final db = await database;
//   //
//   //   final query = await db.query(_tableExpenses,
//   //       where: '"$_idMonth" = ? and "$_idCategory" = ?',
//   //       whereArgs: [idMonth, idCategory],
//   //       orderBy: _sum
//   //   );
//   //
//   //   final completeExpenses = <DayExpense>{};
//   //
//   //   if (query.isNotEmpty){
//   //     for(final elem in query){
//   //       final dayExpense  =DayExpense.fromJson(elem);
//   //       completeExpenses.add(dayExpense);
//   //     }
//   //   }
//   //
//   //   return MonthlyExpensesModel(
//   //     completeExpenses: completeExpenses
//   //   );
//   // }
//   //
//   // @override
//   // Future<BigInt?> getTotalInMonthCategory(int idMonth, int idCategory) async {
//   //   final db = await database;
//   //
//   //   final query = await db.query(_tableExpenses,
//   //       where: '"$_idMonth" = ? and "$_idCategory" = ?',
//   //       whereArgs: [idMonth, idCategory]);
//   //
//   //   var res = BigInt.from(0);
//   //
//   //   if (query.isNotEmpty){
//   //     for(final elem in query){
//   //       final sum = elem[_sum] as String?;
//   //       res += BigInt.parse(sum??'0');
//   //     }
//   //   }
//   //
//   //   return res;
//   // }
//   //
//   // @override
//   // Future<int> deleteWithCategory(int idCategory) async {
//   //   final db = await database;
//   //   return db.delete(
//   //       _tableExpenses,
//   //       where: '"$_idCategory" = ?',
//   //       whereArgs: [idCategory]
//   //   );
//   // }
//   //
//   // @override
//   // Future<Map<int, BigInt>?> readWithMonth(int idMonth) async {
//   //   final db = await database;
//   //
//   //   final query = await db.query(_tableExpenses,
//   //     where: '"$_idMonth" = ?',
//   //     whereArgs: [idMonth],
//   //     orderBy: _idCategory,
//   //   );
//   //
//   //   final totalExpenses = <int, BigInt>{};
//   //
//   //   if (query.isNotEmpty){
//   //     int? idCategory;
//   //     var sum = BigInt.zero;
//   //     for(final elem in query){
//   //       final dayExpense  =DayExpense.fromJson(elem);
//   //       Logger.print('dayExpense:$dayExpense)}');
//   //       if(idCategory != dayExpense.idCategory) {
//   //         if(idCategory != null){
//   //           totalExpenses.putIfAbsent(idCategory, () => sum);
//   //           sum = BigInt.zero;
//   //         }
//   //         idCategory = dayExpense.idCategory;
//   //       }
//   //
//   //       sum += dayExpense.sum;
//   //     }
//   //     if(idCategory != null){
//   //       totalExpenses.putIfAbsent(idCategory, () => sum);
//   //     }
//   //
//   //   }
//   //   Logger.print('totalExpenses:$totalExpenses)}');
//   //   return totalExpenses;
//   //
//   // }
//   //
//   // @override
//   // Future<int> updateExpenses(DayExpense data, {
//   //   ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.ignore
//   // }) async {
//   //   final db = await database;
//   //   return db.update(
//   //     _tableExpenses,
//   //     data.toJson(),
//   //     where: '"$_id" = ?',
//   //     whereArgs: [data.id],
//   //     conflictAlgorithm: conflictAlgorithm,
//   //   );
//   // }
//
// }
