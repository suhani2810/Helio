// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_completion_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMissionCompletionEntityCollection on Isar {
  IsarCollection<MissionCompletionEntity> get missionCompletionEntitys =>
      this.collection();
}

const MissionCompletionEntitySchema = CollectionSchema(
  name: r'MissionCompletionEntity',
  id: -1088786403886864316,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'missionType': PropertySchema(
      id: 1,
      name: r'missionType',
      type: IsarType.string,
    ),
    r'success': PropertySchema(
      id: 2,
      name: r'success',
      type: IsarType.bool,
    )
  },
  estimateSize: _missionCompletionEntityEstimateSize,
  serialize: _missionCompletionEntitySerialize,
  deserialize: _missionCompletionEntityDeserialize,
  deserializeProp: _missionCompletionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _missionCompletionEntityGetId,
  getLinks: _missionCompletionEntityGetLinks,
  attach: _missionCompletionEntityAttach,
  version: '3.1.0+1',
);

int _missionCompletionEntityEstimateSize(
  MissionCompletionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.missionType.length * 3;
  return bytesCount;
}

void _missionCompletionEntitySerialize(
  MissionCompletionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeString(offsets[1], object.missionType);
  writer.writeBool(offsets[2], object.success);
}

MissionCompletionEntity _missionCompletionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MissionCompletionEntity(
    completedAt: reader.readDateTime(offsets[0]),
    missionType: reader.readString(offsets[1]),
    success: reader.readBoolOrNull(offsets[2]) ?? true,
  );
  object.id = id;
  return object;
}

P _missionCompletionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _missionCompletionEntityGetId(MissionCompletionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _missionCompletionEntityGetLinks(
    MissionCompletionEntity object) {
  return [];
}

void _missionCompletionEntityAttach(
    IsarCollection<dynamic> col, Id id, MissionCompletionEntity object) {
  object.id = id;
}

extension MissionCompletionEntityQueryWhereSort
    on QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QWhere> {
  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MissionCompletionEntityQueryWhere on QueryBuilder<
    MissionCompletionEntity, MissionCompletionEntity, QWhereClause> {
  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterWhereClause> idBetween(
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

extension MissionCompletionEntityQueryFilter on QueryBuilder<
    MissionCompletionEntity, MissionCompletionEntity, QFilterCondition> {
  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> completedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> completedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> completedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> missionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> missionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> missionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> missionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> missionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> missionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
          QAfterFilterCondition>
      missionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
          QAfterFilterCondition>
      missionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'missionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> missionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionType',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> missionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'missionType',
        value: '',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> successEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'success',
        value: value,
      ));
    });
  }
}

extension MissionCompletionEntityQueryObject on QueryBuilder<
    MissionCompletionEntity, MissionCompletionEntity, QFilterCondition> {}

extension MissionCompletionEntityQueryLinks on QueryBuilder<
    MissionCompletionEntity, MissionCompletionEntity, QFilterCondition> {}

extension MissionCompletionEntityQuerySortBy
    on QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QSortBy> {
  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByMissionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionType', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByMissionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionType', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortBySuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'success', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortBySuccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'success', Sort.desc);
    });
  }
}

extension MissionCompletionEntityQuerySortThenBy on QueryBuilder<
    MissionCompletionEntity, MissionCompletionEntity, QSortThenBy> {
  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByMissionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionType', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByMissionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionType', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenBySuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'success', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenBySuccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'success', Sort.desc);
    });
  }
}

extension MissionCompletionEntityQueryWhereDistinct on QueryBuilder<
    MissionCompletionEntity, MissionCompletionEntity, QDistinct> {
  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByMissionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missionType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctBySuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'success');
    });
  }
}

extension MissionCompletionEntityQueryProperty on QueryBuilder<
    MissionCompletionEntity, MissionCompletionEntity, QQueryProperty> {
  QueryBuilder<MissionCompletionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MissionCompletionEntity, DateTime, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<MissionCompletionEntity, String, QQueryOperations>
      missionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missionType');
    });
  }

  QueryBuilder<MissionCompletionEntity, bool, QQueryOperations>
      successProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'success');
    });
  }
}
