// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_session.model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepSessionCollection on Isar {
  IsarCollection<SleepSession> get sleepSessions => this.collection();
}

const SleepSessionSchema = CollectionSchema(
  name: r'SleepSession',
  id: 1960440604736288964,
  properties: {
    r'ahi': PropertySchema(id: 0, name: r'ahi', type: IsarType.long),
    r'awakeMinutes': PropertySchema(
      id: 1,
      name: r'awakeMinutes',
      type: IsarType.long,
    ),
    r'deepSleepMinutes': PropertySchema(
      id: 2,
      name: r'deepSleepMinutes',
      type: IsarType.long,
    ),
    r'efficiency': PropertySchema(
      id: 3,
      name: r'efficiency',
      type: IsarType.double,
    ),
    r'endTime': PropertySchema(
      id: 4,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'lightSleepMinutes': PropertySchema(
      id: 5,
      name: r'lightSleepMinutes',
      type: IsarType.long,
    ),
    r'longestSleepStart': PropertySchema(
      id: 6,
      name: r'longestSleepStart',
      type: IsarType.string,
    ),
    r'outOfBedCount': PropertySchema(
      id: 7,
      name: r'outOfBedCount',
      type: IsarType.long,
    ),
    r'outOfBedMinutes': PropertySchema(
      id: 8,
      name: r'outOfBedMinutes',
      type: IsarType.long,
    ),
    r'remSleepMinutes': PropertySchema(
      id: 9,
      name: r'remSleepMinutes',
      type: IsarType.long,
    ),
    r'score': PropertySchema(id: 10, name: r'score', type: IsarType.long),
    r'startTime': PropertySchema(
      id: 11,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'tossCount': PropertySchema(
      id: 12,
      name: r'tossCount',
      type: IsarType.long,
    ),
    r'totalSleepMinutes': PropertySchema(
      id: 13,
      name: r'totalSleepMinutes',
      type: IsarType.long,
    ),
    r'totalSnoring': PropertySchema(
      id: 14,
      name: r'totalSnoring',
      type: IsarType.long,
    ),
  },

  estimateSize: _sleepSessionEstimateSize,
  serialize: _sleepSessionSerialize,
  deserialize: _sleepSessionDeserialize,
  deserializeProp: _sleepSessionDeserializeProp,
  idName: r'id',
  indexes: {
    r'startTime': IndexSchema(
      id: -3870335341264752872,
      name: r'startTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startTime',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _sleepSessionGetId,
  getLinks: _sleepSessionGetLinks,
  attach: _sleepSessionAttach,
  version: '3.3.0',
);

int _sleepSessionEstimateSize(
  SleepSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.longestSleepStart.length * 3;
  return bytesCount;
}

void _sleepSessionSerialize(
  SleepSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ahi);
  writer.writeLong(offsets[1], object.awakeMinutes);
  writer.writeLong(offsets[2], object.deepSleepMinutes);
  writer.writeDouble(offsets[3], object.efficiency);
  writer.writeDateTime(offsets[4], object.endTime);
  writer.writeLong(offsets[5], object.lightSleepMinutes);
  writer.writeString(offsets[6], object.longestSleepStart);
  writer.writeLong(offsets[7], object.outOfBedCount);
  writer.writeLong(offsets[8], object.outOfBedMinutes);
  writer.writeLong(offsets[9], object.remSleepMinutes);
  writer.writeLong(offsets[10], object.score);
  writer.writeDateTime(offsets[11], object.startTime);
  writer.writeLong(offsets[12], object.tossCount);
  writer.writeLong(offsets[13], object.totalSleepMinutes);
  writer.writeLong(offsets[14], object.totalSnoring);
}

SleepSession _sleepSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepSession();
  object.ahi = reader.readLong(offsets[0]);
  object.awakeMinutes = reader.readLong(offsets[1]);
  object.deepSleepMinutes = reader.readLong(offsets[2]);
  object.efficiency = reader.readDouble(offsets[3]);
  object.endTime = reader.readDateTime(offsets[4]);
  object.id = id;
  object.lightSleepMinutes = reader.readLong(offsets[5]);
  object.longestSleepStart = reader.readString(offsets[6]);
  object.outOfBedCount = reader.readLong(offsets[7]);
  object.outOfBedMinutes = reader.readLong(offsets[8]);
  object.remSleepMinutes = reader.readLong(offsets[9]);
  object.score = reader.readLong(offsets[10]);
  object.startTime = reader.readDateTime(offsets[11]);
  object.tossCount = reader.readLong(offsets[12]);
  object.totalSleepMinutes = reader.readLong(offsets[13]);
  object.totalSnoring = reader.readLong(offsets[14]);
  return object;
}

P _sleepSessionDeserializeProp<P>(
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
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepSessionGetId(SleepSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepSessionGetLinks(SleepSession object) {
  return [];
}

void _sleepSessionAttach(
  IsarCollection<dynamic> col,
  Id id,
  SleepSession object,
) {
  object.id = id;
}

extension SleepSessionQueryWhereSort
    on QueryBuilder<SleepSession, SleepSession, QWhere> {
  QueryBuilder<SleepSession, SleepSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterWhere> anyStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startTime'),
      );
    });
  }
}

