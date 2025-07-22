// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TableData.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTableDataCollection on Isar {
  IsarCollection<TableData> get tableDatas => this.collection();
}

const TableDataSchema = CollectionSchema(
  name: r'TableData',
  id: 8662430812901859450,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'joinedTable': PropertySchema(
      id: 1,
      name: r'joinedTable',
      type: IsarType.objectList,
      target: r'JoinedTable',
    ),
    r'locationId': PropertySchema(
      id: 2,
      name: r'locationId',
      type: IsarType.long,
    ),
    r'occupied': PropertySchema(
      id: 3,
      name: r'occupied',
      type: IsarType.bool,
    ),
    r'sourceTable': PropertySchema(
      id: 4,
      name: r'sourceTable',
      type: IsarType.objectList,
      target: r'SourceTable',
    ),
    r'table_name': PropertySchema(
      id: 5,
      name: r'table_name',
      type: IsarType.string,
    )
  },
  estimateSize: _tableDataEstimateSize,
  serialize: _tableDataSerialize,
  deserialize: _tableDataDeserialize,
  deserializeProp: _tableDataDeserializeProp,
  idName: r'localId',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'JoinedTable': JoinedTableSchema,
    r'PrimaryJoin': PrimaryJoinSchema,
    r'SourceTable': SourceTableSchema,
    r'SecondaryTable': SecondaryTableSchema
  },
  getId: _tableDataGetId,
  getLinks: _tableDataGetLinks,
  attach: _tableDataAttach,
  version: '3.1.0+1',
);

int _tableDataEstimateSize(
  TableData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.joinedTable.length * 3;
  {
    final offsets = allOffsets[JoinedTable]!;
    for (var i = 0; i < object.joinedTable.length; i++) {
      final value = object.joinedTable[i];
      bytesCount += JoinedTableSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.sourceTable.length * 3;
  {
    final offsets = allOffsets[SourceTable]!;
    for (var i = 0; i < object.sourceTable.length; i++) {
      final value = object.sourceTable[i];
      bytesCount += SourceTableSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.table_name.length * 3;
  return bytesCount;
}

void _tableDataSerialize(
  TableData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeObjectList<JoinedTable>(
    offsets[1],
    allOffsets,
    JoinedTableSchema.serialize,
    object.joinedTable,
  );
  writer.writeLong(offsets[2], object.locationId);
  writer.writeBool(offsets[3], object.occupied);
  writer.writeObjectList<SourceTable>(
    offsets[4],
    allOffsets,
    SourceTableSchema.serialize,
    object.sourceTable,
  );
  writer.writeString(offsets[5], object.table_name);
}

TableData _tableDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TableData();
  object.id = reader.readLong(offsets[0]);
  object.joinedTable = reader.readObjectList<JoinedTable>(
        offsets[1],
        JoinedTableSchema.deserialize,
        allOffsets,
        JoinedTable(),
      ) ??
      [];
  object.localId = id;
  object.locationId = reader.readLong(offsets[2]);
  object.occupied = reader.readBool(offsets[3]);
  object.sourceTable = reader.readObjectList<SourceTable>(
        offsets[4],
        SourceTableSchema.deserialize,
        allOffsets,
        SourceTable(),
      ) ??
      [];
  object.table_name = reader.readString(offsets[5]);
  return object;
}

P _tableDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readObjectList<JoinedTable>(
            offset,
            JoinedTableSchema.deserialize,
            allOffsets,
            JoinedTable(),
          ) ??
          []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readObjectList<SourceTable>(
            offset,
            SourceTableSchema.deserialize,
            allOffsets,
            SourceTable(),
          ) ??
          []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tableDataGetId(TableData object) {
  return object.localId;
}

List<IsarLinkBase<dynamic>> _tableDataGetLinks(TableData object) {
  return [];
}

void _tableDataAttach(IsarCollection<dynamic> col, Id id, TableData object) {
  object.localId = id;
}

extension TableDataQueryWhereSort
    on QueryBuilder<TableData, TableData, QWhere> {
  QueryBuilder<TableData, TableData, QAfterWhere> anyLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TableDataQueryWhere
    on QueryBuilder<TableData, TableData, QWhereClause> {
  QueryBuilder<TableData, TableData, QAfterWhereClause> localIdEqualTo(
      Id localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: localId,
        upper: localId,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterWhereClause> localIdNotEqualTo(
      Id localId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: localId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: localId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: localId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: localId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TableData, TableData, QAfterWhereClause> localIdGreaterThan(
      Id localId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: localId, includeLower: include),
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterWhereClause> localIdLessThan(
      Id localId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: localId, includeUpper: include),
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterWhereClause> localIdBetween(
    Id lowerLocalId,
    Id upperLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerLocalId,
        includeLower: includeLower,
        upper: upperLocalId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TableDataQueryFilter
    on QueryBuilder<TableData, TableData, QFilterCondition> {
  QueryBuilder<TableData, TableData, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      joinedTableLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinedTable',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      joinedTableIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinedTable',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      joinedTableIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinedTable',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      joinedTableLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinedTable',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      joinedTableLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinedTable',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      joinedTableLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinedTable',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> localIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> localIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> localIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> localIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> locationIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationId',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      locationIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationId',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> locationIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationId',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> locationIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> occupiedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occupied',
        value: value,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      sourceTableLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceTable',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      sourceTableIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceTable',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      sourceTableIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceTable',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      sourceTableLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceTable',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      sourceTableLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceTable',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      sourceTableLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceTable',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> table_nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      table_nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> table_nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> table_nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'table_name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      table_nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> table_nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> table_nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> table_nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'table_name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      table_nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table_name',
        value: '',
      ));
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition>
      table_nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'table_name',
        value: '',
      ));
    });
  }
}

extension TableDataQueryObject
    on QueryBuilder<TableData, TableData, QFilterCondition> {
  QueryBuilder<TableData, TableData, QAfterFilterCondition> joinedTableElement(
      FilterQuery<JoinedTable> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'joinedTable');
    });
  }

  QueryBuilder<TableData, TableData, QAfterFilterCondition> sourceTableElement(
      FilterQuery<SourceTable> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sourceTable');
    });
  }
}

