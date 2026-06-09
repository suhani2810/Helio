// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAlarmEntityCollection on Isar {
  IsarCollection<AlarmEntity> get alarmEntitys => this.collection();
}

const AlarmEntitySchema = CollectionSchema(
  name: r'AlarmEntity',
  id: -6964666276016564105,
  properties: {
    r'alarmTime': PropertySchema(
      id: 0,
      name: r'alarmTime',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'enabled': PropertySchema(
      id: 2,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'followUpEnabled': PropertySchema(
      id: 3,
      name: r'followUpEnabled',
      type: IsarType.bool,
    ),
    r'followUpMinutes': PropertySchema(
      id: 4,
      name: r'followUpMinutes',
      type: IsarType.long,
    ),
    r'followUpMission': PropertySchema(
      id: 5,
      name: r'followUpMission',
      type: IsarType.string,
    ),
    r'label': PropertySchema(
      id: 6,
      name: r'label',
      type: IsarType.string,
    ),
    r'mathDifficulty': PropertySchema(
      id: 7,
      name: r'mathDifficulty',
      type: IsarType.long,
    ),
    r'mathQuestionsCount': PropertySchema(
      id: 8,
      name: r'mathQuestionsCount',
      type: IsarType.long,
    ),
    r'missionType': PropertySchema(
      id: 9,
      name: r'missionType',
      type: IsarType.string,
    ),
    r'puzzleSize': PropertySchema(
      id: 10,
      name: r'puzzleSize',
      type: IsarType.long,
    ),
    r'repeatDays': PropertySchema(
      id: 11,
      name: r'repeatDays',
      type: IsarType.longList,
    ),
    r'ringtone': PropertySchema(
      id: 12,
      name: r'ringtone',
      type: IsarType.string,
    ),
    r'shakeLimit': PropertySchema(
      id: 13,
      name: r'shakeLimit',
      type: IsarType.long,
    ),
    r'stepGoal': PropertySchema(
      id: 14,
      name: r'stepGoal',
      type: IsarType.long,
    ),
    r'targetObject': PropertySchema(
      id: 15,
      name: r'targetObject',
      type: IsarType.string,
    )
  },
  estimateSize: _alarmEntityEstimateSize,
  serialize: _alarmEntitySerialize,
  deserialize: _alarmEntityDeserialize,
  deserializeProp: _alarmEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _alarmEntityGetId,
  getLinks: _alarmEntityGetLinks,
  attach: _alarmEntityAttach,
  version: '3.1.0+1',
);

int _alarmEntityEstimateSize(
  AlarmEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.followUpMission.length * 3;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.missionType.length * 3;
  bytesCount += 3 + object.repeatDays.length * 8;
  bytesCount += 3 + object.ringtone.length * 3;
  bytesCount += 3 + object.targetObject.length * 3;
  return bytesCount;
}

void _alarmEntitySerialize(
  AlarmEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.alarmTime);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.enabled);
  writer.writeBool(offsets[3], object.followUpEnabled);
  writer.writeLong(offsets[4], object.followUpMinutes);
  writer.writeString(offsets[5], object.followUpMission);
  writer.writeString(offsets[6], object.label);
  writer.writeLong(offsets[7], object.mathDifficulty);
  writer.writeLong(offsets[8], object.mathQuestionsCount);
  writer.writeString(offsets[9], object.missionType);
  writer.writeLong(offsets[10], object.puzzleSize);
  writer.writeLongList(offsets[11], object.repeatDays);
  writer.writeString(offsets[12], object.ringtone);
  writer.writeLong(offsets[13], object.shakeLimit);
  writer.writeLong(offsets[14], object.stepGoal);
  writer.writeString(offsets[15], object.targetObject);
}