extension SleepSessionQueryWhere
    on QueryBuilder<SleepSession, SleepSession, QWhereClause> {
  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause> idBetween(
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

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause> startTimeEqualTo(
    DateTime startTime,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'startTime', value: [startTime]),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause>
  startTimeNotEqualTo(DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startTime',
                lower: [],
                upper: [startTime],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startTime',
                lower: [startTime],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startTime',
                lower: [startTime],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startTime',
                lower: [],
                upper: [startTime],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause>
  startTimeGreaterThan(DateTime startTime, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startTime',
          lower: [startTime],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause> startTimeLessThan(
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startTime',
          lower: [],
          upper: [startTime],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterWhereClause> startTimeBetween(
    DateTime lowerStartTime,
    DateTime upperStartTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startTime',
          lower: [lowerStartTime],
          includeLower: includeLower,
          upper: [upperStartTime],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SleepSessionQueryFilter
    on QueryBuilder<SleepSession, SleepSession, QFilterCondition> {
  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> ahiEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ahi', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  ahiGreaterThan(int value, {bool include = false}) {
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

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> ahiLessThan(
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

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> ahiBetween(
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

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  awakeMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'awakeMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  awakeMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'awakeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  awakeMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'awakeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  awakeMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'awakeMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  deepSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deepSleepMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  deepSleepMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deepSleepMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  deepSleepMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deepSleepMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  deepSleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deepSleepMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  efficiencyEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'efficiency',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  efficiencyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'efficiency',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  efficiencyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'efficiency',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  efficiencyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'efficiency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  endTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endTime', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  endTimeGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  endTimeLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  endTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  lightSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lightSleepMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  lightSleepMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lightSleepMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  lightSleepMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lightSleepMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  lightSleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lightSleepMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'longestSleepStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longestSleepStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longestSleepStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longestSleepStart',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'longestSleepStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'longestSleepStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'longestSleepStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'longestSleepStart',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'longestSleepStart', value: ''),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  longestSleepStartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'longestSleepStart', value: ''),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  outOfBedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'outOfBedCount', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  outOfBedCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'outOfBedCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  outOfBedCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'outOfBedCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  outOfBedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'outOfBedCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  outOfBedMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'outOfBedMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  outOfBedMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'outOfBedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  outOfBedMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'outOfBedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  outOfBedMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'outOfBedMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  remSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remSleepMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  remSleepMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remSleepMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  remSleepMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remSleepMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  remSleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remSleepMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> scoreEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'score', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  scoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> scoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition> scoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'score',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startTime', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  startTimeGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  startTimeLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  tossCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tossCount', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  tossCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tossCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  tossCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tossCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  tossCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tossCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  totalSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalSleepMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  totalSleepMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalSleepMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  totalSleepMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalSleepMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  totalSleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalSleepMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  totalSnoringEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalSnoring', value: value),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  totalSnoringGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalSnoring',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  totalSnoringLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalSnoring',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterFilterCondition>
  totalSnoringBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalSnoring',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SleepSessionQueryObject
    on QueryBuilder<SleepSession, SleepSession, QFilterCondition> {}

extension SleepSessionQueryLinks
    on QueryBuilder<SleepSession, SleepSession, QFilterCondition> {}

extension SleepSessionQuerySortBy
    on QueryBuilder<SleepSession, SleepSession, QSortBy> {
  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByAhiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByAwakeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awakeMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByAwakeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awakeMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByDeepSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByDeepSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'efficiency', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByEfficiencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'efficiency', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByLightSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lightSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByLightSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lightSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByLongestSleepStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStart', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByLongestSleepStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStart', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByOutOfBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedCount', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByOutOfBedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedCount', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByOutOfBedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByOutOfBedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByRemSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByRemSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByTossCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tossCount', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByTossCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tossCount', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByTotalSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> sortByTotalSnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSnoring', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  sortByTotalSnoringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSnoring', Sort.desc);
    });
  }
}

extension SleepSessionQuerySortThenBy
    on QueryBuilder<SleepSession, SleepSession, QSortThenBy> {
  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByAhiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByAwakeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awakeMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByAwakeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awakeMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByDeepSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByDeepSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'efficiency', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByEfficiencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'efficiency', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByLightSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lightSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByLightSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lightSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByLongestSleepStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStart', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByLongestSleepStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStart', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByOutOfBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedCount', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByOutOfBedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedCount', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByOutOfBedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByOutOfBedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByRemSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByRemSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByTossCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tossCount', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByTossCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tossCount', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByTotalSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy> thenByTotalSnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSnoring', Sort.asc);
    });
  }

  QueryBuilder<SleepSession, SleepSession, QAfterSortBy>
  thenByTotalSnoringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSnoring', Sort.desc);
    });
  }
}

