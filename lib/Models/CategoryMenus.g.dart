// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryMenus.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategoryMenusCollection on Isar {
  IsarCollection<CategoryMenus> get categoryMenus => this.collection();
}

const CategoryMenusSchema = CollectionSchema(
  name: r'CategoryMenus',
  id: -8998052929499147454,
  properties: {
    r'disableDiscount': PropertySchema(
      id: 0,
      name: r'disableDiscount',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'primaryCategoryId': PropertySchema(
      id: 3,
      name: r'primaryCategoryId',
      type: IsarType.long,
    )
  },
  estimateSize: _categoryMenusEstimateSize,
  serialize: _categoryMenusSerialize,
  deserialize: _categoryMenusDeserialize,
  deserializeProp: _categoryMenusDeserializeProp,
  idName: r'localId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _categoryMenusGetId,
  getLinks: _categoryMenusGetLinks,
  attach: _categoryMenusAttach,
  version: '3.1.0+1',
);

int _categoryMenusEstimateSize(
  CategoryMenus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _categoryMenusSerialize(
  CategoryMenus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.disableDiscount);
  writer.writeLong(offsets[1], object.id);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.primaryCategoryId);
}

CategoryMenus _categoryMenusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CategoryMenus();
  object.disableDiscount = reader.readBool(offsets[0]);
  object.id = reader.readLong(offsets[1]);
  object.localId = id;
  object.name = reader.readString(offsets[2]);
  object.primaryCategoryId = reader.readLong(offsets[3]);
  return object;
}

P _categoryMenusDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _categoryMenusGetId(CategoryMenus object) {
  return object.localId;
}

List<IsarLinkBase<dynamic>> _categoryMenusGetLinks(CategoryMenus object) {
  return [];
}

void _categoryMenusAttach(
    IsarCollection<dynamic> col, Id id, CategoryMenus object) {
  object.localId = id;
}

extension CategoryMenusQueryWhereSort
    on QueryBuilder<CategoryMenus, CategoryMenus, QWhere> {
  QueryBuilder<CategoryMenus, CategoryMenus, QAfterWhere> anyLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoryMenusQueryWhere
    on QueryBuilder<CategoryMenus, CategoryMenus, QWhereClause> {
  QueryBuilder<CategoryMenus, CategoryMenus, QAfterWhereClause> localIdEqualTo(
      Id localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: localId,
        upper: localId,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterWhereClause>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterWhereClause>
      localIdGreaterThan(Id localId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: localId, includeLower: include),
      );
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterWhereClause> localIdLessThan(
      Id localId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: localId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterWhereClause> localIdBetween(
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

extension CategoryMenusQueryFilter
    on QueryBuilder<CategoryMenus, CategoryMenus, QFilterCondition> {
  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      disableDiscountEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'disableDiscount',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      localIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
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

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      primaryCategoryIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryCategoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      primaryCategoryIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryCategoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      primaryCategoryIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryCategoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterFilterCondition>
      primaryCategoryIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryCategoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CategoryMenusQueryObject
    on QueryBuilder<CategoryMenus, CategoryMenus, QFilterCondition> {}

extension CategoryMenusQueryLinks
    on QueryBuilder<CategoryMenus, CategoryMenus, QFilterCondition> {}

extension CategoryMenusQuerySortBy
    on QueryBuilder<CategoryMenus, CategoryMenus, QSortBy> {
  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy>
      sortByDisableDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableDiscount', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy>
      sortByDisableDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableDiscount', Sort.desc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy>
      sortByPrimaryCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryCategoryId', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy>
      sortByPrimaryCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryCategoryId', Sort.desc);
    });
  }
}

extension CategoryMenusQuerySortThenBy
    on QueryBuilder<CategoryMenus, CategoryMenus, QSortThenBy> {
  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy>
      thenByDisableDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableDiscount', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy>
      thenByDisableDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableDiscount', Sort.desc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy>
      thenByPrimaryCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryCategoryId', Sort.asc);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QAfterSortBy>
      thenByPrimaryCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryCategoryId', Sort.desc);
    });
  }
}

extension CategoryMenusQueryWhereDistinct
    on QueryBuilder<CategoryMenus, CategoryMenus, QDistinct> {
  QueryBuilder<CategoryMenus, CategoryMenus, QDistinct>
      distinctByDisableDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'disableDiscount');
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CategoryMenus, CategoryMenus, QDistinct>
      distinctByPrimaryCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryCategoryId');
    });
  }
}

extension CategoryMenusQueryProperty
    on QueryBuilder<CategoryMenus, CategoryMenus, QQueryProperty> {
  QueryBuilder<CategoryMenus, int, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<CategoryMenus, bool, QQueryOperations>
      disableDiscountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'disableDiscount');
    });
  }

  QueryBuilder<CategoryMenus, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CategoryMenus, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CategoryMenus, int, QQueryOperations>
      primaryCategoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryCategoryId');
    });
  }
}
