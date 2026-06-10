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
    r'isFollowUp': PropertySchema(
      id: 1,
      name: r'isFollowUp',
      type: IsarType.bool,
    ),
    r'mathDifficulty': PropertySchema(
      id: 2,
      name: r'mathDifficulty',
      type: IsarType.long,
    ),
    r'mathQuestionsSolved': PropertySchema(
      id: 3,
      name: r'mathQuestionsSolved',
      type: IsarType.long,
    ),
    r'missionType': PropertySchema(
      id: 4,
      name: r'missionType',
      type: IsarType.string,
    ),
    r'puzzleCompletionTime': PropertySchema(
      id: 5,
      name: r'puzzleCompletionTime',
      type: IsarType.long,
    ),
    r'puzzleDifficulty': PropertySchema(
      id: 6,
      name: r'puzzleDifficulty',
      type: IsarType.long,
    ),
    r'puzzleMistakes': PropertySchema(
      id: 7,
      name: r'puzzleMistakes',
      type: IsarType.long,
    ),
    r'success': PropertySchema(
      id: 8,
      name: r'success',
      type: IsarType.bool,
    ),
    r'walkingCompletionTime': PropertySchema(
      id: 9,
      name: r'walkingCompletionTime',
      type: IsarType.long,
    ),
    r'walkingStepsGoal': PropertySchema(
      id: 10,
      name: r'walkingStepsGoal',
      type: IsarType.long,
    ),
    r'walkingStepsTaken': PropertySchema(
      id: 11,
      name: r'walkingStepsTaken',
      type: IsarType.long,
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
  writer.writeBool(offsets[1], object.isFollowUp);
  writer.writeLong(offsets[2], object.mathDifficulty);
  writer.writeLong(offsets[3], object.mathQuestionsSolved);
  writer.writeString(offsets[4], object.missionType);
  writer.writeLong(offsets[5], object.puzzleCompletionTime);
  writer.writeLong(offsets[6], object.puzzleDifficulty);
  writer.writeLong(offsets[7], object.puzzleMistakes);
  writer.writeBool(offsets[8], object.success);
  writer.writeLong(offsets[9], object.walkingCompletionTime);
  writer.writeLong(offsets[10], object.walkingStepsGoal);
  writer.writeLong(offsets[11], object.walkingStepsTaken);
}