extension SleepSessionQueryWhereDistinct
    on QueryBuilder<SleepSession, SleepSession, QDistinct> {
  QueryBuilder<SleepSession, SleepSession, QDistinct> distinctByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ahi');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct> distinctByAwakeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'awakeMinutes');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct>
  distinctByDeepSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deepSleepMinutes');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct> distinctByEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'efficiency');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct>
  distinctByLightSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lightSleepMinutes');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct>
  distinctByLongestSleepStart({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'longestSleepStart',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct>
  distinctByOutOfBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outOfBedCount');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct>
  distinctByOutOfBedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outOfBedMinutes');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct>
  distinctByRemSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remSleepMinutes');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct> distinctByTossCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tossCount');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct>
  distinctByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSleepMinutes');
    });
  }

  QueryBuilder<SleepSession, SleepSession, QDistinct> distinctByTotalSnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSnoring');
    });
  }
}

extension SleepSessionQueryProperty
    on QueryBuilder<SleepSession, SleepSession, QQueryProperty> {
  QueryBuilder<SleepSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> ahiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ahi');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> awakeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'awakeMinutes');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> deepSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deepSleepMinutes');
    });
  }

  QueryBuilder<SleepSession, double, QQueryOperations> efficiencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'efficiency');
    });
  }

  QueryBuilder<SleepSession, DateTime, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations>
  lightSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lightSleepMinutes');
    });
  }

  QueryBuilder<SleepSession, String, QQueryOperations>
  longestSleepStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestSleepStart');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> outOfBedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outOfBedCount');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> outOfBedMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outOfBedMinutes');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> remSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remSleepMinutes');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<SleepSession, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> tossCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tossCount');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations>
  totalSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSleepMinutes');
    });
  }

  QueryBuilder<SleepSession, int, QQueryOperations> totalSnoringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSnoring');
    });
  }
}