extension TableDataQueryLinks
    on QueryBuilder<TableData, TableData, QFilterCondition> {}

extension TableDataQuerySortBy on QueryBuilder<TableData, TableData, QSortBy> {
  QueryBuilder<TableData, TableData, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> sortByLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> sortByLocationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.desc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> sortByOccupied() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupied', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> sortByOccupiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupied', Sort.desc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> sortByTable_name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table_name', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> sortByTable_nameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table_name', Sort.desc);
    });
  }
}

extension TableDataQuerySortThenBy
    on QueryBuilder<TableData, TableData, QSortThenBy> {
  QueryBuilder<TableData, TableData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByLocationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationId', Sort.desc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByOccupied() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupied', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByOccupiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupied', Sort.desc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByTable_name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table_name', Sort.asc);
    });
  }

  QueryBuilder<TableData, TableData, QAfterSortBy> thenByTable_nameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table_name', Sort.desc);
    });
  }
}

extension TableDataQueryWhereDistinct
    on QueryBuilder<TableData, TableData, QDistinct> {
  QueryBuilder<TableData, TableData, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<TableData, TableData, QDistinct> distinctByLocationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationId');
    });
  }

  QueryBuilder<TableData, TableData, QDistinct> distinctByOccupied() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occupied');
    });
  }

  QueryBuilder<TableData, TableData, QDistinct> distinctByTable_name(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'table_name', caseSensitive: caseSensitive);
    });
  }
}

