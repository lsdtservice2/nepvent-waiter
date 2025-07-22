// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Menus.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMenusCollection on Isar {
  IsarCollection<Menus> get menus => this.collection();
}

const MenusSchema = CollectionSchema(
  name: r'Menus',
  id: 345518906051189235,
  properties: {
    r'categoryMenuId': PropertySchema(
      id: 0,
      name: r'categoryMenuId',
      type: IsarType.long,
    ),
    r'discount': PropertySchema(
      id: 1,
      name: r'discount',
      type: IsarType.objectList,
      target: r'Discount',
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.long,
    ),
    r'isWeighted': PropertySchema(
      id: 3,
      name: r'isWeighted',
      type: IsarType.bool,
    ),
    r'itemAvailable': PropertySchema(
      id: 4,
      name: r'itemAvailable',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'optioned': PropertySchema(
      id: 6,
      name: r'optioned',
      type: IsarType.objectList,
      target: r'Optioned',
    ),
    r'price': PropertySchema(
      id: 7,
      name: r'price',
      type: IsarType.double,
    ),
    r'vatInc': PropertySchema(
      id: 8,
      name: r'vatInc',
      type: IsarType.bool,
    )
  },
  estimateSize: _menusEstimateSize,
  serialize: _menusSerialize,
  deserialize: _menusDeserialize,
  deserializeProp: _menusDeserializeProp,
  idName: r'localId',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'Discount': DiscountSchema,
    r'Optioned': OptionedSchema,
    r'Opts': OptsSchema
  },
  getId: _menusGetId,
  getLinks: _menusGetLinks,
  attach: _menusAttach,
  version: '3.1.0+1',
);

int _menusEstimateSize(
  Menus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.discount.length * 3;
  {
    final offsets = allOffsets[Discount]!;
    for (var i = 0; i < object.discount.length; i++) {
      final value = object.discount[i];
      bytesCount += DiscountSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.optioned.length * 3;
  {
    final offsets = allOffsets[Optioned]!;
    for (var i = 0; i < object.optioned.length; i++) {
      final value = object.optioned[i];
      bytesCount += OptionedSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _menusSerialize(
  Menus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.categoryMenuId);
  writer.writeObjectList<Discount>(
    offsets[1],
    allOffsets,
    DiscountSchema.serialize,
    object.discount,
  );
  writer.writeLong(offsets[2], object.id);
  writer.writeBool(offsets[3], object.isWeighted);
  writer.writeLong(offsets[4], object.itemAvailable);
  writer.writeString(offsets[5], object.name);
  writer.writeObjectList<Optioned>(
    offsets[6],
    allOffsets,
    OptionedSchema.serialize,
    object.optioned,
  );
  writer.writeDouble(offsets[7], object.price);
  writer.writeBool(offsets[8], object.vatInc);
}

Menus _menusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Menus();
  object.categoryMenuId = reader.readLong(offsets[0]);
  object.discount = reader.readObjectList<Discount>(
        offsets[1],
        DiscountSchema.deserialize,
        allOffsets,
        Discount(),
      ) ??
      [];
  object.id = reader.readLong(offsets[2]);
  object.isWeighted = reader.readBool(offsets[3]);
  object.itemAvailable = reader.readLongOrNull(offsets[4]);
  object.localId = id;
  object.name = reader.readString(offsets[5]);
  object.optioned = reader.readObjectList<Optioned>(
        offsets[6],
        OptionedSchema.deserialize,
        allOffsets,
        Optioned(),
      ) ??
      [];
  object.price = reader.readDouble(offsets[7]);
  object.vatInc = reader.readBool(offsets[8]);
  return object;
}

P _menusDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readObjectList<Discount>(
            offset,
            DiscountSchema.deserialize,
            allOffsets,
            Discount(),
          ) ??
          []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readObjectList<Optioned>(
            offset,
            OptionedSchema.deserialize,
            allOffsets,
            Optioned(),
          ) ??
          []) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _menusGetId(Menus object) {
  return object.localId;
}

List<IsarLinkBase<dynamic>> _menusGetLinks(Menus object) {
  return [];
}

void _menusAttach(IsarCollection<dynamic> col, Id id, Menus object) {
  object.localId = id;
}

extension MenusQueryWhereSort on QueryBuilder<Menus, Menus, QWhere> {
  QueryBuilder<Menus, Menus, QAfterWhere> anyLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MenusQueryWhere on QueryBuilder<Menus, Menus, QWhereClause> {
  QueryBuilder<Menus, Menus, QAfterWhereClause> localIdEqualTo(Id localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: localId,
        upper: localId,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterWhereClause> localIdNotEqualTo(Id localId) {
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

  QueryBuilder<Menus, Menus, QAfterWhereClause> localIdGreaterThan(Id localId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: localId, includeLower: include),
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterWhereClause> localIdLessThan(Id localId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: localId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterWhereClause> localIdBetween(
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

extension MenusQueryFilter on QueryBuilder<Menus, Menus, QFilterCondition> {
  QueryBuilder<Menus, Menus, QAfterFilterCondition> categoryMenuIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryMenuId',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> categoryMenuIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryMenuId',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> categoryMenuIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryMenuId',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> categoryMenuIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryMenuId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> discountLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discount',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> discountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discount',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> discountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discount',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> discountLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discount',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> discountLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discount',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> discountLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'discount',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> isWeightedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWeighted',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> itemAvailableIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemAvailable',
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> itemAvailableIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemAvailable',
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> itemAvailableEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> itemAvailableGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> itemAvailableLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> itemAvailableBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemAvailable',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> localIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> localIdGreaterThan(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> localIdLessThan(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> localIdBetween(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> optionedLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'optioned',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> optionedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'optioned',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> optionedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'optioned',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> optionedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'optioned',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> optionedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'optioned',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> optionedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'optioned',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> vatIncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vatInc',
        value: value,
      ));
    });
  }
}

extension MenusQueryObject on QueryBuilder<Menus, Menus, QFilterCondition> {
  QueryBuilder<Menus, Menus, QAfterFilterCondition> discountElement(
      FilterQuery<Discount> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'discount');
    });
  }

  QueryBuilder<Menus, Menus, QAfterFilterCondition> optionedElement(
      FilterQuery<Optioned> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'optioned');
    });
  }
}