MissionCompletionEntity _missionCompletionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MissionCompletionEntity(
    completedAt: reader.readDateTime(offsets[0]),
    isFollowUp: reader.readBoolOrNull(offsets[1]) ?? false,
    mathDifficulty: reader.readLongOrNull(offsets[2]),
    mathQuestionsSolved: reader.readLongOrNull(offsets[3]),
    missionType: reader.readString(offsets[4]),
    puzzleCompletionTime: reader.readLongOrNull(offsets[5]),
    puzzleDifficulty: reader.readLongOrNull(offsets[6]),
    puzzleMistakes: reader.readLongOrNull(offsets[7]),
    success: reader.readBoolOrNull(offsets[8]) ?? true,
    walkingCompletionTime: reader.readLongOrNull(offsets[9]),
    walkingStepsGoal: reader.readLongOrNull(offsets[10]),
    walkingStepsTaken: reader.readLongOrNull(offsets[11]),
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
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
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
      QAfterFilterCondition> isFollowUpEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFollowUp',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathDifficultyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mathDifficulty',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathDifficultyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mathDifficulty',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathDifficultyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mathDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathDifficultyGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mathDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathDifficultyLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mathDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathDifficultyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mathDifficulty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathQuestionsSolvedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mathQuestionsSolved',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathQuestionsSolvedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mathQuestionsSolved',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathQuestionsSolvedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mathQuestionsSolved',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathQuestionsSolvedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mathQuestionsSolved',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathQuestionsSolvedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mathQuestionsSolved',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> mathQuestionsSolvedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mathQuestionsSolved',
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
      QAfterFilterCondition> puzzleCompletionTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'puzzleCompletionTime',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleCompletionTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'puzzleCompletionTime',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleCompletionTimeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puzzleCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleCompletionTimeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puzzleCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleCompletionTimeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puzzleCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleCompletionTimeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puzzleCompletionTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleDifficultyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'puzzleDifficulty',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleDifficultyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'puzzleDifficulty',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleDifficultyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puzzleDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleDifficultyGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puzzleDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleDifficultyLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puzzleDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleDifficultyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puzzleDifficulty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleMistakesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'puzzleMistakes',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleMistakesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'puzzleMistakes',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleMistakesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puzzleMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleMistakesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puzzleMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleMistakesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puzzleMistakes',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> puzzleMistakesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puzzleMistakes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingCompletionTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'walkingCompletionTime',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingCompletionTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'walkingCompletionTime',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingCompletionTimeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walkingCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingCompletionTimeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'walkingCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingCompletionTimeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'walkingCompletionTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingCompletionTimeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'walkingCompletionTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsGoalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'walkingStepsGoal',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsGoalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'walkingStepsGoal',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsGoalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walkingStepsGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsGoalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'walkingStepsGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsGoalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'walkingStepsGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsGoalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'walkingStepsGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsTakenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'walkingStepsTaken',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsTakenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'walkingStepsTaken',
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsTakenEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walkingStepsTaken',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsTakenGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'walkingStepsTaken',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsTakenLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'walkingStepsTaken',
        value: value,
      ));
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity,
      QAfterFilterCondition> walkingStepsTakenBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'walkingStepsTaken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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
      sortByIsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFollowUp', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByIsFollowUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFollowUp', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByMathDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathDifficulty', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByMathDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathDifficulty', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByMathQuestionsSolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathQuestionsSolved', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByMathQuestionsSolvedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathQuestionsSolved', Sort.desc);
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
      sortByPuzzleCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleCompletionTime', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByPuzzleCompletionTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleCompletionTime', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByPuzzleDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleDifficulty', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByPuzzleDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleDifficulty', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByPuzzleMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleMistakes', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByPuzzleMistakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleMistakes', Sort.desc);
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

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByWalkingCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingCompletionTime', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByWalkingCompletionTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingCompletionTime', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByWalkingStepsGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingStepsGoal', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByWalkingStepsGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingStepsGoal', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByWalkingStepsTaken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingStepsTaken', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      sortByWalkingStepsTakenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingStepsTaken', Sort.desc);
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
      thenByIsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFollowUp', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByIsFollowUpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFollowUp', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByMathDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathDifficulty', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByMathDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathDifficulty', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByMathQuestionsSolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathQuestionsSolved', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByMathQuestionsSolvedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathQuestionsSolved', Sort.desc);
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
      thenByPuzzleCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleCompletionTime', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByPuzzleCompletionTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleCompletionTime', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByPuzzleDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleDifficulty', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByPuzzleDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleDifficulty', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByPuzzleMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleMistakes', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByPuzzleMistakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleMistakes', Sort.desc);
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

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByWalkingCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingCompletionTime', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByWalkingCompletionTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingCompletionTime', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByWalkingStepsGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingStepsGoal', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByWalkingStepsGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingStepsGoal', Sort.desc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByWalkingStepsTaken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingStepsTaken', Sort.asc);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QAfterSortBy>
      thenByWalkingStepsTakenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkingStepsTaken', Sort.desc);
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
      distinctByIsFollowUp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFollowUp');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByMathDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mathDifficulty');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByMathQuestionsSolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mathQuestionsSolved');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByMissionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missionType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByPuzzleCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puzzleCompletionTime');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByPuzzleDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puzzleDifficulty');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByPuzzleMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puzzleMistakes');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctBySuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'success');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByWalkingCompletionTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walkingCompletionTime');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByWalkingStepsGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walkingStepsGoal');
    });
  }

  QueryBuilder<MissionCompletionEntity, MissionCompletionEntity, QDistinct>
      distinctByWalkingStepsTaken() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walkingStepsTaken');
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

  QueryBuilder<MissionCompletionEntity, bool, QQueryOperations>
      isFollowUpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFollowUp');
    });
  }

  QueryBuilder<MissionCompletionEntity, int?, QQueryOperations>
      mathDifficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mathDifficulty');
    });
  }

  QueryBuilder<MissionCompletionEntity, int?, QQueryOperations>
      mathQuestionsSolvedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mathQuestionsSolved');
    });
  }

  QueryBuilder<MissionCompletionEntity, String, QQueryOperations>
      missionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missionType');
    });
  }

  QueryBuilder<MissionCompletionEntity, int?, QQueryOperations>
      puzzleCompletionTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puzzleCompletionTime');
    });
  }

  QueryBuilder<MissionCompletionEntity, int?, QQueryOperations>
      puzzleDifficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puzzleDifficulty');
    });
  }

  QueryBuilder<MissionCompletionEntity, int?, QQueryOperations>
      puzzleMistakesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puzzleMistakes');
    });
  }

  QueryBuilder<MissionCompletionEntity, bool, QQueryOperations>
      successProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'success');
    });
  }

  QueryBuilder<MissionCompletionEntity, int?, QQueryOperations>
      walkingCompletionTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walkingCompletionTime');
    });
  }

  QueryBuilder<MissionCompletionEntity, int?, QQueryOperations>
      walkingStepsGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walkingStepsGoal');
    });
  }

  QueryBuilder<MissionCompletionEntity, int?, QQueryOperations>
      walkingStepsTakenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walkingStepsTaken');
    });
  }
}