extension TableDataQueryProperty
    on QueryBuilder<TableData, TableData, QQueryProperty> {
  QueryBuilder<TableData, int, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<TableData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TableData, List<JoinedTable>, QQueryOperations>
      joinedTableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'joinedTable');
    });
  }

  QueryBuilder<TableData, int, QQueryOperations> locationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationId');
    });
  }

  QueryBuilder<TableData, bool, QQueryOperations> occupiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occupied');
    });
  }

  QueryBuilder<TableData, List<SourceTable>, QQueryOperations>
      sourceTableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceTable');
    });
  }

  QueryBuilder<TableData, String, QQueryOperations> table_nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'table_name');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const JoinedTableSchema = Schema(
  name: r'JoinedTable',
  id: 3296747601605377663,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'joinTable': PropertySchema(
      id: 1,
      name: r'joinTable',
      type: IsarType.long,
    ),
    r'primaryJoin': PropertySchema(
      id: 2,
      name: r'primaryJoin',
      type: IsarType.object,
      target: r'PrimaryJoin',
    ),
    r'table': PropertySchema(
      id: 3,
      name: r'table',
      type: IsarType.long,
    )
  },
  estimateSize: _joinedTableEstimateSize,
  serialize: _joinedTableSerialize,
  deserialize: _joinedTableDeserialize,
  deserializeProp: _joinedTableDeserializeProp,
);

int _joinedTableEstimateSize(
  JoinedTable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      PrimaryJoinSchema.estimateSize(
          object.primaryJoin, allOffsets[PrimaryJoin]!, allOffsets);
  return bytesCount;
}

void _joinedTableSerialize(
  JoinedTable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeLong(offsets[1], object.joinTable);
  writer.writeObject<PrimaryJoin>(
    offsets[2],
    allOffsets,
    PrimaryJoinSchema.serialize,
    object.primaryJoin,
  );
  writer.writeLong(offsets[3], object.table);
}

JoinedTable _joinedTableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = JoinedTable();
  object.id = reader.readLong(offsets[0]);
  object.joinTable = reader.readLong(offsets[1]);
  object.primaryJoin = reader.readObjectOrNull<PrimaryJoin>(
        offsets[2],
        PrimaryJoinSchema.deserialize,
        allOffsets,
      ) ??
      PrimaryJoin();
  object.table = reader.readLong(offsets[3]);
  return object;
}

P _joinedTableDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readObjectOrNull<PrimaryJoin>(
            offset,
            PrimaryJoinSchema.deserialize,
            allOffsets,
          ) ??
          PrimaryJoin()) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension JoinedTableQueryFilter
    on QueryBuilder<JoinedTable, JoinedTable, QFilterCondition> {
  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition>
      joinTableEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'joinTable',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition>
      joinTableGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'joinTable',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition>
      joinTableLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'joinTable',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition>
      joinTableBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'joinTable',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition> tableEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition>
      tableGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'table',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition> tableLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'table',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition> tableBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'table',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension JoinedTableQueryObject
    on QueryBuilder<JoinedTable, JoinedTable, QFilterCondition> {
  QueryBuilder<JoinedTable, JoinedTable, QAfterFilterCondition> primaryJoin(
      FilterQuery<PrimaryJoin> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'primaryJoin');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PrimaryJoinSchema = Schema(
  name: r'PrimaryJoin',
  id: 2742235075702962663,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'table_name': PropertySchema(
      id: 1,
      name: r'table_name',
      type: IsarType.string,
    )
  },
  estimateSize: _primaryJoinEstimateSize,
  serialize: _primaryJoinSerialize,
  deserialize: _primaryJoinDeserialize,
  deserializeProp: _primaryJoinDeserializeProp,
);

int _primaryJoinEstimateSize(
  PrimaryJoin object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.table_name.length * 3;
  return bytesCount;
}

void _primaryJoinSerialize(
  PrimaryJoin object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeString(offsets[1], object.table_name);
}

PrimaryJoin _primaryJoinDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrimaryJoin();
  object.id = reader.readLong(offsets[0]);
  object.table_name = reader.readString(offsets[1]);
  return object;
}

P _primaryJoinDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PrimaryJoinQueryFilter
    on QueryBuilder<PrimaryJoin, PrimaryJoin, QFilterCondition> {
  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'table_name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'table_name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table_name',
        value: '',
      ));
    });
  }

  QueryBuilder<PrimaryJoin, PrimaryJoin, QAfterFilterCondition>
      table_nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'table_name',
        value: '',
      ));
    });
  }
}