extension MenusQueryLinks on QueryBuilder<Menus, Menus, QFilterCondition> {}

extension MenusQuerySortBy on QueryBuilder<Menus, Menus, QSortBy> {
  QueryBuilder<Menus, Menus, QAfterSortBy> sortByCategoryMenuId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryMenuId', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByCategoryMenuIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryMenuId', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByIsWeighted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeighted', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByIsWeightedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeighted', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByItemAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemAvailable', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByItemAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemAvailable', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByVatInc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatInc', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> sortByVatIncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatInc', Sort.desc);
    });
  }
}

extension MenusQuerySortThenBy on QueryBuilder<Menus, Menus, QSortThenBy> {
  QueryBuilder<Menus, Menus, QAfterSortBy> thenByCategoryMenuId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryMenuId', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByCategoryMenuIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryMenuId', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByIsWeighted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeighted', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByIsWeightedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeighted', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByItemAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemAvailable', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByItemAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemAvailable', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByVatInc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatInc', Sort.asc);
    });
  }

  QueryBuilder<Menus, Menus, QAfterSortBy> thenByVatIncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vatInc', Sort.desc);
    });
  }
}

extension MenusQueryWhereDistinct on QueryBuilder<Menus, Menus, QDistinct> {
  QueryBuilder<Menus, Menus, QDistinct> distinctByCategoryMenuId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryMenuId');
    });
  }

  QueryBuilder<Menus, Menus, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Menus, Menus, QDistinct> distinctByIsWeighted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWeighted');
    });
  }

  QueryBuilder<Menus, Menus, QDistinct> distinctByItemAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemAvailable');
    });
  }

  QueryBuilder<Menus, Menus, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Menus, Menus, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<Menus, Menus, QDistinct> distinctByVatInc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vatInc');
    });
  }
}