AlarmEntity _alarmEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlarmEntity(
    alarmTime: reader.readDateTime(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    enabled: reader.readBoolOrNull(offsets[2]) ?? true,
    followUpEnabled: reader.readBoolOrNull(offsets[3]) ?? false,
    followUpMinutes: reader.readLongOrNull(offsets[4]) ?? 5,
    followUpMission: reader.readStringOrNull(offsets[5]) ?? 'None',
    label: reader.readStringOrNull(offsets[6]) ?? 'Alarm',
    mathDifficulty: reader.readLongOrNull(offsets[7]) ?? 1,
    mathQuestionsCount: reader.readLongOrNull(offsets[8]) ?? 3,
    missionType: reader.readStringOrNull(offsets[9]) ?? 'None',
    puzzleSize: reader.readLongOrNull(offsets[10]) ?? 3,
    repeatDays: reader.readLongList(offsets[11]) ?? const [],
    ringtone: reader.readStringOrNull(offsets[12]) ?? 'Default',
    shakeLimit: reader.readLongOrNull(offsets[13]) ?? 20,
    stepGoal: reader.readLongOrNull(offsets[14]) ?? 30,
    targetObject: reader.readStringOrNull(offsets[15]) ?? 'Mug',
  );
  object.id = id;
  return object;
}

P _alarmEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 5) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? 'None') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? 'Alarm') as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 3) as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? 'None') as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 3) as P;
    case 11:
      return (reader.readLongList(offset) ?? const []) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? 'Default') as P;
    case 13:
      return (reader.readLongOrNull(offset) ?? 20) as P;
    case 14:
      return (reader.readLongOrNull(offset) ?? 30) as P;
    case 15:
      return (reader.readStringOrNull(offset) ?? 'Mug') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _alarmEntityGetId(AlarmEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _alarmEntityGetLinks(AlarmEntity object) {
  return [];
}

void _alarmEntityAttach(
    IsarCollection<dynamic> col, Id id, AlarmEntity object) {
  object.id = id;
}

extension AlarmEntityQueryWhereSort
    on QueryBuilder<AlarmEntity, AlarmEntity, QWhere> {
  QueryBuilder<AlarmEntity, AlarmEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlarmEntityQueryWhere
    on QueryBuilder<AlarmEntity, AlarmEntity, QWhereClause> {
  QueryBuilder<AlarmEntity, AlarmEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterWhereClause> idBetween(
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

extension AlarmEntityQueryFilter
    on QueryBuilder<AlarmEntity, AlarmEntity, QFilterCondition> {
  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      alarmTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      alarmTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alarmTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      alarmTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alarmTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      alarmTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alarmTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> enabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'followUpMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'followUpMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'followUpMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpMission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'followUpMission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'followUpMission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'followUpMission',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'followUpMission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'followUpMission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'followUpMission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'followUpMission',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpMission',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      followUpMissionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'followUpMission',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> labelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> labelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      mathDifficultyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mathDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      mathDifficultyGreaterThan(
    int value, {
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      mathDifficultyLessThan(
    int value, {
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      mathDifficultyBetween(
    int lower,
    int upper, {
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      mathQuestionsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mathQuestionsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      mathQuestionsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mathQuestionsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      mathQuestionsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mathQuestionsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      mathQuestionsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mathQuestionsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeEqualTo(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeGreaterThan(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeLessThan(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeBetween(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeStartsWith(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeEndsWith(
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

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'missionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'missionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionType',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      missionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'missionType',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      puzzleSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puzzleSize',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      puzzleSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puzzleSize',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      puzzleSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puzzleSize',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      puzzleSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puzzleSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatDays',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeatDays',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeatDays',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeatDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      repeatDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repeatDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> ringtoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      ringtoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ringtone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      ringtoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ringtone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> ringtoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ringtone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      ringtoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ringtone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      ringtoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ringtone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      ringtoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ringtone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> ringtoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ringtone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      ringtoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtone',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      ringtoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ringtone',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      shakeLimitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shakeLimit',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      shakeLimitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shakeLimit',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      shakeLimitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shakeLimit',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      shakeLimitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shakeLimit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> stepGoalEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stepGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      stepGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stepGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      stepGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stepGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition> stepGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stepGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetObject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetObject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetObject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetObject',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetObject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetObject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetObject',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetObject',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetObject',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterFilterCondition>
      targetObjectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetObject',
        value: '',
      ));
    });
  }
}

extension AlarmEntityQueryObject
    on QueryBuilder<AlarmEntity, AlarmEntity, QFilterCondition> {}

extension AlarmEntityQueryLinks
    on QueryBuilder<AlarmEntity, AlarmEntity, QFilterCondition> {}

extension AlarmEntityQuerySortBy
    on QueryBuilder<AlarmEntity, AlarmEntity, QSortBy> {
  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByAlarmTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByFollowUpEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      sortByFollowUpEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByFollowUpMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpMinutes', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      sortByFollowUpMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpMinutes', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByFollowUpMission() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpMission', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      sortByFollowUpMissionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpMission', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByMathDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathDifficulty', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      sortByMathDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathDifficulty', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      sortByMathQuestionsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathQuestionsCount', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      sortByMathQuestionsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathQuestionsCount', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByMissionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionType', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByMissionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionType', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByPuzzleSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleSize', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByPuzzleSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleSize', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByRingtone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtone', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByRingtoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtone', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByShakeLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shakeLimit', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByShakeLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shakeLimit', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByStepGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepGoal', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByStepGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepGoal', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> sortByTargetObject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetObject', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      sortByTargetObjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetObject', Sort.desc);
    });
  }
}

extension AlarmEntityQuerySortThenBy
    on QueryBuilder<AlarmEntity, AlarmEntity, QSortThenBy> {
  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByAlarmTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByFollowUpEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      thenByFollowUpEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByFollowUpMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpMinutes', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      thenByFollowUpMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpMinutes', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByFollowUpMission() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpMission', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      thenByFollowUpMissionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpMission', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByMathDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathDifficulty', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      thenByMathDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathDifficulty', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      thenByMathQuestionsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathQuestionsCount', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      thenByMathQuestionsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathQuestionsCount', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByMissionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionType', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByMissionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionType', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByPuzzleSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleSize', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByPuzzleSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puzzleSize', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByRingtone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtone', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByRingtoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtone', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByShakeLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shakeLimit', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByShakeLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shakeLimit', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByStepGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepGoal', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByStepGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepGoal', Sort.desc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy> thenByTargetObject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetObject', Sort.asc);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QAfterSortBy>
      thenByTargetObjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetObject', Sort.desc);
    });
  }
}

extension AlarmEntityQueryWhereDistinct
    on QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> {
  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmTime');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct>
      distinctByFollowUpEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpEnabled');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct>
      distinctByFollowUpMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpMinutes');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByFollowUpMission(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpMission',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByMathDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mathDifficulty');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct>
      distinctByMathQuestionsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mathQuestionsCount');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByMissionType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missionType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByPuzzleSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puzzleSize');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByRepeatDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatDays');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByRingtone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ringtone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByShakeLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shakeLimit');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByStepGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stepGoal');
    });
  }

  QueryBuilder<AlarmEntity, AlarmEntity, QDistinct> distinctByTargetObject(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetObject', caseSensitive: caseSensitive);
    });
  }
}