extension PrimaryJoinQueryObject
    on QueryBuilder<PrimaryJoin, PrimaryJoin, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SourceTableSchema = Schema(
  name: r'SourceTable',
  id: -5229580086350416442,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'joinTable': PropertySchema(
      id: 1,
      name: r'joinTable',
      type: IsarType.long,
    ),
    r'secondaryTable': PropertySchema(
      id: 2,
      name: r'secondaryTable',
      type: IsarType.object,
      target: r'SecondaryTable',
    ),
    r'table': PropertySchema(
      id: 3,
      name: r'table',
      type: IsarType.long,
    )
  },
  estimateSize: _sourceTableEstimateSize,
  serialize: _sourceTableSerialize,
  deserialize: _sourceTableDeserialize,
  deserializeProp: _sourceTableDeserializeProp,
);

int _sourceTableEstimateSize(
  SourceTable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      SecondaryTableSchema.estimateSize(
          object.secondaryTable, allOffsets[SecondaryTable]!, allOffsets);
  return bytesCount;
}

void _sourceTableSerialize(
  SourceTable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeLong(offsets[1], object.joinTable);
  writer.writeObject<SecondaryTable>(
    offsets[2],
    allOffsets,
    SecondaryTableSchema.serialize,
    object.secondaryTable,
  );
  writer.writeLong(offsets[3], object.table);
}

SourceTable _sourceTableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SourceTable();
  object.id = reader.readLong(offsets[0]);
  object.joinTable = reader.readLong(offsets[1]);
  object.secondaryTable = reader.readObjectOrNull<SecondaryTable>(
        offsets[2],
        SecondaryTableSchema.deserialize,
        allOffsets,
      ) ??
      SecondaryTable();
  object.table = reader.readLong(offsets[3]);
  return object;
}

P _sourceTableDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readObjectOrNull<SecondaryTable>(
            offset,
            SecondaryTableSchema.deserialize,
            allOffsets,
          ) ??
          SecondaryTable()) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SourceTableQueryFilter
    on QueryBuilder<SourceTable, SourceTable, QFilterCondition> {
  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition>
      joinTableEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'joinTable',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition>
      joinTableGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'joinTable',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition>
      joinTableLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'joinTable',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition>
      joinTableBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'joinTable',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition> tableEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition>
      tableGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'table',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition> tableLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'table',
        value: value,
      ));
    });
  }

  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition> tableBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'table',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SourceTableQueryObject
    on QueryBuilder<SourceTable, SourceTable, QFilterCondition> {
  QueryBuilder<SourceTable, SourceTable, QAfterFilterCondition> secondaryTable(
      FilterQuery<SecondaryTable> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'secondaryTable');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SecondaryTableSchema = Schema(
  name: r'SecondaryTable',
  id: 379151636122251130,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'table_name': PropertySchema(
      id: 1,
      name: r'table_name',
      type: IsarType.string,
    )
  },
  estimateSize: _secondaryTableEstimateSize,
  serialize: _secondaryTableSerialize,
  deserialize: _secondaryTableDeserialize,
  deserializeProp: _secondaryTableDeserializeProp,
);

int _secondaryTableEstimateSize(
  SecondaryTable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.table_name.length * 3;
  return bytesCount;
}

void _secondaryTableSerialize(
  SecondaryTable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeString(offsets[1], object.table_name);
}

SecondaryTable _secondaryTableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SecondaryTable();
  object.id = reader.readLong(offsets[0]);
  object.table_name = reader.readString(offsets[1]);
  return object;
}

P _secondaryTableDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SecondaryTableQueryFilter
    on QueryBuilder<SecondaryTable, SecondaryTable, QFilterCondition> {
  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'table_name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'table_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'table_name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table_name',
        value: '',
      ));
    });
  }

  QueryBuilder<SecondaryTable, SecondaryTable, QAfterFilterCondition>
      table_nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'table_name',
        value: '',
      ));
    });
  }
}

extension SecondaryTableQueryObject
    on QueryBuilder<SecondaryTable, SecondaryTable, QFilterCondition> {}