extension MenusQueryProperty on QueryBuilder<Menus, Menus, QQueryProperty> {
  QueryBuilder<Menus, int, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<Menus, int, QQueryOperations> categoryMenuIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryMenuId');
    });
  }

  QueryBuilder<Menus, List<Discount>, QQueryOperations> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<Menus, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Menus, bool, QQueryOperations> isWeightedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWeighted');
    });
  }

  QueryBuilder<Menus, int?, QQueryOperations> itemAvailableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemAvailable');
    });
  }

  QueryBuilder<Menus, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Menus, List<Optioned>, QQueryOperations> optionedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'optioned');
    });
  }

  QueryBuilder<Menus, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<Menus, bool, QQueryOperations> vatIncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vatInc');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DiscountSchema = Schema(
  name: r'Discount',
  id: -5682473105823550468,
  properties: {
    r'discount': PropertySchema(
      id: 0,
      name: r'discount',
      type: IsarType.long,
    ),
    r'flatRate': PropertySchema(
      id: 1,
      name: r'flatRate',
      type: IsarType.double,
    ),
    r'fromDate': PropertySchema(
      id: 2,
      name: r'fromDate',
      type: IsarType.dateTime,
    ),
    r'fromTime': PropertySchema(
      id: 3,
      name: r'fromTime',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'percent': PropertySchema(
      id: 5,
      name: r'percent',
      type: IsarType.bool,
    ),
    r'toDate': PropertySchema(
      id: 6,
      name: r'toDate',
      type: IsarType.dateTime,
    ),
    r'toTime': PropertySchema(
      id: 7,
      name: r'toTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _discountEstimateSize,
  serialize: _discountSerialize,
  deserialize: _discountDeserialize,
  deserializeProp: _discountDeserializeProp,
);

int _discountEstimateSize(
  Discount object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _discountSerialize(
  Discount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.discount);
  writer.writeDouble(offsets[1], object.flatRate);
  writer.writeDateTime(offsets[2], object.fromDate);
  writer.writeDateTime(offsets[3], object.fromTime);
  writer.writeString(offsets[4], object.name);
  writer.writeBool(offsets[5], object.percent);
  writer.writeDateTime(offsets[6], object.toDate);
  writer.writeDateTime(offsets[7], object.toTime);
}

Discount _discountDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Discount();
  object.discount = reader.readLongOrNull(offsets[0]);
  object.flatRate = reader.readDoubleOrNull(offsets[1]);
  object.fromDate = reader.readDateTime(offsets[2]);
  object.fromTime = reader.readDateTime(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.percent = reader.readBoolOrNull(offsets[5]);
  object.toDate = reader.readDateTime(offsets[6]);
  object.toTime = reader.readDateTime(offsets[7]);
  return object;
}

P _discountDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DiscountQueryFilter
    on QueryBuilder<Discount, Discount, QFilterCondition> {
  QueryBuilder<Discount, Discount, QAfterFilterCondition> discountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'discount',
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> discountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'discount',
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> discountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discount',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> discountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discount',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> discountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discount',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> discountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> flatRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'flatRate',
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> flatRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'flatRate',
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> flatRateEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flatRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> flatRateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flatRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> flatRateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flatRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> flatRateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flatRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> fromDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fromDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> fromDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fromDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> fromDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fromDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> fromDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fromDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> fromTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fromTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> fromTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fromTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> fromTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fromTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> fromTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fromTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> percentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'percent',
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> percentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'percent',
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> percentEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percent',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> toDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> toDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> toDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> toDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> toTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> toTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> toTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> toTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DiscountQueryObject
    on QueryBuilder<Discount, Discount, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const OptionedSchema = Schema(
  name: r'Optioned',
  id: 706210763632334341,
  properties: {
    r'current': PropertySchema(
      id: 0,
      name: r'current',
      type: IsarType.long,
    ),
    r'max': PropertySchema(
      id: 1,
      name: r'max',
      type: IsarType.long,
    ),
    r'min': PropertySchema(
      id: 2,
      name: r'min',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'opts': PropertySchema(
      id: 4,
      name: r'opts',
      type: IsarType.objectList,
      target: r'Opts',
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _optionedEstimateSize,
  serialize: _optionedSerialize,
  deserialize: _optionedDeserialize,
  deserializeProp: _optionedDeserializeProp,
);

int _optionedEstimateSize(
  Optioned object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.opts.length * 3;
  {
    final offsets = allOffsets[Opts]!;
    for (var i = 0; i < object.opts.length; i++) {
      final value = object.opts[i];
      bytesCount += OptsSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _optionedSerialize(
  Optioned object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.current);
  writer.writeLong(offsets[1], object.max);
  writer.writeLong(offsets[2], object.min);
  writer.writeString(offsets[3], object.name);
  writer.writeObjectList<Opts>(
    offsets[4],
    allOffsets,
    OptsSchema.serialize,
    object.opts,
  );
  writer.writeString(offsets[5], object.type);
}

Optioned _optionedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Optioned();
  object.current = reader.readLong(offsets[0]);
  object.max = reader.readLong(offsets[1]);
  object.min = reader.readLong(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.opts = reader.readObjectList<Opts>(
        offsets[4],
        OptsSchema.deserialize,
        allOffsets,
        Opts(),
      ) ??
      [];
  object.type = reader.readString(offsets[5]);
  return object;
}

P _optionedDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readObjectList<Opts>(
            offset,
            OptsSchema.deserialize,
            allOffsets,
            Opts(),
          ) ??
          []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension OptionedQueryFilter
    on QueryBuilder<Optioned, Optioned, QFilterCondition> {
  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> currentEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'current',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> currentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'current',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> currentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'current',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> currentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'current',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> maxEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'max',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> maxGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'max',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> maxLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'max',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> maxBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'max',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> minEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'min',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> minGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'min',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> minLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'min',
        value: value,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> minBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'min',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> optsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'opts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> optsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'opts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> optsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'opts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> optsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'opts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> optsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'opts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> optsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'opts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension OptionedQueryObject
    on QueryBuilder<Optioned, Optioned, QFilterCondition> {
  QueryBuilder<Optioned, Optioned, QAfterFilterCondition> optsElement(
      FilterQuery<Opts> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'opts');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const OptsSchema = Schema(
  name: r'Opts',
  id: -5993148364681963518,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.long,
    ),
    r'optName': PropertySchema(
      id: 1,
      name: r'optName',
      type: IsarType.string,
    ),
    r'optPrice': PropertySchema(
      id: 2,
      name: r'optPrice',
      type: IsarType.long,
    ),
    r'quantityEligible': PropertySchema(
      id: 3,
      name: r'quantityEligible',
      type: IsarType.bool,
    ),
    r'selected': PropertySchema(
      id: 4,
      name: r'selected',
      type: IsarType.bool,
    )
  },
  estimateSize: _optsEstimateSize,
  serialize: _optsSerialize,
  deserialize: _optsDeserialize,
  deserializeProp: _optsDeserializeProp,
);

int _optsEstimateSize(
  Opts object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.optName.length * 3;
  return bytesCount;
}

void _optsSerialize(
  Opts object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.count);
  writer.writeString(offsets[1], object.optName);
  writer.writeLong(offsets[2], object.optPrice);
  writer.writeBool(offsets[3], object.quantityEligible);
  writer.writeBool(offsets[4], object.selected);
}

Opts _optsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Opts();
  object.count = reader.readLong(offsets[0]);
  object.optName = reader.readString(offsets[1]);
  object.optPrice = reader.readLong(offsets[2]);
  object.quantityEligible = reader.readBool(offsets[3]);
  object.selected = reader.readBool(offsets[4]);
  return object;
}

P _optsDeserializeProp<P>(
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
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension OptsQueryFilter on QueryBuilder<Opts, Opts, QFilterCondition> {
  QueryBuilder<Opts, Opts, QAfterFilterCondition> countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> countGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> countLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> countBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'optName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'optName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'optName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'optName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'optName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'optName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'optName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'optName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'optName',
        value: '',
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'optName',
        value: '',
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optPriceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'optPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optPriceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'optPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optPriceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'optPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> optPriceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'optPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> quantityEligibleEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantityEligible',
        value: value,
      ));
    });
  }

  QueryBuilder<Opts, Opts, QAfterFilterCondition> selectedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selected',
        value: value,
      ));
    });
  }
}

extension OptsQueryObject on QueryBuilder<Opts, Opts, QFilterCondition> {}
