// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_minute.model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepMinuteCollection on Isar {
  IsarCollection<SleepMinute> get sleepMinutes => this.collection();
}

const SleepMinuteSchema = CollectionSchema(
  name: r'SleepMinute',
  id: -4069026488443350771,
  properties: {
    r'ahi': PropertySchema(id: 0, name: r'ahi', type: IsarType.long),
    r'breathRate': PropertySchema(
      id: 1,
      name: r'breathRate',
      type: IsarType.long,
    ),
    r'heartRate': PropertySchema(
      id: 2,
      name: r'heartRate',
      type: IsarType.long,
    ),
    r'movement': PropertySchema(id: 3, name: r'movement', type: IsarType.long),
    r'snoring': PropertySchema(id: 4, name: r'snoring', type: IsarType.long),
    r'state': PropertySchema(id: 5, name: r'state', type: IsarType.long),
    r'timestamp': PropertySchema(
      id: 6,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _sleepMinuteEstimateSize,
  serialize: _sleepMinuteSerialize,
  deserialize: _sleepMinuteDeserialize,
  deserializeProp: _sleepMinuteDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _sleepMinuteGetId,
  getLinks: _sleepMinuteGetLinks,
  attach: _sleepMinuteAttach,
  version: '3.3.0',
);

int _sleepMinuteEstimateSize(
  SleepMinute object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sleepMinuteSerialize(
  SleepMinute object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ahi);
  writer.writeLong(offsets[1], object.breathRate);
  writer.writeLong(offsets[2], object.heartRate);
  writer.writeLong(offsets[3], object.movement);
  writer.writeLong(offsets[4], object.snoring);
  writer.writeLong(offsets[5], object.state);
  writer.writeDateTime(offsets[6], object.timestamp);
}

SleepMinute _sleepMinuteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepMinute();
  object.ahi = reader.readLong(offsets[0]);
  object.breathRate = reader.readLong(offsets[1]);
  object.heartRate = reader.readLong(offsets[2]);
  object.id = id;
  object.movement = reader.readLong(offsets[3]);
  object.snoring = reader.readLong(offsets[4]);
  object.state = reader.readLong(offsets[5]);
  object.timestamp = reader.readDateTime(offsets[6]);
  return object;
}

P _sleepMinuteDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepMinuteGetId(SleepMinute object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepMinuteGetLinks(SleepMinute object) {
  return [];
}

void _sleepMinuteAttach(
  IsarCollection<dynamic> col,
  Id id,
  SleepMinute object,
) {
  object.id = id;
}

extension SleepMinuteQueryWhereSort
    on QueryBuilder<SleepMinute, SleepMinute, QWhere> {
  QueryBuilder<SleepMinute, SleepMinute, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SleepMinuteQueryWhere
    on QueryBuilder<SleepMinute, SleepMinute, QWhereClause> {
  QueryBuilder<SleepMinute, SleepMinute, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<SleepMinute, SleepMinute, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SleepMinuteQueryFilter
    on QueryBuilder<SleepMinute, SleepMinute, QFilterCondition> {
  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> ahiEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ahi', value: value),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> ahiGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ahi',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> ahiLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ahi',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> ahiBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ahi',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  breathRateEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'breathRate', value: value),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  breathRateGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'breathRate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  breathRateLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'breathRate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  breathRateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'breathRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  heartRateEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'heartRate', value: value),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  heartRateGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'heartRate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  heartRateLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'heartRate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  heartRateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'heartRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> movementEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movement', value: value),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  movementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'movement',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  movementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'movement',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> movementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'movement',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> snoringEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'snoring', value: value),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  snoringGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'snoring',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> snoringLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'snoring',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> snoringBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'snoring',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> stateEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'state', value: value),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  stateGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'state',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> stateLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'state',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition> stateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'state',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestamp', value: value),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  timestampGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  timestampLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterFilterCondition>
  timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timestamp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SleepMinuteQueryObject
    on QueryBuilder<SleepMinute, SleepMinute, QFilterCondition> {}

extension SleepMinuteQueryLinks
    on QueryBuilder<SleepMinute, SleepMinute, QFilterCondition> {}

extension SleepMinuteQuerySortBy
    on QueryBuilder<SleepMinute, SleepMinute, QSortBy> {
  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByAhiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByBreathRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathRate', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByBreathRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathRate', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartRate', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByHeartRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartRate', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByMovement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movement', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByMovementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movement', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortBySnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoring', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortBySnoringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoring', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension SleepMinuteQuerySortThenBy
    on QueryBuilder<SleepMinute, SleepMinute, QSortThenBy> {
  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByAhiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByBreathRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathRate', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByBreathRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathRate', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartRate', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByHeartRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartRate', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByMovement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movement', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByMovementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movement', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenBySnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoring', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenBySnoringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoring', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension SleepMinuteQueryWhereDistinct
    on QueryBuilder<SleepMinute, SleepMinute, QDistinct> {
  QueryBuilder<SleepMinute, SleepMinute, QDistinct> distinctByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ahi');
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QDistinct> distinctByBreathRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breathRate');
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QDistinct> distinctByHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heartRate');
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QDistinct> distinctByMovement() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movement');
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QDistinct> distinctBySnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoring');
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QDistinct> distinctByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state');
    });
  }

  QueryBuilder<SleepMinute, SleepMinute, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension SleepMinuteQueryProperty
    on QueryBuilder<SleepMinute, SleepMinute, QQueryProperty> {
  QueryBuilder<SleepMinute, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepMinute, int, QQueryOperations> ahiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ahi');
    });
  }

  QueryBuilder<SleepMinute, int, QQueryOperations> breathRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breathRate');
    });
  }

  QueryBuilder<SleepMinute, int, QQueryOperations> heartRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heartRate');
    });
  }

  QueryBuilder<SleepMinute, int, QQueryOperations> movementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movement');
    });
  }

  QueryBuilder<SleepMinute, int, QQueryOperations> snoringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoring');
    });
  }

  QueryBuilder<SleepMinute, int, QQueryOperations> stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<SleepMinute, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
