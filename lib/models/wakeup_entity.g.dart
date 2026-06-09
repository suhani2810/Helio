// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wakeup_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWakeupEntityCollection on Isar {
  IsarCollection<WakeupEntity> get wakeupEntitys => this.collection();
}

const WakeupEntitySchema = CollectionSchema(
  name: r'WakeupEntity',
  id: -4344387555195756013,
  properties: {
    r'actualTime': PropertySchema(
      id: 0,
      name: r'actualTime',
      type: IsarType.dateTime,
    ),
    r'dayOfWeek': PropertySchema(
      id: 1,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'delayMinutes': PropertySchema(
      id: 2,
      name: r'delayMinutes',
      type: IsarType.long,
    ),
    r'missionUsed': PropertySchema(
      id: 3,
      name: r'missionUsed',
      type: IsarType.string,
    ),
    r'scheduledTime': PropertySchema(
      id: 4,
      name: r'scheduledTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _wakeupEntityEstimateSize,
  serialize: _wakeupEntitySerialize,
  deserialize: _wakeupEntityDeserialize,
  deserializeProp: _wakeupEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _wakeupEntityGetId,
  getLinks: _wakeupEntityGetLinks,
  attach: _wakeupEntityAttach,
  version: '3.1.0+1',
);

int _wakeupEntityEstimateSize(
  WakeupEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.missionUsed.length * 3;
  return bytesCount;
}

void _wakeupEntitySerialize(
  WakeupEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.actualTime);
  writer.writeLong(offsets[1], object.dayOfWeek);
  writer.writeLong(offsets[2], object.delayMinutes);
  writer.writeString(offsets[3], object.missionUsed);
  writer.writeDateTime(offsets[4], object.scheduledTime);
}

WakeupEntity _wakeupEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WakeupEntity(
    actualTime: reader.readDateTime(offsets[0]),
    dayOfWeek: reader.readLong(offsets[1]),
    delayMinutes: reader.readLong(offsets[2]),
    missionUsed: reader.readString(offsets[3]),
    scheduledTime: reader.readDateTime(offsets[4]),
  );
  object.id = id;
  return object;
}

P _wakeupEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wakeupEntityGetId(WakeupEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wakeupEntityGetLinks(WakeupEntity object) {
  return [];
}

void _wakeupEntityAttach(
    IsarCollection<dynamic> col, Id id, WakeupEntity object) {
  object.id = id;
}

extension WakeupEntityQueryWhereSort
    on QueryBuilder<WakeupEntity, WakeupEntity, QWhere> {
  QueryBuilder<WakeupEntity, WakeupEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WakeupEntityQueryWhere
    on QueryBuilder<WakeupEntity, WakeupEntity, QWhereClause> {
  QueryBuilder<WakeupEntity, WakeupEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterWhereClause> idBetween(
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

extension WakeupEntityQueryFilter
    on QueryBuilder<WakeupEntity, WakeupEntity, QFilterCondition> {
  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      actualTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      actualTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      actualTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      actualTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      dayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      dayOfWeekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      dayOfWeekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      dayOfWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      delayMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delayMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      delayMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'delayMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      delayMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'delayMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      delayMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'delayMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missionUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missionUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missionUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'missionUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'missionUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'missionUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'missionUsed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missionUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      missionUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'missionUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      scheduledTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      scheduledTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      scheduledTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterFilterCondition>
      scheduledTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WakeupEntityQueryObject
    on QueryBuilder<WakeupEntity, WakeupEntity, QFilterCondition> {}

extension WakeupEntityQueryLinks
    on QueryBuilder<WakeupEntity, WakeupEntity, QFilterCondition> {}

extension WakeupEntityQuerySortBy
    on QueryBuilder<WakeupEntity, WakeupEntity, QSortBy> {
  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> sortByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy>
      sortByActualTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> sortByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> sortByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> sortByDelayMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayMinutes', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy>
      sortByDelayMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayMinutes', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> sortByMissionUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionUsed', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy>
      sortByMissionUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionUsed', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> sortByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy>
      sortByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }
}

extension WakeupEntityQuerySortThenBy
    on QueryBuilder<WakeupEntity, WakeupEntity, QSortThenBy> {
  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> thenByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy>
      thenByActualTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualTime', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> thenByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> thenByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> thenByDelayMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayMinutes', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy>
      thenByDelayMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delayMinutes', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> thenByMissionUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionUsed', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy>
      thenByMissionUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missionUsed', Sort.desc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy> thenByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QAfterSortBy>
      thenByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }
}

extension WakeupEntityQueryWhereDistinct
    on QueryBuilder<WakeupEntity, WakeupEntity, QDistinct> {
  QueryBuilder<WakeupEntity, WakeupEntity, QDistinct> distinctByActualTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualTime');
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QDistinct> distinctByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfWeek');
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QDistinct> distinctByDelayMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'delayMinutes');
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QDistinct> distinctByMissionUsed(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missionUsed', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WakeupEntity, WakeupEntity, QDistinct>
      distinctByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledTime');
    });
  }
}

extension WakeupEntityQueryProperty
    on QueryBuilder<WakeupEntity, WakeupEntity, QQueryProperty> {
  QueryBuilder<WakeupEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WakeupEntity, DateTime, QQueryOperations> actualTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualTime');
    });
  }

  QueryBuilder<WakeupEntity, int, QQueryOperations> dayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfWeek');
    });
  }

  QueryBuilder<WakeupEntity, int, QQueryOperations> delayMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'delayMinutes');
    });
  }

  QueryBuilder<WakeupEntity, String, QQueryOperations> missionUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missionUsed');
    });
  }

  QueryBuilder<WakeupEntity, DateTime, QQueryOperations>
      scheduledTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTime');
    });
  }
}
