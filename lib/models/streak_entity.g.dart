// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStreakEntityCollection on Isar {
  IsarCollection<StreakEntity> get streakEntitys => this.collection();
}

const StreakEntitySchema = CollectionSchema(
  name: r'StreakEntity',
  id: 815451123336840549,
  properties: {
    r'bestStreak': PropertySchema(
      id: 0,
      name: r'bestStreak',
      type: IsarType.long,
    ),
    r'currentStreak': PropertySchema(
      id: 1,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'lastSuccessfulWakeup': PropertySchema(
      id: 2,
      name: r'lastSuccessfulWakeup',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _streakEntityEstimateSize,
  serialize: _streakEntitySerialize,
  deserialize: _streakEntityDeserialize,
  deserializeProp: _streakEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _streakEntityGetId,
  getLinks: _streakEntityGetLinks,
  attach: _streakEntityAttach,
  version: '3.1.0+1',
);

int _streakEntityEstimateSize(
  StreakEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _streakEntitySerialize(
  StreakEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bestStreak);
  writer.writeLong(offsets[1], object.currentStreak);
  writer.writeDateTime(offsets[2], object.lastSuccessfulWakeup);
}

StreakEntity _streakEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StreakEntity(
    bestStreak: reader.readLongOrNull(offsets[0]) ?? 0,
    currentStreak: reader.readLongOrNull(offsets[1]) ?? 0,
    lastSuccessfulWakeup: reader.readDateTimeOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _streakEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _streakEntityGetId(StreakEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _streakEntityGetLinks(StreakEntity object) {
  return [];
}

void _streakEntityAttach(
    IsarCollection<dynamic> col, Id id, StreakEntity object) {
  object.id = id;
}

extension StreakEntityQueryWhereSort
    on QueryBuilder<StreakEntity, StreakEntity, QWhere> {
  QueryBuilder<StreakEntity, StreakEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StreakEntityQueryWhere
    on QueryBuilder<StreakEntity, StreakEntity, QWhereClause> {
  QueryBuilder<StreakEntity, StreakEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StreakEntityQueryFilter
    on QueryBuilder<StreakEntity, StreakEntity, QFilterCondition> {
  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      bestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      bestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      bestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      bestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      lastSuccessfulWakeupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSuccessfulWakeup',
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      lastSuccessfulWakeupIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSuccessfulWakeup',
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      lastSuccessfulWakeupEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSuccessfulWakeup',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      lastSuccessfulWakeupGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSuccessfulWakeup',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      lastSuccessfulWakeupLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSuccessfulWakeup',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterFilterCondition>
      lastSuccessfulWakeupBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSuccessfulWakeup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StreakEntityQueryObject
    on QueryBuilder<StreakEntity, StreakEntity, QFilterCondition> {}

extension StreakEntityQueryLinks
    on QueryBuilder<StreakEntity, StreakEntity, QFilterCondition> {}

extension StreakEntityQuerySortBy
    on QueryBuilder<StreakEntity, StreakEntity, QSortBy> {
  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy> sortByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy>
      sortByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy> sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy>
      sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy>
      sortByLastSuccessfulWakeup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSuccessfulWakeup', Sort.asc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy>
      sortByLastSuccessfulWakeupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSuccessfulWakeup', Sort.desc);
    });
  }
}

extension StreakEntityQuerySortThenBy
    on QueryBuilder<StreakEntity, StreakEntity, QSortThenBy> {
  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy> thenByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy>
      thenByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy> thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy>
      thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy>
      thenByLastSuccessfulWakeup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSuccessfulWakeup', Sort.asc);
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QAfterSortBy>
      thenByLastSuccessfulWakeupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSuccessfulWakeup', Sort.desc);
    });
  }
}

extension StreakEntityQueryWhereDistinct
    on QueryBuilder<StreakEntity, StreakEntity, QDistinct> {
  QueryBuilder<StreakEntity, StreakEntity, QDistinct> distinctByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestStreak');
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QDistinct>
      distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<StreakEntity, StreakEntity, QDistinct>
      distinctByLastSuccessfulWakeup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSuccessfulWakeup');
    });
  }
}

extension StreakEntityQueryProperty
    on QueryBuilder<StreakEntity, StreakEntity, QQueryProperty> {
  QueryBuilder<StreakEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StreakEntity, int, QQueryOperations> bestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestStreak');
    });
  }

  QueryBuilder<StreakEntity, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<StreakEntity, DateTime?, QQueryOperations>
      lastSuccessfulWakeupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSuccessfulWakeup');
    });
  }
}
