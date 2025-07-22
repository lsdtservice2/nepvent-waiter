// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PrimaryCategoryMenu.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPrimaryCategoryMenuCollection on Isar {
  IsarCollection<PrimaryCategoryMenu> get primaryCategoryMenus =>
      this.collection();
}

const PrimaryCategoryMenuSchema = CollectionSchema(
  name: r'PrimaryCategoryMenu',
  id: -5653612528531214170,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _primaryCategoryMenuEstimateSize,
  serialize: _primaryCategoryMenuSerialize,
  deserialize: _primaryCategoryMenuDeserialize,
  deserializeProp: _primaryCategoryMenuDeserializeProp,
  idName: r'localId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _primaryCategoryMenuGetId,
  getLinks: _primaryCategoryMenuGetLinks,
  attach: _primaryCategoryMenuAttach,
  version: '3.1.0+1',
);

int _primaryCategoryMenuEstimateSize(
  PrimaryCategoryMenu object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _primaryCategoryMenuSerialize(
  PrimaryCategoryMenu object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeString(offsets[1], object.name);
}

PrimaryCategoryMenu _primaryCategoryMenuDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrimaryCategoryMenu();
  object.id = reader.readLong(offsets[0]);
  object.localId = id;
  object.name = reader.readString(offsets[1]);
  return object;
}

P _primaryCategoryMenuDeserializeProp<P>(
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

Id _primaryCategoryMenuGetId(PrimaryCategoryMenu object) {
  return object.localId;
}

List<IsarLinkBase<dynamic>> _primaryCategoryMenuGetLinks(
    PrimaryCategoryMenu object) {
  return [];
}

void _primaryCategoryMenuAttach(
    IsarCollection<dynamic> col, Id id, PrimaryCategoryMenu object) {
  object.localId = id;
}

extension PrimaryCategoryMenuQueryWhereSort
    on QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QWhere> {
  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterWhere>
      anyLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PrimaryCategoryMenuQueryWhere
    on QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QWhereClause> {
  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterWhereClause>
      localIdEqualTo(Id localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: localId,
        upper: localId,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterWhereClause>
      localIdNotEqualTo(Id localId) {
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

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterWhereClause>
      localIdGreaterThan(Id localId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: localId, includeLower: include),
      );
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterWhereClause>
      localIdLessThan(Id localId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: localId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterWhereClause>
      localIdBetween(
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

extension PrimaryCategoryMenuQueryFilter on QueryBuilder<PrimaryCategoryMenu,
    PrimaryCategoryMenu, QFilterCondition> {
  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
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

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
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

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      localIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      localIdGreaterThan(
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

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      localIdLessThan(
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

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      localIdBetween(
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

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension PrimaryCategoryMenuQueryObject on QueryBuilder<PrimaryCategoryMenu,
    PrimaryCategoryMenu, QFilterCondition> {}

extension PrimaryCategoryMenuQueryLinks on QueryBuilder<PrimaryCategoryMenu,
    PrimaryCategoryMenu, QFilterCondition> {}

extension PrimaryCategoryMenuQuerySortBy
    on QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QSortBy> {
  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension PrimaryCategoryMenuQuerySortThenBy
    on QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QSortThenBy> {
  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension PrimaryCategoryMenuQueryWhereDistinct
    on QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QDistinct> {
  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QDistinct>
      distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension PrimaryCategoryMenuQueryProperty
    on QueryBuilder<PrimaryCategoryMenu, PrimaryCategoryMenu, QQueryProperty> {
  QueryBuilder<PrimaryCategoryMenu, int, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<PrimaryCategoryMenu, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PrimaryCategoryMenu, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
