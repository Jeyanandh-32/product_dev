// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [DatabaseSchema].
extension DatabaseSchemaSchema on Database<DatabaseSchema> {
  static final _$tables = [
    _$MerchantRow._$table,
    _$StoreRow._$table,
    _$CategoryRow._$table,
    _$CounterRow._$table,
    _$ProductRow._$table,
    _$StockRow._$table,
    _$TerminalRow._$table,
  ];

  Table<MerchantRow> get merchants =>
      $ForGeneratedCode.declareTable(this, _$MerchantRow._$table);

  Table<StoreRow> get stores =>
      $ForGeneratedCode.declareTable(this, _$StoreRow._$table);

  Table<CategoryRow> get categories =>
      $ForGeneratedCode.declareTable(this, _$CategoryRow._$table);

  Table<CounterRow> get counters =>
      $ForGeneratedCode.declareTable(this, _$CounterRow._$table);

  Table<ProductRow> get products =>
      $ForGeneratedCode.declareTable(this, _$ProductRow._$table);

  Table<StockRow> get stocks =>
      $ForGeneratedCode.declareTable(this, _$StockRow._$table);

  Table<TerminalRow> get terminals =>
      $ForGeneratedCode.declareTable(this, _$TerminalRow._$table);

  /// Create tables defined in [DatabaseSchema].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [DatabaseSchema]. In production it's often better to
  /// use [createDatabaseSchemaTables] and manage migrations using
  /// external tools.
  ///
  /// This method is mostly useful for testing.
  ///
  /// > [!WARNING]
  /// > If the database is **not empty** behavior is undefined, most
  /// > likely this operation will fail.
  Future<void> createTables() async =>
      $ForGeneratedCode.createTables(context: this, tables: _$tables);
}

/// Get SQL [DDL statements][1] for tables defined in [DatabaseSchema].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [DatabaseSchema]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createDatabaseSchemaTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: DatabaseSchemaSchema._$tables);

final class _$MerchantRow extends MerchantRow {
  _$MerchantRow._(
    this.id,
    this.name,
    this.businessName,
    this.whatsappNumber,
    this.email,
    this.passwordHash,
    this.createdAt,
    this.updatedAt,
  );

  @override
  final String id;

  @override
  final String name;

  @override
  final String businessName;

  @override
  final String whatsappNumber;

  @override
  final String email;

  @override
  final String passwordHash;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'merchants',
    columns: <String>[
      'id',
      'name',
      'business_name',
      'whatsapp_number',
      'email',
      'password_hash',
      'created_at',
      'updated_at',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 'gen_random_uuid()'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['whatsapp_number'],
      ['email'],
    ],
    foreignKeys: [],
    readRow: _$MerchantRow._$fromDatabase,
  );

  static MerchantRow? _$fromDatabase(RowReader row) {
    final id = row.readString();
    final name = row.readString();
    final businessName = row.readString();
    final whatsappNumber = row.readString();
    final email = row.readString();
    final passwordHash = row.readString();
    final createdAt = row.readDateTime();
    final updatedAt = row.readDateTime();
    if (id == null &&
        name == null &&
        businessName == null &&
        whatsappNumber == null &&
        email == null &&
        passwordHash == null &&
        createdAt == null &&
        updatedAt == null) {
      return null;
    }
    return _$MerchantRow._(
      id!,
      name!,
      businessName!,
      whatsappNumber!,
      email!,
      passwordHash!,
      createdAt!,
      updatedAt!,
    );
  }

  @override
  String toString() =>
      'MerchantRow(id: "$id", name: "$name", businessName: "$businessName", whatsappNumber: "$whatsappNumber", email: "$email", passwordHash: "$passwordHash", createdAt: "$createdAt", updatedAt: "$updatedAt")';
}

/// Extension methods for table defined in [MerchantRow].
extension TableMerchantRowExt on Table<MerchantRow> {
  /// Insert row into the `merchants` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<MerchantRow> insert({
    Expr<String>? id,
    required Expr<String> name,
    required Expr<String> businessName,
    required Expr<String> whatsappNumber,
    required Expr<String> email,
    required Expr<String> passwordHash,
    Expr<DateTime>? createdAt,
    Expr<DateTime>? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id,
      name,
      businessName,
      whatsappNumber,
      email,
      passwordHash,
      createdAt,
      updatedAt,
    ],
  );

  /// Insert row into the `merchants` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<MerchantRow> insertValue({
    String? id,
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required String passwordHash,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      name.asExpr,
      businessName.asExpr,
      whatsappNumber.asExpr,
      email.asExpr,
      passwordHash.asExpr,
      createdAt?.asExpr,
      updatedAt?.asExpr,
    ],
  );

  /// Bulk insert rows into the `merchants` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<MerchantRow> insertValuesMapped<T>(
    Iterable<T> rows, {
    String Function(T row)? id,
    required String Function(T row) name,
    required String Function(T row) businessName,
    required String Function(T row) whatsappNumber,
    required String Function(T row) email,
    required String Function(T row) passwordHash,
    DateTime Function(T row)? createdAt,
    DateTime Function(T row)? updatedAt,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      id,
      name,
      businessName,
      whatsappNumber,
      email,
      passwordHash,
      createdAt,
      updatedAt,
    ],
  );

  /// Delete a single row from the `merchants` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<MerchantRow> delete(String id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$MerchantRow._$table);
}

/// Extension methods for building queries against the `merchants` table.
extension QueryMerchantRowExt on Query<(Expr<MerchantRow>,)> {
  /// Lookup a single row in `merchants` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MerchantRow>,)> byKey(String id) =>
      where((merchantRow) => merchantRow.id.equalsValue(id)).first;