extension AlarmEntityQueryProperty
    on QueryBuilder<AlarmEntity, AlarmEntity, QQueryProperty> {
  QueryBuilder<AlarmEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AlarmEntity, DateTime, QQueryOperations> alarmTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmTime');
    });
  }

  QueryBuilder<AlarmEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AlarmEntity, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<AlarmEntity, bool, QQueryOperations> followUpEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpEnabled');
    });
  }

  QueryBuilder<AlarmEntity, int, QQueryOperations> followUpMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpMinutes');
    });
  }

  QueryBuilder<AlarmEntity, String, QQueryOperations>
      followUpMissionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpMission');
    });
  }

  QueryBuilder<AlarmEntity, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<AlarmEntity, int, QQueryOperations> mathDifficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mathDifficulty');
    });
  }

  QueryBuilder<AlarmEntity, int, QQueryOperations>
      mathQuestionsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mathQuestionsCount');
    });
  }

  QueryBuilder<AlarmEntity, String, QQueryOperations> missionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missionType');
    });
  }

  QueryBuilder<AlarmEntity, int, QQueryOperations> puzzleSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puzzleSize');
    });
  }

  QueryBuilder<AlarmEntity, List<int>, QQueryOperations> repeatDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatDays');
    });
  }

  QueryBuilder<AlarmEntity, String, QQueryOperations> ringtoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ringtone');
    });
  }

  QueryBuilder<AlarmEntity, int, QQueryOperations> shakeLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shakeLimit');
    });
  }

  QueryBuilder<AlarmEntity, int, QQueryOperations> stepGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stepGoal');
    });
  }

  QueryBuilder<AlarmEntity, String, QQueryOperations> targetObjectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetObject');
    });
  }
}
