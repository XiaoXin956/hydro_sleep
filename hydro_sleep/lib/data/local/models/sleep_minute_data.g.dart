// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_minute_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepMinuteDataCollection on Isar {
  IsarCollection<SleepMinuteData> get sleepMinuteDatas => this.collection();
}

const SleepMinuteDataSchema = CollectionSchema(
  name: r'SleepMinuteData',
  id: 4864408081101420139,
  properties: {
    r'bodyMove': PropertySchema(id: 0, name: r'bodyMove', type: IsarType.long),
    r'breathRate': PropertySchema(
      id: 1,
      name: r'breathRate',
      type: IsarType.long,
    ),
    r'deviceId': PropertySchema(
      id: 2,
      name: r'deviceId',
      type: IsarType.string,
    ),
    r'heartRate': PropertySchema(
      id: 3,
      name: r'heartRate',
      type: IsarType.long,
    ),
    r'status': PropertySchema(id: 4, name: r'status', type: IsarType.long),
    r'timestamp': PropertySchema(
      id: 5,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _sleepMinuteDataEstimateSize,
  serialize: _sleepMinuteDataSerialize,
  deserialize: _sleepMinuteDataDeserialize,
  deserializeProp: _sleepMinuteDataDeserializeProp,
  idName: r'id',
  indexes: {
    r'deviceId_timestamp': IndexSchema(
      id: 1155166206812509609,
      name: r'deviceId_timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deviceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _sleepMinuteDataGetId,
  getLinks: _sleepMinuteDataGetLinks,
  attach: _sleepMinuteDataAttach,
  version: '3.3.0',
);

int _sleepMinuteDataEstimateSize(
  SleepMinuteData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deviceId.length * 3;
  return bytesCount;
}

void _sleepMinuteDataSerialize(
  SleepMinuteData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bodyMove);
  writer.writeLong(offsets[1], object.breathRate);
  writer.writeString(offsets[2], object.deviceId);
  writer.writeLong(offsets[3], object.heartRate);
  writer.writeLong(offsets[4], object.status);
  writer.writeDateTime(offsets[5], object.timestamp);
}

SleepMinuteData _sleepMinuteDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepMinuteData();
  object.bodyMove = reader.readLong(offsets[0]);
  object.breathRate = reader.readLong(offsets[1]);
  object.deviceId = reader.readString(offsets[2]);
  object.heartRate = reader.readLong(offsets[3]);
  object.id = id;
  object.status = reader.readLong(offsets[4]);
  object.timestamp = reader.readDateTime(offsets[5]);
  return object;
}

P _sleepMinuteDataDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepMinuteDataGetId(SleepMinuteData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepMinuteDataGetLinks(SleepMinuteData object) {
  return [];
}

void _sleepMinuteDataAttach(
  IsarCollection<dynamic> col,
  Id id,
  SleepMinuteData object,
) {
  object.id = id;
}

extension SleepMinuteDataQueryWhereSort
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QWhere> {
  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension SleepMinuteDataQueryWhere
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QWhereClause> {
  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause> idBetween(
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  deviceIdEqualToAnyTimestamp(String deviceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'deviceId_timestamp',
          value: [deviceId],
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  deviceIdNotEqualToAnyTimestamp(String deviceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_timestamp',
                lower: [],
                upper: [deviceId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_timestamp',
                lower: [deviceId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_timestamp',
                lower: [deviceId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_timestamp',
                lower: [],
                upper: [deviceId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  deviceIdTimestampEqualTo(String deviceId, DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'deviceId_timestamp',
          value: [deviceId, timestamp],
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  deviceIdEqualToTimestampNotEqualTo(String deviceId, DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_timestamp',
                lower: [deviceId],
                upper: [deviceId, timestamp],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_timestamp',
                lower: [deviceId, timestamp],
                includeLower: false,
                upper: [deviceId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_timestamp',
                lower: [deviceId, timestamp],
                includeLower: false,
                upper: [deviceId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_timestamp',
                lower: [deviceId],
                upper: [deviceId, timestamp],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  deviceIdEqualToTimestampGreaterThan(
    String deviceId,
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deviceId_timestamp',
          lower: [deviceId, timestamp],
          includeLower: include,
          upper: [deviceId],
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  deviceIdEqualToTimestampLessThan(
    String deviceId,
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deviceId_timestamp',
          lower: [deviceId],
          upper: [deviceId, timestamp],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  deviceIdEqualToTimestampBetween(
    String deviceId,
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deviceId_timestamp',
          lower: [deviceId, lowerTimestamp],
          includeLower: includeLower,
          upper: [deviceId, upperTimestamp],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  timestampEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'timestamp', value: [timestamp]),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  timestampNotEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [],
                upper: [timestamp],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [timestamp],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [timestamp],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [],
                upper: [timestamp],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  timestampGreaterThan(DateTime timestamp, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [timestamp],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  timestampLessThan(DateTime timestamp, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [],
          upper: [timestamp],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterWhereClause>
  timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [lowerTimestamp],
          includeLower: includeLower,
          upper: [upperTimestamp],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SleepMinuteDataQueryFilter
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QFilterCondition> {
  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  bodyMoveEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bodyMove', value: value),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  bodyMoveGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bodyMove',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  bodyMoveLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bodyMove',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  bodyMoveBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bodyMove',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  breathRateEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'breathRate', value: value),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deviceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'deviceId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deviceId', value: ''),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'deviceId', value: ''),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  heartRateEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'heartRate', value: value),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  statusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  statusGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  statusLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  statusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
  timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestamp', value: value),
      );
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterFilterCondition>
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

extension SleepMinuteDataQueryObject
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QFilterCondition> {}

extension SleepMinuteDataQueryLinks
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QFilterCondition> {}

extension SleepMinuteDataQuerySortBy
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QSortBy> {
  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByBodyMove() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyMove', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByBodyMoveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyMove', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByBreathRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathRate', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByBreathRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathRate', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartRate', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByHeartRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartRate', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension SleepMinuteDataQuerySortThenBy
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QSortThenBy> {
  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByBodyMove() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyMove', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByBodyMoveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyMove', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByBreathRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathRate', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByBreathRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathRate', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartRate', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByHeartRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heartRate', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QAfterSortBy>
  thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension SleepMinuteDataQueryWhereDistinct
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QDistinct> {
  QueryBuilder<SleepMinuteData, SleepMinuteData, QDistinct>
  distinctByBodyMove() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bodyMove');
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QDistinct>
  distinctByBreathRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breathRate');
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QDistinct> distinctByDeviceId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QDistinct>
  distinctByHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heartRate');
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<SleepMinuteData, SleepMinuteData, QDistinct>
  distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension SleepMinuteDataQueryProperty
    on QueryBuilder<SleepMinuteData, SleepMinuteData, QQueryProperty> {
  QueryBuilder<SleepMinuteData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepMinuteData, int, QQueryOperations> bodyMoveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bodyMove');
    });
  }

  QueryBuilder<SleepMinuteData, int, QQueryOperations> breathRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breathRate');
    });
  }

  QueryBuilder<SleepMinuteData, String, QQueryOperations> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceId');
    });
  }

  QueryBuilder<SleepMinuteData, int, QQueryOperations> heartRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heartRate');
    });
  }

  QueryBuilder<SleepMinuteData, int, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SleepMinuteData, DateTime, QQueryOperations>
  timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