  /// Update all rows in the `merchants` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<MerchantRow> update(
    UpdateSet<MerchantRow> Function(
      Expr<MerchantRow> merchantRow,
      UpdateSet<MerchantRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> businessName,
        Expr<String> whatsappNumber,
        Expr<String> email,
        Expr<String> passwordHash,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<MerchantRow>(
    this,
    _$MerchantRow._$table,
    (merchantRow) => updateBuilder(
      merchantRow,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? businessName,
        Expr<String>? whatsappNumber,
        Expr<String>? email,
        Expr<String>? passwordHash,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<MerchantRow>([
        id,
        name,
        businessName,
        whatsappNumber,
        email,
        passwordHash,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Lookup a single row in `merchants` table using the
  /// `whatsappNumber` field
  ///
  /// We know that lookup by the `whatsappNumber` field returns
  /// at-most one row because the [Unique] annotation in [MerchantRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MerchantRow>,)> byWhatsappNumber(String whatsappNumber) =>
      where(
        (merchantRow) => merchantRow.whatsappNumber.equalsValue(whatsappNumber),
      ).first;

  /// Lookup a single row in `merchants` table using the
  /// `email` field
  ///
  /// We know that lookup by the `email` field returns
  /// at-most one row because the [Unique] annotation in [MerchantRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<MerchantRow>,)> byEmail(String email) =>
      where((merchantRow) => merchantRow.email.equalsValue(email)).first;

  /// Delete all rows in the `merchants` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<MerchantRow> delete() =>
      $ForGeneratedCode.delete(this, _$MerchantRow._$table);
}

/// Extension methods for building point queries against the `merchants` table.
extension QuerySingleMerchantRowExt on QuerySingle<(Expr<MerchantRow>,)> {
  /// Update the row (if any) in the `merchants` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<MerchantRow> update(
    UpdateSet<MerchantRow> Function(
      Expr<MerchantRow> merchantRow,
      UpdateSet<MerchantRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> businessName,
        Expr<String> whatsappNumber,
        Expr<String> email,
        Expr<String> passwordHash,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<MerchantRow>(
    this,
    _$MerchantRow._$table,
    (merchantRow) => updateBuilder(
      merchantRow,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? businessName,
        Expr<String>? whatsappNumber,
        Expr<String>? email,
        Expr<String>? passwordHash,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<MerchantRow>([
        id,
        name,
        businessName,
        whatsappNumber,
        email,
        passwordHash,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Delete the row (if any) in the `merchants` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<MerchantRow> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$MerchantRow._$table);
}

/// Extension methods for expressions on a row in the `merchants` table.
extension ExpressionMerchantRowExt on Expr<MerchantRow> {
  Expr<String> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get businessName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get whatsappNumber =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String> get email =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<String> get passwordHash =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.text);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  Expr<DateTime> get updatedAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableMerchantRowExt on Expr<MerchantRow?> {
  Expr<String?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get businessName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get whatsappNumber =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String?> get email =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<String?> get passwordHash =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.text);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get updatedAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<MerchantRow>` conflict targets for use with `.onConflict`.
enum MerchantRowConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `whatsappNumber` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `whatsappNumber`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  whatsappNumber(['whatsapp_number']),

  /// `email` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `email`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  email(['email']);

  const MerchantRowConflict(this._fields);

  final List<String> _fields;
}

extension InsertMerchantRowExt on Insert<MerchantRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((merchantRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<MerchantRow> onConflict(MerchantRowConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictMerchantRowExt on InsertOnConflict<MerchantRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `merchantRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<MerchantRow> update(
    UpdateSet<MerchantRow> Function(
      Expr<MerchantRow> merchantRow,
      Expr<MerchantRow> excluded,
      UpdateSet<MerchantRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> businessName,
        Expr<String> whatsappNumber,
        Expr<String> email,
        Expr<String> passwordHash,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<MerchantRow>(
    this,
    (merchantRow, excluded) => updateBuilder(
      merchantRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? businessName,
        Expr<String>? whatsappNumber,
        Expr<String>? email,
        Expr<String>? passwordHash,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<MerchantRow>([
        id,
        name,
        businessName,
        whatsappNumber,
        email,
        passwordHash,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

extension InsertSingleMerchantRowExt on InsertSingle<MerchantRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((merchantRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<MerchantRow> onConflict(MerchantRowConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleMerchantRowExt
    on InsertOnConflictSingle<MerchantRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `merchantRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<MerchantRow> update(
    UpdateSet<MerchantRow> Function(
      Expr<MerchantRow> merchantRow,
      Expr<MerchantRow> excluded,
      UpdateSet<MerchantRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> businessName,
        Expr<String> whatsappNumber,
        Expr<String> email,
        Expr<String> passwordHash,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<MerchantRow>(
    this,
    (merchantRow, excluded) => updateBuilder(
      merchantRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? businessName,
        Expr<String>? whatsappNumber,
        Expr<String>? email,
        Expr<String>? passwordHash,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<MerchantRow>([
        id,
        name,
        businessName,
        whatsappNumber,
        email,
        passwordHash,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

final class _$StoreRow extends StoreRow {
  _$StoreRow._(
    this.id,
    this.merchantId,
    this.name,
    this.storeType,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  );

  @override
  final String id;

  @override
  final String merchantId;

  @override
  final String name;

  @override
  final String? storeType;

  @override
  final bool isActive;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'stores',
    columns: <String>[
      'id',
      'merchant_id',
      'name',
      'store_type',
      'is_active',
      'created_at',
      'updated_at',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 'gen_random_uuid()'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.boolean,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: true),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['merchant_id', 'name'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['merchant_id'],
        referencedTable: 'merchants',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$StoreRow._$fromDatabase,
  );

  static StoreRow? _$fromDatabase(RowReader row) {
    final id = row.readString();
    final merchantId = row.readString();
    final name = row.readString();
    final storeType = row.readString();
    final isActive = row.readBool();
    final createdAt = row.readDateTime();
    final updatedAt = row.readDateTime();
    if (id == null &&
        merchantId == null &&
        name == null &&
        storeType == null &&
        isActive == null &&
        createdAt == null &&
        updatedAt == null) {
      return null;
    }
    return _$StoreRow._(
      id!,
      merchantId!,
      name!,
      storeType,
      isActive!,
      createdAt!,
      updatedAt!,
    );
  }

  @override
  String toString() =>
      'StoreRow(id: "$id", merchantId: "$merchantId", name: "$name", storeType: "$storeType", isActive: "$isActive", createdAt: "$createdAt", updatedAt: "$updatedAt")';
}

/// Extension methods for table defined in [StoreRow].
extension TableStoreRowExt on Table<StoreRow> {
  /// Insert row into the `stores` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<StoreRow> insert({
    Expr<String>? id,
    required Expr<String> merchantId,
    required Expr<String> name,
    Expr<String?>? storeType,
    Expr<bool>? isActive,
    Expr<DateTime>? createdAt,
    Expr<DateTime>? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, merchantId, name, storeType, isActive, createdAt, updatedAt],
  );

  /// Insert row into the `stores` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<StoreRow> insertValue({
    String? id,
    required String merchantId,
    required String name,
    String? storeType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      merchantId.asExpr,
      name.asExpr,
      storeType.asExpr,
      isActive?.asExpr,
      createdAt?.asExpr,
      updatedAt?.asExpr,
    ],
  );

  /// Bulk insert rows into the `stores` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<StoreRow> insertValuesMapped<T>(
    Iterable<T> rows, {
    String Function(T row)? id,
    required String Function(T row) merchantId,
    required String Function(T row) name,
    String? Function(T row)? storeType,
    bool Function(T row)? isActive,
    DateTime Function(T row)? createdAt,
    DateTime Function(T row)? updatedAt,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, merchantId, name, storeType, isActive, createdAt, updatedAt],
  );

  /// Delete a single row from the `stores` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<StoreRow> delete(String id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$StoreRow._$table);
}

/// Extension methods for building queries against the `stores` table.
extension QueryStoreRowExt on Query<(Expr<StoreRow>,)> {
  /// Lookup a single row in `stores` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<StoreRow>,)> byKey(String id) =>
      where((storeRow) => storeRow.id.equalsValue(id)).first;

  /// Update all rows in the `stores` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<StoreRow> update(
    UpdateSet<StoreRow> Function(
      Expr<StoreRow> storeRow,
      UpdateSet<StoreRow> Function({
        Expr<String> id,
        Expr<String> merchantId,
        Expr<String> name,
        Expr<String?> storeType,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<StoreRow>(
    this,
    _$StoreRow._$table,
    (storeRow) => updateBuilder(
      storeRow,
      ({
        Expr<String>? id,
        Expr<String>? merchantId,
        Expr<String>? name,
        Expr<String?>? storeType,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<StoreRow>([
        id,
        merchantId,
        name,
        storeType,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Lookup a single row in `stores` table using the
  /// `merchantId`, `name` fields
  ///
  /// We know that lookup by the `merchantId`, `name` fields returns
  /// at-most one row because the [Unique] annotation in [StoreRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<StoreRow>,)> byUniqueMerchantStoreName(
    String merchantId,
    String name,
  ) => where(
    (storeRow) =>
        storeRow.merchantId.equalsValue(merchantId) &
        storeRow.name.equalsValue(name),
  ).first;

  /// Delete all rows in the `stores` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<StoreRow> delete() =>
      $ForGeneratedCode.delete(this, _$StoreRow._$table);
}

/// Extension methods for building point queries against the `stores` table.
extension QuerySingleStoreRowExt on QuerySingle<(Expr<StoreRow>,)> {
  /// Update the row (if any) in the `stores` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<StoreRow> update(
    UpdateSet<StoreRow> Function(
      Expr<StoreRow> storeRow,
      UpdateSet<StoreRow> Function({
        Expr<String> id,
        Expr<String> merchantId,
        Expr<String> name,
        Expr<String?> storeType,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<StoreRow>(
    this,
    _$StoreRow._$table,
    (storeRow) => updateBuilder(
      storeRow,
      ({
        Expr<String>? id,
        Expr<String>? merchantId,
        Expr<String>? name,
        Expr<String?>? storeType,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<StoreRow>([
        id,
        merchantId,
        name,
        storeType,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Delete the row (if any) in the `stores` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<StoreRow> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$StoreRow._$table);
}

/// Extension methods for expressions on a row in the `stores` table.
extension ExpressionStoreRowExt on Expr<StoreRow> {
  Expr<String> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get merchantId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get storeType =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<bool> get isActive =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.boolean);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.dateTime);

  Expr<DateTime> get updatedAt =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableStoreRowExt on Expr<StoreRow?> {
  Expr<String?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get merchantId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get storeType =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<bool?> get isActive =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.boolean);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get updatedAt =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<StoreRow>` conflict targets for use with `.onConflict`.
enum StoreRowConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `merchantId`, `name` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `merchantId`, `name`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  uniqueMerchantStoreName(['merchant_id', 'name']);

  const StoreRowConflict(this._fields);

  final List<String> _fields;
}

extension InsertStoreRowExt on Insert<StoreRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((storeRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<StoreRow> onConflict(StoreRowConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictStoreRowExt on InsertOnConflict<StoreRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `storeRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<StoreRow> update(
    UpdateSet<StoreRow> Function(
      Expr<StoreRow> storeRow,
      Expr<StoreRow> excluded,
      UpdateSet<StoreRow> Function({
        Expr<String> id,
        Expr<String> merchantId,
        Expr<String> name,
        Expr<String?> storeType,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<StoreRow>(
    this,
    (storeRow, excluded) => updateBuilder(
      storeRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? merchantId,
        Expr<String>? name,
        Expr<String?>? storeType,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<StoreRow>([
        id,
        merchantId,
        name,
        storeType,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

extension InsertSingleStoreRowExt on InsertSingle<StoreRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((storeRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<StoreRow> onConflict(StoreRowConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleStoreRowExt
    on InsertOnConflictSingle<StoreRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `storeRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<StoreRow> update(
    UpdateSet<StoreRow> Function(
      Expr<StoreRow> storeRow,
      Expr<StoreRow> excluded,
      UpdateSet<StoreRow> Function({
        Expr<String> id,
        Expr<String> merchantId,
        Expr<String> name,
        Expr<String?> storeType,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<StoreRow>(
    this,
    (storeRow, excluded) => updateBuilder(
      storeRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? merchantId,
        Expr<String>? name,
        Expr<String?>? storeType,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<StoreRow>([
        id,
        merchantId,
        name,
        storeType,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

final class _$CategoryRow extends CategoryRow {
  _$CategoryRow._(
    this.id,
    this.name,
    this.merchantId,
    this.storeId,
    this.isActive,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  );

  @override
  final String id;

  @override
  final String name;

  @override
  final String merchantId;

  @override
  final String storeId;

  @override
  final bool isActive;

  @override
  final String? description;

  @override
  final String? imageUrl;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'categories',
    columns: <String>[
      'id',
      'name',
      'merchant_id',
      'store_id',
      'is_active',
      'description',
      'image_url',
      'created_at',
      'updated_at',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 'gen_random_uuid()'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.boolean,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: true),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['store_id', 'name'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['merchant_id'],
        referencedTable: 'merchants',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['store_id'],
        referencedTable: 'stores',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$CategoryRow._$fromDatabase,
  );

  static CategoryRow? _$fromDatabase(RowReader row) {
    final id = row.readString();
    final name = row.readString();
    final merchantId = row.readString();
    final storeId = row.readString();
    final isActive = row.readBool();
    final description = row.readString();
    final imageUrl = row.readString();
    final createdAt = row.readDateTime();
    final updatedAt = row.readDateTime();
    if (id == null &&
        name == null &&
        merchantId == null &&
        storeId == null &&
        isActive == null &&
        description == null &&
        imageUrl == null &&
        createdAt == null &&
        updatedAt == null) {
      return null;
    }
    return _$CategoryRow._(
      id!,
      name!,
      merchantId!,
      storeId!,
      isActive!,
      description,
      imageUrl,
      createdAt!,
      updatedAt!,
    );
  }

  @override
  String toString() =>
      'CategoryRow(id: "$id", name: "$name", merchantId: "$merchantId", storeId: "$storeId", isActive: "$isActive", description: "$description", imageUrl: "$imageUrl", createdAt: "$createdAt", updatedAt: "$updatedAt")';
}

/// Extension methods for table defined in [CategoryRow].
extension TableCategoryRowExt on Table<CategoryRow> {
  /// Insert row into the `categories` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CategoryRow> insert({
    Expr<String>? id,
    required Expr<String> name,
    required Expr<String> merchantId,
    required Expr<String> storeId,
    Expr<bool>? isActive,
    Expr<String?>? description,
    Expr<String?>? imageUrl,
    Expr<DateTime>? createdAt,
    Expr<DateTime>? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id,
      name,
      merchantId,
      storeId,
      isActive,
      description,
      imageUrl,
      createdAt,
      updatedAt,
    ],
  );

  /// Insert row into the `categories` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CategoryRow> insertValue({
    String? id,
    required String name,
    required String merchantId,
    required String storeId,
    bool? isActive,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      name.asExpr,
      merchantId.asExpr,
      storeId.asExpr,
      isActive?.asExpr,
      description.asExpr,
      imageUrl.asExpr,
      createdAt?.asExpr,
      updatedAt?.asExpr,
    ],
  );

  /// Bulk insert rows into the `categories` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<CategoryRow> insertValuesMapped<T>(
    Iterable<T> rows, {
    String Function(T row)? id,
    required String Function(T row) name,
    required String Function(T row) merchantId,
    required String Function(T row) storeId,
    bool Function(T row)? isActive,
    String? Function(T row)? description,
    String? Function(T row)? imageUrl,
    DateTime Function(T row)? createdAt,
    DateTime Function(T row)? updatedAt,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      id,
      name,
      merchantId,
      storeId,
      isActive,
      description,
      imageUrl,
      createdAt,
      updatedAt,
    ],
  );

  /// Delete a single row from the `categories` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<CategoryRow> delete(String id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$CategoryRow._$table);
}

/// Extension methods for building queries against the `categories` table.
extension QueryCategoryRowExt on Query<(Expr<CategoryRow>,)> {
  /// Lookup a single row in `categories` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CategoryRow>,)> byKey(String id) =>
      where((categoryRow) => categoryRow.id.equalsValue(id)).first;

  /// Update all rows in the `categories` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<CategoryRow> update(
    UpdateSet<CategoryRow> Function(
      Expr<CategoryRow> categoryRow,
      UpdateSet<CategoryRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<bool> isActive,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<CategoryRow>(
    this,
    _$CategoryRow._$table,
    (categoryRow) => updateBuilder(
      categoryRow,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<bool>? isActive,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<CategoryRow>([
        id,
        name,
        merchantId,
        storeId,
        isActive,
        description,
        imageUrl,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Lookup a single row in `categories` table using the
  /// `storeId`, `name` fields
  ///
  /// We know that lookup by the `storeId`, `name` fields returns
  /// at-most one row because the [Unique] annotation in [CategoryRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CategoryRow>,)> byUniqueStoreCategoryName(
    String storeId,
    String name,
  ) => where(
    (categoryRow) =>
        categoryRow.storeId.equalsValue(storeId) &
        categoryRow.name.equalsValue(name),
  ).first;

  /// Delete all rows in the `categories` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<CategoryRow> delete() =>
      $ForGeneratedCode.delete(this, _$CategoryRow._$table);
}

/// Extension methods for building point queries against the `categories` table.
extension QuerySingleCategoryRowExt on QuerySingle<(Expr<CategoryRow>,)> {
  /// Update the row (if any) in the `categories` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<CategoryRow> update(
    UpdateSet<CategoryRow> Function(
      Expr<CategoryRow> categoryRow,
      UpdateSet<CategoryRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<bool> isActive,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<CategoryRow>(
    this,
    _$CategoryRow._$table,
    (categoryRow) => updateBuilder(
      categoryRow,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<bool>? isActive,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<CategoryRow>([
        id,
        name,
        merchantId,
        storeId,
        isActive,
        description,
        imageUrl,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Delete the row (if any) in the `categories` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<CategoryRow> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$CategoryRow._$table);
}

/// Extension methods for expressions on a row in the `categories` table.
extension ExpressionCategoryRowExt on Expr<CategoryRow> {
  Expr<String> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get merchantId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get storeId =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<bool> get isActive =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.boolean);

  Expr<String?> get description =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.text);

  Expr<String?> get imageUrl =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.text);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);

  Expr<DateTime> get updatedAt =>
      $ForGeneratedCode.field(this, 8, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableCategoryRowExt on Expr<CategoryRow?> {
  Expr<String?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get merchantId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get storeId =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<bool?> get isActive =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.boolean);

  Expr<String?> get description =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.text);

  Expr<String?> get imageUrl =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.text);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get updatedAt =>
      $ForGeneratedCode.field(this, 8, $ForGeneratedCode.dateTime);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<CategoryRow>` conflict targets for use with `.onConflict`.
enum CategoryRowConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `storeId`, `name` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `storeId`, `name`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  uniqueStoreCategoryName(['store_id', 'name']);

  const CategoryRowConflict(this._fields);

  final List<String> _fields;
}

extension InsertCategoryRowExt on Insert<CategoryRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((categoryRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<CategoryRow> onConflict(CategoryRowConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictCategoryRowExt on InsertOnConflict<CategoryRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `categoryRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<CategoryRow> update(
    UpdateSet<CategoryRow> Function(
      Expr<CategoryRow> categoryRow,
      Expr<CategoryRow> excluded,
      UpdateSet<CategoryRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<bool> isActive,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<CategoryRow>(
    this,
    (categoryRow, excluded) => updateBuilder(
      categoryRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<bool>? isActive,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<CategoryRow>([
        id,
        name,
        merchantId,
        storeId,
        isActive,
        description,
        imageUrl,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

extension InsertSingleCategoryRowExt on InsertSingle<CategoryRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((categoryRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<CategoryRow> onConflict(CategoryRowConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleCategoryRowExt
    on InsertOnConflictSingle<CategoryRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `categoryRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<CategoryRow> update(
    UpdateSet<CategoryRow> Function(
      Expr<CategoryRow> categoryRow,
      Expr<CategoryRow> excluded,
      UpdateSet<CategoryRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<bool> isActive,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<CategoryRow>(
    this,
    (categoryRow, excluded) => updateBuilder(
      categoryRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<bool>? isActive,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<CategoryRow>([
        id,
        name,
        merchantId,
        storeId,
        isActive,
        description,
        imageUrl,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

final class _$CounterRow extends CounterRow {
  _$CounterRow._(
    this.id,
    this.name,
    this.merchantId,
    this.storeId,
    this.isActive,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  );

  @override
  final String id;

  @override
  final String name;

  @override
  final String merchantId;

  @override
  final String storeId;

  @override
  final bool isActive;

  @override
  final String? description;

  @override
  final String? imageUrl;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'counters',
    columns: <String>[
      'id',
      'name',
      'merchant_id',
      'store_id',
      'is_active',
      'description',
      'image_url',
      'created_at',
      'updated_at',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 'gen_random_uuid()'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.boolean,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: true),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['store_id', 'name'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['merchant_id'],
        referencedTable: 'merchants',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['store_id'],
        referencedTable: 'stores',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$CounterRow._$fromDatabase,
  );

  static CounterRow? _$fromDatabase(RowReader row) {
    final id = row.readString();
    final name = row.readString();
    final merchantId = row.readString();
    final storeId = row.readString();
    final isActive = row.readBool();
    final description = row.readString();
    final imageUrl = row.readString();
    final createdAt = row.readDateTime();
    final updatedAt = row.readDateTime();
    if (id == null &&
        name == null &&
        merchantId == null &&
        storeId == null &&
        isActive == null &&
        description == null &&
        imageUrl == null &&
        createdAt == null &&
        updatedAt == null) {
      return null;
    }
    return _$CounterRow._(
      id!,
      name!,
      merchantId!,
      storeId!,
      isActive!,
      description,
      imageUrl,
      createdAt!,
      updatedAt!,
    );
  }

  @override
  String toString() =>
      'CounterRow(id: "$id", name: "$name", merchantId: "$merchantId", storeId: "$storeId", isActive: "$isActive", description: "$description", imageUrl: "$imageUrl", createdAt: "$createdAt", updatedAt: "$updatedAt")';
}

/// Extension methods for table defined in [CounterRow].
extension TableCounterRowExt on Table<CounterRow> {
  /// Insert row into the `counters` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CounterRow> insert({
    Expr<String>? id,
    required Expr<String> name,
    required Expr<String> merchantId,
    required Expr<String> storeId,
    Expr<bool>? isActive,
    Expr<String?>? description,
    Expr<String?>? imageUrl,
    Expr<DateTime>? createdAt,
    Expr<DateTime>? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id,
      name,
      merchantId,
      storeId,
      isActive,
      description,
      imageUrl,
      createdAt,
      updatedAt,
    ],
  );

  /// Insert row into the `counters` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<CounterRow> insertValue({
    String? id,
    required String name,
    required String merchantId,
    required String storeId,
    bool? isActive,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      name.asExpr,
      merchantId.asExpr,
      storeId.asExpr,
      isActive?.asExpr,
      description.asExpr,
      imageUrl.asExpr,
      createdAt?.asExpr,
      updatedAt?.asExpr,
    ],
  );

  /// Bulk insert rows into the `counters` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<CounterRow> insertValuesMapped<T>(
    Iterable<T> rows, {
    String Function(T row)? id,
    required String Function(T row) name,
    required String Function(T row) merchantId,
    required String Function(T row) storeId,
    bool Function(T row)? isActive,
    String? Function(T row)? description,
    String? Function(T row)? imageUrl,
    DateTime Function(T row)? createdAt,
    DateTime Function(T row)? updatedAt,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      id,
      name,
      merchantId,
      storeId,
      isActive,
      description,
      imageUrl,
      createdAt,
      updatedAt,
    ],
  );

  /// Delete a single row from the `counters` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<CounterRow> delete(String id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$CounterRow._$table);
}

/// Extension methods for building queries against the `counters` table.
extension QueryCounterRowExt on Query<(Expr<CounterRow>,)> {
  /// Lookup a single row in `counters` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CounterRow>,)> byKey(String id) =>
      where((counterRow) => counterRow.id.equalsValue(id)).first;

  /// Update all rows in the `counters` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<CounterRow> update(
    UpdateSet<CounterRow> Function(
      Expr<CounterRow> counterRow,
      UpdateSet<CounterRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<bool> isActive,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<CounterRow>(
    this,
    _$CounterRow._$table,
    (counterRow) => updateBuilder(
      counterRow,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<bool>? isActive,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<CounterRow>([
        id,
        name,
        merchantId,
        storeId,
        isActive,
        description,
        imageUrl,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Lookup a single row in `counters` table using the
  /// `storeId`, `name` fields
  ///
  /// We know that lookup by the `storeId`, `name` fields returns
  /// at-most one row because the [Unique] annotation in [CounterRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<CounterRow>,)> byUniqueStoreCounterName(
    String storeId,
    String name,
  ) => where(
    (counterRow) =>
        counterRow.storeId.equalsValue(storeId) &
        counterRow.name.equalsValue(name),
  ).first;

  /// Delete all rows in the `counters` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<CounterRow> delete() =>
      $ForGeneratedCode.delete(this, _$CounterRow._$table);
}

/// Extension methods for building point queries against the `counters` table.
extension QuerySingleCounterRowExt on QuerySingle<(Expr<CounterRow>,)> {
  /// Update the row (if any) in the `counters` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<CounterRow> update(
    UpdateSet<CounterRow> Function(
      Expr<CounterRow> counterRow,
      UpdateSet<CounterRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<bool> isActive,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<CounterRow>(
    this,
    _$CounterRow._$table,
    (counterRow) => updateBuilder(
      counterRow,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<bool>? isActive,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<CounterRow>([
        id,
        name,
        merchantId,
        storeId,
        isActive,
        description,
        imageUrl,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Delete the row (if any) in the `counters` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<CounterRow> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$CounterRow._$table);
}

/// Extension methods for expressions on a row in the `counters` table.
extension ExpressionCounterRowExt on Expr<CounterRow> {
  Expr<String> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get merchantId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get storeId =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<bool> get isActive =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.boolean);

  Expr<String?> get description =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.text);

  Expr<String?> get imageUrl =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.text);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);

  Expr<DateTime> get updatedAt =>
      $ForGeneratedCode.field(this, 8, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableCounterRowExt on Expr<CounterRow?> {
  Expr<String?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get merchantId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get storeId =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<bool?> get isActive =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.boolean);

  Expr<String?> get description =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.text);

  Expr<String?> get imageUrl =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.text);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get updatedAt =>
      $ForGeneratedCode.field(this, 8, $ForGeneratedCode.dateTime);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<CounterRow>` conflict targets for use with `.onConflict`.
enum CounterRowConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `storeId`, `name` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `storeId`, `name`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  uniqueStoreCounterName(['store_id', 'name']);

  const CounterRowConflict(this._fields);

  final List<String> _fields;
}

extension InsertCounterRowExt on Insert<CounterRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((counterRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<CounterRow> onConflict(CounterRowConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictCounterRowExt on InsertOnConflict<CounterRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `counterRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<CounterRow> update(
    UpdateSet<CounterRow> Function(
      Expr<CounterRow> counterRow,
      Expr<CounterRow> excluded,
      UpdateSet<CounterRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<bool> isActive,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<CounterRow>(
    this,
    (counterRow, excluded) => updateBuilder(
      counterRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<bool>? isActive,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<CounterRow>([
        id,
        name,
        merchantId,
        storeId,
        isActive,
        description,
        imageUrl,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

extension InsertSingleCounterRowExt on InsertSingle<CounterRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((counterRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<CounterRow> onConflict(CounterRowConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleCounterRowExt
    on InsertOnConflictSingle<CounterRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `counterRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<CounterRow> update(
    UpdateSet<CounterRow> Function(
      Expr<CounterRow> counterRow,
      Expr<CounterRow> excluded,
      UpdateSet<CounterRow> Function({
        Expr<String> id,
        Expr<String> name,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<bool> isActive,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<CounterRow>(
    this,
    (counterRow, excluded) => updateBuilder(
      counterRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? name,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<bool>? isActive,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<CounterRow>([
        id,
        name,
        merchantId,
        storeId,
        isActive,
        description,
        imageUrl,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

final class _$ProductRow extends ProductRow {
  _$ProductRow._(
    this.id,
    this.merchantId,
    this.storeId,
    this.name,
    this.sku,
    this.barcode,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.counterId,
    this.taxRate,
    this.basePrice,
    this.sellingPrice,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  );

  @override
  final String id;

  @override
  final String merchantId;

  @override
  final String storeId;

  @override
  final String name;

  @override
  final String? sku;

  @override
  final String? barcode;

  @override
  final String? description;

  @override
  final String? imageUrl;

  @override
  final String? categoryId;

  @override
  final String? counterId;

  @override
  final double taxRate;

  @override
  final int basePrice;

  @override
  final int sellingPrice;

  @override
  final bool isActive;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'products',
    columns: <String>[
      'id',
      'merchant_id',
      'store_id',
      'name',
      'sku',
      'barcode',
      'description',
      'image_url',
      'category_id',
      'counter_id',
      'tax_rate',
      'base_price',
      'selling_price',
      'is_active',
      'created_at',
      'updated_at',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 'gen_random_uuid()'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: false,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.real,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0.0),
        autoIncrement: false,
        overrides: [
          (
            dialect: 'postgres',
            columnType: 'NUMERIC(5, 2)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.boolean,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: true),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['merchant_id', 'sku'],
      ['store_id', 'name'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['merchant_id'],
        referencedTable: 'merchants',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['store_id'],
        referencedTable: 'stores',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['category_id'],
        referencedTable: 'categories',
        referencedColumns: ['id'],
        onDelete: .setNull,
        onUpdate: .noAction,
      ),
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['counter_id'],
        referencedTable: 'counters',
        referencedColumns: ['id'],
        onDelete: .setNull,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$ProductRow._$fromDatabase,
  );

  static ProductRow? _$fromDatabase(RowReader row) {
    final id = row.readString();
    final merchantId = row.readString();
    final storeId = row.readString();
    final name = row.readString();
    final sku = row.readString();
    final barcode = row.readString();
    final description = row.readString();
    final imageUrl = row.readString();
    final categoryId = row.readString();
    final counterId = row.readString();
    final taxRate = row.readDouble();
    final basePrice = row.readInt();
    final sellingPrice = row.readInt();
    final isActive = row.readBool();
    final createdAt = row.readDateTime();
    final updatedAt = row.readDateTime();
    if (id == null &&
        merchantId == null &&
        storeId == null &&
        name == null &&
        sku == null &&
        barcode == null &&
        description == null &&
        imageUrl == null &&
        categoryId == null &&
        counterId == null &&
        taxRate == null &&
        basePrice == null &&
        sellingPrice == null &&
        isActive == null &&
        createdAt == null &&
        updatedAt == null) {
      return null;
    }
    return _$ProductRow._(
      id!,
      merchantId!,
      storeId!,
      name!,
      sku,
      barcode,
      description,
      imageUrl,
      categoryId,
      counterId,
      taxRate!,
      basePrice!,
      sellingPrice!,
      isActive!,
      createdAt!,
      updatedAt!,
    );
  }

  @override
  String toString() =>
      'ProductRow(id: "$id", merchantId: "$merchantId", storeId: "$storeId", name: "$name", sku: "$sku", barcode: "$barcode", description: "$description", imageUrl: "$imageUrl", categoryId: "$categoryId", counterId: "$counterId", taxRate: "$taxRate", basePrice: "$basePrice", sellingPrice: "$sellingPrice", isActive: "$isActive", createdAt: "$createdAt", updatedAt: "$updatedAt")';
}

/// Extension methods for table defined in [ProductRow].
extension TableProductRowExt on Table<ProductRow> {
  /// Insert row into the `products` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ProductRow> insert({
    Expr<String>? id,
    required Expr<String> merchantId,
    required Expr<String> storeId,
    required Expr<String> name,
    Expr<String?>? sku,
    Expr<String?>? barcode,
    Expr<String?>? description,
    Expr<String?>? imageUrl,
    Expr<String?>? categoryId,
    Expr<String?>? counterId,
    Expr<double>? taxRate,
    Expr<int>? basePrice,
    Expr<int>? sellingPrice,
    Expr<bool>? isActive,
    Expr<DateTime>? createdAt,
    Expr<DateTime>? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id,
      merchantId,
      storeId,
      name,
      sku,
      barcode,
      description,
      imageUrl,
      categoryId,
      counterId,
      taxRate,
      basePrice,
      sellingPrice,
      isActive,
      createdAt,
      updatedAt,
    ],
  );

  /// Insert row into the `products` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<ProductRow> insertValue({
    String? id,
    required String merchantId,
    required String storeId,
    required String name,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    String? categoryId,
    String? counterId,
    double? taxRate,
    int? basePrice,
    int? sellingPrice,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      merchantId.asExpr,
      storeId.asExpr,
      name.asExpr,
      sku.asExpr,
      barcode.asExpr,
      description.asExpr,
      imageUrl.asExpr,
      categoryId.asExpr,
      counterId.asExpr,
      taxRate?.asExpr,
      basePrice?.asExpr,
      sellingPrice?.asExpr,
      isActive?.asExpr,
      createdAt?.asExpr,
      updatedAt?.asExpr,
    ],
  );

  /// Bulk insert rows into the `products` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<ProductRow> insertValuesMapped<T>(
    Iterable<T> rows, {
    String Function(T row)? id,
    required String Function(T row) merchantId,
    required String Function(T row) storeId,
    required String Function(T row) name,
    String? Function(T row)? sku,
    String? Function(T row)? barcode,
    String? Function(T row)? description,
    String? Function(T row)? imageUrl,
    String? Function(T row)? categoryId,
    String? Function(T row)? counterId,
    double Function(T row)? taxRate,
    int Function(T row)? basePrice,
    int Function(T row)? sellingPrice,
    bool Function(T row)? isActive,
    DateTime Function(T row)? createdAt,
    DateTime Function(T row)? updatedAt,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      id,
      merchantId,
      storeId,
      name,
      sku,
      barcode,
      description,
      imageUrl,
      categoryId,
      counterId,
      taxRate,
      basePrice,
      sellingPrice,
      isActive,
      createdAt,
      updatedAt,
    ],
  );

  /// Delete a single row from the `products` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<ProductRow> delete(String id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$ProductRow._$table);
}

/// Extension methods for building queries against the `products` table.
extension QueryProductRowExt on Query<(Expr<ProductRow>,)> {
  /// Lookup a single row in `products` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ProductRow>,)> byKey(String id) =>
      where((productRow) => productRow.id.equalsValue(id)).first;

  /// Update all rows in the `products` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<ProductRow> update(
    UpdateSet<ProductRow> Function(
      Expr<ProductRow> productRow,
      UpdateSet<ProductRow> Function({
        Expr<String> id,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<String> name,
        Expr<String?> sku,
        Expr<String?> barcode,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<String?> categoryId,
        Expr<String?> counterId,
        Expr<double> taxRate,
        Expr<int> basePrice,
        Expr<int> sellingPrice,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<ProductRow>(
    this,
    _$ProductRow._$table,
    (productRow) => updateBuilder(
      productRow,
      ({
        Expr<String>? id,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<String>? name,
        Expr<String?>? sku,
        Expr<String?>? barcode,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<String?>? categoryId,
        Expr<String?>? counterId,
        Expr<double>? taxRate,
        Expr<int>? basePrice,
        Expr<int>? sellingPrice,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<ProductRow>([
        id,
        merchantId,
        storeId,
        name,
        sku,
        barcode,
        description,
        imageUrl,
        categoryId,
        counterId,
        taxRate,
        basePrice,
        sellingPrice,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Lookup a single row in `products` table using the
  /// `merchantId`, `sku` fields
  ///
  /// We know that lookup by the `merchantId`, `sku` fields returns
  /// at-most one row because the [Unique] annotation in [ProductRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ProductRow>,)> byUniqueMerchantProductSku(
    String merchantId,
    String sku,
  ) => where(
    (productRow) =>
        productRow.merchantId.equalsValue(merchantId) &
        productRow.sku.equalsValue(sku),
  ).first;

  /// Lookup a single row in `products` table using the
  /// `storeId`, `name` fields
  ///
  /// We know that lookup by the `storeId`, `name` fields returns
  /// at-most one row because the [Unique] annotation in [ProductRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<ProductRow>,)> byUniqueStoreProductName(
    String storeId,
    String name,
  ) => where(
    (productRow) =>
        productRow.storeId.equalsValue(storeId) &
        productRow.name.equalsValue(name),
  ).first;

  /// Delete all rows in the `products` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<ProductRow> delete() =>
      $ForGeneratedCode.delete(this, _$ProductRow._$table);
}

/// Extension methods for building point queries against the `products` table.
extension QuerySingleProductRowExt on QuerySingle<(Expr<ProductRow>,)> {
  /// Update the row (if any) in the `products` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<ProductRow> update(
    UpdateSet<ProductRow> Function(
      Expr<ProductRow> productRow,
      UpdateSet<ProductRow> Function({
        Expr<String> id,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<String> name,
        Expr<String?> sku,
        Expr<String?> barcode,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<String?> categoryId,
        Expr<String?> counterId,
        Expr<double> taxRate,
        Expr<int> basePrice,
        Expr<int> sellingPrice,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<ProductRow>(
    this,
    _$ProductRow._$table,
    (productRow) => updateBuilder(
      productRow,
      ({
        Expr<String>? id,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<String>? name,
        Expr<String?>? sku,
        Expr<String?>? barcode,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<String?>? categoryId,
        Expr<String?>? counterId,
        Expr<double>? taxRate,
        Expr<int>? basePrice,
        Expr<int>? sellingPrice,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<ProductRow>([
        id,
        merchantId,
        storeId,
        name,
        sku,
        barcode,
        description,
        imageUrl,
        categoryId,
        counterId,
        taxRate,
        basePrice,
        sellingPrice,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Delete the row (if any) in the `products` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<ProductRow> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$ProductRow._$table);
}

/// Extension methods for expressions on a row in the `products` table.
extension ExpressionProductRowExt on Expr<ProductRow> {
  Expr<String> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get merchantId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get storeId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String?> get sku =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<String?> get barcode =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.text);

  Expr<String?> get description =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.text);

  Expr<String?> get imageUrl =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.text);

  Expr<String?> get categoryId =>
      $ForGeneratedCode.field(this, 8, $ForGeneratedCode.text);

  Expr<String?> get counterId =>
      $ForGeneratedCode.field(this, 9, $ForGeneratedCode.text);

  Expr<double> get taxRate =>
      $ForGeneratedCode.field(this, 10, $ForGeneratedCode.real);

  Expr<int> get basePrice =>
      $ForGeneratedCode.field(this, 11, $ForGeneratedCode.integer);

  Expr<int> get sellingPrice =>
      $ForGeneratedCode.field(this, 12, $ForGeneratedCode.integer);

  Expr<bool> get isActive =>
      $ForGeneratedCode.field(this, 13, $ForGeneratedCode.boolean);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 14, $ForGeneratedCode.dateTime);

  Expr<DateTime> get updatedAt =>
      $ForGeneratedCode.field(this, 15, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableProductRowExt on Expr<ProductRow?> {
  Expr<String?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get merchantId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get storeId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String?> get sku =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<String?> get barcode =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.text);

  Expr<String?> get description =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.text);

  Expr<String?> get imageUrl =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.text);

  Expr<String?> get categoryId =>
      $ForGeneratedCode.field(this, 8, $ForGeneratedCode.text);

  Expr<String?> get counterId =>
      $ForGeneratedCode.field(this, 9, $ForGeneratedCode.text);

  Expr<double?> get taxRate =>
      $ForGeneratedCode.field(this, 10, $ForGeneratedCode.real);

  Expr<int?> get basePrice =>
      $ForGeneratedCode.field(this, 11, $ForGeneratedCode.integer);

  Expr<int?> get sellingPrice =>
      $ForGeneratedCode.field(this, 12, $ForGeneratedCode.integer);

  Expr<bool?> get isActive =>
      $ForGeneratedCode.field(this, 13, $ForGeneratedCode.boolean);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 14, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get updatedAt =>
      $ForGeneratedCode.field(this, 15, $ForGeneratedCode.dateTime);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<ProductRow>` conflict targets for use with `.onConflict`.
enum ProductRowConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `merchantId`, `sku` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `merchantId`, `sku`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  uniqueMerchantProductSku(['merchant_id', 'sku']),

  /// `storeId`, `name` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `storeId`, `name`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  uniqueStoreProductName(['store_id', 'name']);

  const ProductRowConflict(this._fields);

  final List<String> _fields;
}

extension InsertProductRowExt on Insert<ProductRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((productRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<ProductRow> onConflict(ProductRowConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictProductRowExt on InsertOnConflict<ProductRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `productRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<ProductRow> update(
    UpdateSet<ProductRow> Function(
      Expr<ProductRow> productRow,
      Expr<ProductRow> excluded,
      UpdateSet<ProductRow> Function({
        Expr<String> id,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<String> name,
        Expr<String?> sku,
        Expr<String?> barcode,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<String?> categoryId,
        Expr<String?> counterId,
        Expr<double> taxRate,
        Expr<int> basePrice,
        Expr<int> sellingPrice,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<ProductRow>(
    this,
    (productRow, excluded) => updateBuilder(
      productRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<String>? name,
        Expr<String?>? sku,
        Expr<String?>? barcode,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<String?>? categoryId,
        Expr<String?>? counterId,
        Expr<double>? taxRate,
        Expr<int>? basePrice,
        Expr<int>? sellingPrice,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<ProductRow>([
        id,
        merchantId,
        storeId,
        name,
        sku,
        barcode,
        description,
        imageUrl,
        categoryId,
        counterId,
        taxRate,
        basePrice,
        sellingPrice,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

extension InsertSingleProductRowExt on InsertSingle<ProductRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((productRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<ProductRow> onConflict(ProductRowConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleProductRowExt
    on InsertOnConflictSingle<ProductRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `productRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<ProductRow> update(
    UpdateSet<ProductRow> Function(
      Expr<ProductRow> productRow,
      Expr<ProductRow> excluded,
      UpdateSet<ProductRow> Function({
        Expr<String> id,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<String> name,
        Expr<String?> sku,
        Expr<String?> barcode,
        Expr<String?> description,
        Expr<String?> imageUrl,
        Expr<String?> categoryId,
        Expr<String?> counterId,
        Expr<double> taxRate,
        Expr<int> basePrice,
        Expr<int> sellingPrice,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<ProductRow>(
    this,
    (productRow, excluded) => updateBuilder(
      productRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<String>? name,
        Expr<String?>? sku,
        Expr<String?>? barcode,
        Expr<String?>? description,
        Expr<String?>? imageUrl,
        Expr<String?>? categoryId,
        Expr<String?>? counterId,
        Expr<double>? taxRate,
        Expr<int>? basePrice,
        Expr<int>? sellingPrice,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<ProductRow>([
        id,
        merchantId,
        storeId,
        name,
        sku,
        barcode,
        description,
        imageUrl,
        categoryId,
        counterId,
        taxRate,
        basePrice,
        sellingPrice,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

final class _$StockRow extends StockRow {
  _$StockRow._(
    this.id,
    this.productId,
    this.storeId,
    this.quantity,
    this.lowStockThreshold,
    this.stockMonitor,
    this.createdAt,
    this.updatedAt,
  );

  @override
  final String id;

  @override
  final String productId;

  @override
  final String storeId;

  @override
  final int quantity;

  @override
  final int lowStockThreshold;

  @override
  final bool stockMonitor;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'stocks',
    columns: <String>[
      'id',
      'product_id',
      'store_id',
      'quantity',
      'low_stock_threshold',
      'stock_monitor',
      'created_at',
      'updated_at',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 'gen_random_uuid()'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: 0),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.boolean,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: false),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[
      ['store_id', 'product_id'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['product_id'],
        referencedTable: 'products',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['store_id'],
        referencedTable: 'stores',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$StockRow._$fromDatabase,
  );

  static StockRow? _$fromDatabase(RowReader row) {
    final id = row.readString();
    final productId = row.readString();
    final storeId = row.readString();
    final quantity = row.readInt();
    final lowStockThreshold = row.readInt();
    final stockMonitor = row.readBool();
    final createdAt = row.readDateTime();
    final updatedAt = row.readDateTime();
    if (id == null &&
        productId == null &&
        storeId == null &&
        quantity == null &&
        lowStockThreshold == null &&
        stockMonitor == null &&
        createdAt == null &&
        updatedAt == null) {
      return null;
    }
    return _$StockRow._(
      id!,
      productId!,
      storeId!,
      quantity!,
      lowStockThreshold!,
      stockMonitor!,
      createdAt!,
      updatedAt!,
    );
  }

  @override
  String toString() =>
      'StockRow(id: "$id", productId: "$productId", storeId: "$storeId", quantity: "$quantity", lowStockThreshold: "$lowStockThreshold", stockMonitor: "$stockMonitor", createdAt: "$createdAt", updatedAt: "$updatedAt")';
}

/// Extension methods for table defined in [StockRow].
extension TableStockRowExt on Table<StockRow> {
  /// Insert row into the `stocks` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<StockRow> insert({
    Expr<String>? id,
    required Expr<String> productId,
    required Expr<String> storeId,
    Expr<int>? quantity,
    Expr<int>? lowStockThreshold,
    Expr<bool>? stockMonitor,
    Expr<DateTime>? createdAt,
    Expr<DateTime>? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id,
      productId,
      storeId,
      quantity,
      lowStockThreshold,
      stockMonitor,
      createdAt,
      updatedAt,
    ],
  );

  /// Insert row into the `stocks` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<StockRow> insertValue({
    String? id,
    required String productId,
    required String storeId,
    int? quantity,
    int? lowStockThreshold,
    bool? stockMonitor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      productId.asExpr,
      storeId.asExpr,
      quantity?.asExpr,
      lowStockThreshold?.asExpr,
      stockMonitor?.asExpr,
      createdAt?.asExpr,
      updatedAt?.asExpr,
    ],
  );

  /// Bulk insert rows into the `stocks` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<StockRow> insertValuesMapped<T>(
    Iterable<T> rows, {
    String Function(T row)? id,
    required String Function(T row) productId,
    required String Function(T row) storeId,
    int Function(T row)? quantity,
    int Function(T row)? lowStockThreshold,
    bool Function(T row)? stockMonitor,
    DateTime Function(T row)? createdAt,
    DateTime Function(T row)? updatedAt,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      id,
      productId,
      storeId,
      quantity,
      lowStockThreshold,
      stockMonitor,
      createdAt,
      updatedAt,
    ],
  );

  /// Delete a single row from the `stocks` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<StockRow> delete(String id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$StockRow._$table);
}

/// Extension methods for building queries against the `stocks` table.
extension QueryStockRowExt on Query<(Expr<StockRow>,)> {
  /// Lookup a single row in `stocks` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<StockRow>,)> byKey(String id) =>
      where((stockRow) => stockRow.id.equalsValue(id)).first;

  /// Update all rows in the `stocks` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<StockRow> update(
    UpdateSet<StockRow> Function(
      Expr<StockRow> stockRow,
      UpdateSet<StockRow> Function({
        Expr<String> id,
        Expr<String> productId,
        Expr<String> storeId,
        Expr<int> quantity,
        Expr<int> lowStockThreshold,
        Expr<bool> stockMonitor,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<StockRow>(
    this,
    _$StockRow._$table,
    (stockRow) => updateBuilder(
      stockRow,
      ({
        Expr<String>? id,
        Expr<String>? productId,
        Expr<String>? storeId,
        Expr<int>? quantity,
        Expr<int>? lowStockThreshold,
        Expr<bool>? stockMonitor,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<StockRow>([
        id,
        productId,
        storeId,
        quantity,
        lowStockThreshold,
        stockMonitor,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Lookup a single row in `stocks` table using the
  /// `storeId`, `productId` fields
  ///
  /// We know that lookup by the `storeId`, `productId` fields returns
  /// at-most one row because the [Unique] annotation in [StockRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<StockRow>,)> byUniqueStoreProductStock(
    String storeId,
    String productId,
  ) => where(
    (stockRow) =>
        stockRow.storeId.equalsValue(storeId) &
        stockRow.productId.equalsValue(productId),
  ).first;

  /// Delete all rows in the `stocks` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<StockRow> delete() =>
      $ForGeneratedCode.delete(this, _$StockRow._$table);
}

/// Extension methods for building point queries against the `stocks` table.
extension QuerySingleStockRowExt on QuerySingle<(Expr<StockRow>,)> {
  /// Update the row (if any) in the `stocks` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<StockRow> update(
    UpdateSet<StockRow> Function(
      Expr<StockRow> stockRow,
      UpdateSet<StockRow> Function({
        Expr<String> id,
        Expr<String> productId,
        Expr<String> storeId,
        Expr<int> quantity,
        Expr<int> lowStockThreshold,
        Expr<bool> stockMonitor,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<StockRow>(
    this,
    _$StockRow._$table,
    (stockRow) => updateBuilder(
      stockRow,
      ({
        Expr<String>? id,
        Expr<String>? productId,
        Expr<String>? storeId,
        Expr<int>? quantity,
        Expr<int>? lowStockThreshold,
        Expr<bool>? stockMonitor,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<StockRow>([
        id,
        productId,
        storeId,
        quantity,
        lowStockThreshold,
        stockMonitor,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Delete the row (if any) in the `stocks` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<StockRow> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$StockRow._$table);
}

/// Extension methods for expressions on a row in the `stocks` table.
extension ExpressionStockRowExt on Expr<StockRow> {
  Expr<String> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get productId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get storeId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<int> get quantity =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);

  Expr<int> get lowStockThreshold =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.integer);

  Expr<bool> get stockMonitor =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.boolean);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  Expr<DateTime> get updatedAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableStockRowExt on Expr<StockRow?> {
  Expr<String?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get productId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get storeId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<int?> get quantity =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.integer);

  Expr<int?> get lowStockThreshold =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.integer);

  Expr<bool?> get stockMonitor =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.boolean);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get updatedAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<StockRow>` conflict targets for use with `.onConflict`.
enum StockRowConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']),

  /// `storeId`, `productId` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `storeId`, `productId`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  uniqueStoreProductStock(['store_id', 'product_id']);

  const StockRowConflict(this._fields);

  final List<String> _fields;
}

extension InsertStockRowExt on Insert<StockRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((stockRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<StockRow> onConflict(StockRowConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictStockRowExt on InsertOnConflict<StockRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `stockRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<StockRow> update(
    UpdateSet<StockRow> Function(
      Expr<StockRow> stockRow,
      Expr<StockRow> excluded,
      UpdateSet<StockRow> Function({
        Expr<String> id,
        Expr<String> productId,
        Expr<String> storeId,
        Expr<int> quantity,
        Expr<int> lowStockThreshold,
        Expr<bool> stockMonitor,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<StockRow>(
    this,
    (stockRow, excluded) => updateBuilder(
      stockRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? productId,
        Expr<String>? storeId,
        Expr<int>? quantity,
        Expr<int>? lowStockThreshold,
        Expr<bool>? stockMonitor,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<StockRow>([
        id,
        productId,
        storeId,
        quantity,
        lowStockThreshold,
        stockMonitor,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

extension InsertSingleStockRowExt on InsertSingle<StockRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((stockRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<StockRow> onConflict(StockRowConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleStockRowExt
    on InsertOnConflictSingle<StockRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `stockRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<StockRow> update(
    UpdateSet<StockRow> Function(
      Expr<StockRow> stockRow,
      Expr<StockRow> excluded,
      UpdateSet<StockRow> Function({
        Expr<String> id,
        Expr<String> productId,
        Expr<String> storeId,
        Expr<int> quantity,
        Expr<int> lowStockThreshold,
        Expr<bool> stockMonitor,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<StockRow>(
    this,
    (stockRow, excluded) => updateBuilder(
      stockRow,
      excluded,
      ({
        Expr<String>? id,
        Expr<String>? productId,
        Expr<String>? storeId,
        Expr<int>? quantity,
        Expr<int>? lowStockThreshold,
        Expr<bool>? stockMonitor,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<StockRow>([
        id,
        productId,
        storeId,
        quantity,
        lowStockThreshold,
        stockMonitor,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

final class _$TerminalRow extends TerminalRow {
  _$TerminalRow._(
    this.code,
    this.merchantId,
    this.storeId,
    this.name,
    this.passwordHash,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  );

  @override
  final String code;

  @override
  final String merchantId;

  @override
  final String storeId;

  @override
  final String name;

  @override
  final String passwordHash;

  @override
  final bool isActive;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'terminals',
    columns: <String>[
      'code',
      'merchant_id',
      'store_id',
      'name',
      'password_hash',
      'is_active',
      'created_at',
      'updated_at',
    ],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'postgres',
            columnType: 'VARCHAR(12)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.boolean,
        isNotNull: true,
        defaultValue: (kind: 'raw', value: true),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.dateTime,
        isNotNull: true,
        defaultValue: (kind: 'datetime', value: 'now'),
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['code'],
    unique: <List<String>>[
      ['store_id', 'name'],
    ],
    foreignKeys: [
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['merchant_id'],
        referencedTable: 'merchants',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
      $ForGeneratedCode.foreignKeyDefinition(
        name: 'null',
        columns: ['store_id'],
        referencedTable: 'stores',
        referencedColumns: ['id'],
        onDelete: .cascade,
        onUpdate: .noAction,
      ),
    ],
    readRow: _$TerminalRow._$fromDatabase,
  );

  static TerminalRow? _$fromDatabase(RowReader row) {
    final code = row.readString();
    final merchantId = row.readString();
    final storeId = row.readString();
    final name = row.readString();
    final passwordHash = row.readString();
    final isActive = row.readBool();
    final createdAt = row.readDateTime();
    final updatedAt = row.readDateTime();
    if (code == null &&
        merchantId == null &&
        storeId == null &&
        name == null &&
        passwordHash == null &&
        isActive == null &&
        createdAt == null &&
        updatedAt == null) {
      return null;
    }
    return _$TerminalRow._(
      code!,
      merchantId!,
      storeId!,
      name!,
      passwordHash!,
      isActive!,
      createdAt!,
      updatedAt!,
    );
  }

  @override
  String toString() =>
      'TerminalRow(code: "$code", merchantId: "$merchantId", storeId: "$storeId", name: "$name", passwordHash: "$passwordHash", isActive: "$isActive", createdAt: "$createdAt", updatedAt: "$updatedAt")';
}

/// Extension methods for table defined in [TerminalRow].
extension TableTerminalRowExt on Table<TerminalRow> {
  /// Insert row into the `terminals` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<TerminalRow> insert({
    required Expr<String> code,
    required Expr<String> merchantId,
    required Expr<String> storeId,
    required Expr<String> name,
    required Expr<String> passwordHash,
    Expr<bool>? isActive,
    Expr<DateTime>? createdAt,
    Expr<DateTime>? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      code,
      merchantId,
      storeId,
      name,
      passwordHash,
      isActive,
      createdAt,
      updatedAt,
    ],
  );

  /// Insert row into the `terminals` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<TerminalRow> insertValue({
    required String code,
    required String merchantId,
    required String storeId,
    required String name,
    required String passwordHash,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      code.asExpr,
      merchantId.asExpr,
      storeId.asExpr,
      name.asExpr,
      passwordHash.asExpr,
      isActive?.asExpr,
      createdAt?.asExpr,
      updatedAt?.asExpr,
    ],
  );

  /// Bulk insert rows into the `terminals` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<TerminalRow> insertValuesMapped<T>(
    Iterable<T> rows, {
    required String Function(T row) code,
    required String Function(T row) merchantId,
    required String Function(T row) storeId,
    required String Function(T row) name,
    required String Function(T row) passwordHash,
    bool Function(T row)? isActive,
    DateTime Function(T row)? createdAt,
    DateTime Function(T row)? updatedAt,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [
      code,
      merchantId,
      storeId,
      name,
      passwordHash,
      isActive,
      createdAt,
      updatedAt,
    ],
  );

  /// Delete a single row from the `terminals` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<TerminalRow> delete(String code) =>
      $ForGeneratedCode.deleteSingle(byKey(code), _$TerminalRow._$table);
}

/// Extension methods for building queries against the `terminals` table.
extension QueryTerminalRowExt on Query<(Expr<TerminalRow>,)> {
  /// Lookup a single row in `terminals` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<TerminalRow>,)> byKey(String code) =>
      where((terminalRow) => terminalRow.code.equalsValue(code)).first;

  /// Update all rows in the `terminals` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<TerminalRow> update(
    UpdateSet<TerminalRow> Function(
      Expr<TerminalRow> terminalRow,
      UpdateSet<TerminalRow> Function({
        Expr<String> code,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<String> name,
        Expr<String> passwordHash,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<TerminalRow>(
    this,
    _$TerminalRow._$table,
    (terminalRow) => updateBuilder(
      terminalRow,
      ({
        Expr<String>? code,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<String>? name,
        Expr<String>? passwordHash,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<TerminalRow>([
        code,
        merchantId,
        storeId,
        name,
        passwordHash,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Lookup a single row in `terminals` table using the
  /// `storeId`, `name` fields
  ///
  /// We know that lookup by the `storeId`, `name` fields returns
  /// at-most one row because the [Unique] annotation in [TerminalRow].
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<TerminalRow>,)> byUniqueStoreTerminalName(
    String storeId,
    String name,
  ) => where(
    (terminalRow) =>
        terminalRow.storeId.equalsValue(storeId) &
        terminalRow.name.equalsValue(name),
  ).first;

  /// Delete all rows in the `terminals` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<TerminalRow> delete() =>
      $ForGeneratedCode.delete(this, _$TerminalRow._$table);
}

/// Extension methods for building point queries against the `terminals` table.
extension QuerySingleTerminalRowExt on QuerySingle<(Expr<TerminalRow>,)> {
  /// Update the row (if any) in the `terminals` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<TerminalRow> update(
    UpdateSet<TerminalRow> Function(
      Expr<TerminalRow> terminalRow,
      UpdateSet<TerminalRow> Function({
        Expr<String> code,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<String> name,
        Expr<String> passwordHash,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<TerminalRow>(
    this,
    _$TerminalRow._$table,
    (terminalRow) => updateBuilder(
      terminalRow,
      ({
        Expr<String>? code,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<String>? name,
        Expr<String>? passwordHash,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<TerminalRow>([
        code,
        merchantId,
        storeId,
        name,
        passwordHash,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );

  /// Delete the row (if any) in the `terminals` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<TerminalRow> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$TerminalRow._$table);
}

/// Extension methods for expressions on a row in the `terminals` table.
extension ExpressionTerminalRowExt on Expr<TerminalRow> {
  Expr<String> get code =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String> get merchantId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get storeId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get name =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String> get passwordHash =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<bool> get isActive =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.boolean);

  Expr<DateTime> get createdAt =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  Expr<DateTime> get updatedAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);
}

extension ExpressionNullableTerminalRowExt on Expr<TerminalRow?> {
  Expr<String?> get code =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.text);

  Expr<String?> get merchantId =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get storeId =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get name =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String?> get passwordHash =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  Expr<bool?> get isActive =>
      $ForGeneratedCode.field(this, 5, $ForGeneratedCode.boolean);

  Expr<DateTime?> get createdAt =>
      $ForGeneratedCode.field(this, 6, $ForGeneratedCode.dateTime);

  Expr<DateTime?> get updatedAt =>
      $ForGeneratedCode.field(this, 7, $ForGeneratedCode.dateTime);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => code.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<TerminalRow>` conflict targets for use with `.onConflict`.
enum TerminalRowConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `code`.
  primaryKey(['code']),

  /// `storeId`, `name` conflict.
  ///
  /// Due to violation of the `UNIQUE` constraint on
  /// `storeId`, `name`.
  ///
  /// Thus, the conflicting row has matching values for these fields.
  uniqueStoreTerminalName(['store_id', 'name']);

  const TerminalRowConflict(this._fields);

  final List<String> _fields;
}

extension InsertTerminalRowExt on Insert<TerminalRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((terminalRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<TerminalRow> onConflict(TerminalRowConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictTerminalRowExt on InsertOnConflict<TerminalRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `terminalRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<TerminalRow> update(
    UpdateSet<TerminalRow> Function(
      Expr<TerminalRow> terminalRow,
      Expr<TerminalRow> excluded,
      UpdateSet<TerminalRow> Function({
        Expr<String> code,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<String> name,
        Expr<String> passwordHash,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<TerminalRow>(
    this,
    (terminalRow, excluded) => updateBuilder(
      terminalRow,
      excluded,
      ({
        Expr<String>? code,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<String>? name,
        Expr<String>? passwordHash,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<TerminalRow>([
        code,
        merchantId,
        storeId,
        name,
        passwordHash,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}

extension InsertSingleTerminalRowExt on InsertSingle<TerminalRow> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((terminalRow, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<TerminalRow> onConflict(TerminalRowConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleTerminalRowExt
    on InsertOnConflictSingle<TerminalRow> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `terminalRow` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<TerminalRow> update(
    UpdateSet<TerminalRow> Function(
      Expr<TerminalRow> terminalRow,
      Expr<TerminalRow> excluded,
      UpdateSet<TerminalRow> Function({
        Expr<String> code,
        Expr<String> merchantId,
        Expr<String> storeId,
        Expr<String> name,
        Expr<String> passwordHash,
        Expr<bool> isActive,
        Expr<DateTime> createdAt,
        Expr<DateTime> updatedAt,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<TerminalRow>(
    this,
    (terminalRow, excluded) => updateBuilder(
      terminalRow,
      excluded,
      ({
        Expr<String>? code,
        Expr<String>? merchantId,
        Expr<String>? storeId,
        Expr<String>? name,
        Expr<String>? passwordHash,
        Expr<bool>? isActive,
        Expr<DateTime>? createdAt,
        Expr<DateTime>? updatedAt,
      }) => $ForGeneratedCode.buildUpdate<TerminalRow>([
        code,
        merchantId,
        storeId,
        name,
        passwordHash,
        isActive,
        createdAt,
        updatedAt,
      ]),
    ),
  );
}
