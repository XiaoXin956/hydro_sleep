// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_summary_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReportSummaryRecordCollection on Isar {
  IsarCollection<ReportSummaryRecord> get reportSummaryRecords =>
      this.collection();
}

const ReportSummaryRecordSchema = CollectionSchema(
  name: r'ReportSummaryRecord',
  id: 6854973683065511982,
  properties: {
    r'ahiIndex': PropertySchema(id: 0, name: r'ahiIndex', type: IsarType.long),
    r'asciiId': PropertySchema(id: 1, name: r'asciiId', type: IsarType.string),
    r'dataLoaded': PropertySchema(
      id: 2,
      name: r'dataLoaded',
      type: IsarType.bool,
    ),
    r'deviceId': PropertySchema(
      id: 3,
      name: r'deviceId',
      type: IsarType.string,
    ),
    r'leaveBedCount': PropertySchema(
      id: 4,
      name: r'leaveBedCount',
      type: IsarType.long,
    ),
    r'longestSleepStartMinute': PropertySchema(
      id: 5,
      name: r'longestSleepStartMinute',
      type: IsarType.long,
    ),
    r'reserved1': PropertySchema(
      id: 6,
      name: r'reserved1',
      type: IsarType.long,
    ),
    r'sleepEfficiency': PropertySchema(
      id: 7,
      name: r'sleepEfficiency',
      type: IsarType.long,
    ),
    r'sleepLatencyMinutes': PropertySchema(
      id: 8,
      name: r'sleepLatencyMinutes',
      type: IsarType.long,
    ),
    r'sleepQuality': PropertySchema(
      id: 9,
      name: r'sleepQuality',
      type: IsarType.long,
    ),
    r'sleepRhythmPhase': PropertySchema(
      id: 10,
      name: r'sleepRhythmPhase',
      type: IsarType.long,
    ),
    r'snoreTotalCount': PropertySchema(
      id: 11,
      name: r'snoreTotalCount',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 12,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'syncedAt': PropertySchema(
      id: 13,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
    r'totalSleepMinutes': PropertySchema(
      id: 14,
      name: r'totalSleepMinutes',
      type: IsarType.long,
    ),
    r'turnOverCount': PropertySchema(
      id: 15,
      name: r'turnOverCount',
      type: IsarType.long,
    ),
  },

  estimateSize: _reportSummaryRecordEstimateSize,
  serialize: _reportSummaryRecordSerialize,
  deserialize: _reportSummaryRecordDeserialize,
  deserializeProp: _reportSummaryRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'deviceId_startTime': IndexSchema(
      id: 6545542442000451248,
      name: r'deviceId_startTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deviceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'startTime',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
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

  getId: _reportSummaryRecordGetId,
  getLinks: _reportSummaryRecordGetLinks,
  attach: _reportSummaryRecordAttach,
  version: '3.3.0',
);

int _reportSummaryRecordEstimateSize(
  ReportSummaryRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.asciiId.length * 3;
  bytesCount += 3 + object.deviceId.length * 3;
  return bytesCount;
}

void _reportSummaryRecordSerialize(
  ReportSummaryRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ahiIndex);
  writer.writeString(offsets[1], object.asciiId);
  writer.writeBool(offsets[2], object.dataLoaded);
  writer.writeString(offsets[3], object.deviceId);
  writer.writeLong(offsets[4], object.leaveBedCount);
  writer.writeLong(offsets[5], object.longestSleepStartMinute);
  writer.writeLong(offsets[6], object.reserved1);
  writer.writeLong(offsets[7], object.sleepEfficiency);
  writer.writeLong(offsets[8], object.sleepLatencyMinutes);
  writer.writeLong(offsets[9], object.sleepQuality);
  writer.writeLong(offsets[10], object.sleepRhythmPhase);
  writer.writeLong(offsets[11], object.snoreTotalCount);
  writer.writeDateTime(offsets[12], object.startTime);
  writer.writeDateTime(offsets[13], object.syncedAt);
  writer.writeLong(offsets[14], object.totalSleepMinutes);
  writer.writeLong(offsets[15], object.turnOverCount);
}

ReportSummaryRecord _reportSummaryRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReportSummaryRecord();
  object.ahiIndex = reader.readLong(offsets[0]);
  object.asciiId = reader.readString(offsets[1]);
  object.dataLoaded = reader.readBool(offsets[2]);
  object.deviceId = reader.readString(offsets[3]);
  object.id = id;
  object.leaveBedCount = reader.readLong(offsets[4]);
  object.longestSleepStartMinute = reader.readLong(offsets[5]);
  object.reserved1 = reader.readLong(offsets[6]);
  object.sleepEfficiency = reader.readLong(offsets[7]);
  object.sleepLatencyMinutes = reader.readLong(offsets[8]);
  object.sleepQuality = reader.readLong(offsets[9]);
  object.sleepRhythmPhase = reader.readLong(offsets[10]);
  object.snoreTotalCount = reader.readLong(offsets[11]);
  object.startTime = reader.readDateTime(offsets[12]);
  object.syncedAt = reader.readDateTime(offsets[13]);
  object.totalSleepMinutes = reader.readLong(offsets[14]);
  object.turnOverCount = reader.readLong(offsets[15]);
  return object;
}

P _reportSummaryRecordDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reportSummaryRecordGetId(ReportSummaryRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reportSummaryRecordGetLinks(
  ReportSummaryRecord object,
) {
  return [];
}

void _reportSummaryRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  ReportSummaryRecord object,
) {
  object.id = id;
}

extension ReportSummaryRecordQueryWhereSort
    on QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QWhere> {
  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhere>
  anyStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startTime'),
      );
    });
  }
}

extension ReportSummaryRecordQueryWhere
    on QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QWhereClause> {
  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  idBetween(
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  deviceIdEqualToAnyStartTime(String deviceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'deviceId_startTime',
          value: [deviceId],
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  deviceIdNotEqualToAnyStartTime(String deviceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_startTime',
                lower: [],
                upper: [deviceId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_startTime',
                lower: [deviceId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_startTime',
                lower: [deviceId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_startTime',
                lower: [],
                upper: [deviceId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  deviceIdStartTimeEqualTo(String deviceId, DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'deviceId_startTime',
          value: [deviceId, startTime],
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  deviceIdEqualToStartTimeNotEqualTo(String deviceId, DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_startTime',
                lower: [deviceId],
                upper: [deviceId, startTime],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_startTime',
                lower: [deviceId, startTime],
                includeLower: false,
                upper: [deviceId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_startTime',
                lower: [deviceId, startTime],
                includeLower: false,
                upper: [deviceId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId_startTime',
                lower: [deviceId],
                upper: [deviceId, startTime],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  deviceIdEqualToStartTimeGreaterThan(
    String deviceId,
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deviceId_startTime',
          lower: [deviceId, startTime],
          includeLower: include,
          upper: [deviceId],
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  deviceIdEqualToStartTimeLessThan(
    String deviceId,
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deviceId_startTime',
          lower: [deviceId],
          upper: [deviceId, startTime],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  deviceIdEqualToStartTimeBetween(
    String deviceId,
    DateTime lowerStartTime,
    DateTime upperStartTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deviceId_startTime',
          lower: [deviceId, lowerStartTime],
          includeLower: includeLower,
          upper: [deviceId, upperStartTime],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  startTimeEqualTo(DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'startTime', value: [startTime]),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  startTimeLessThan(DateTime startTime, {bool include = false}) {
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterWhereClause>
  startTimeBetween(
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

extension ReportSummaryRecordQueryFilter
    on
        QueryBuilder<
          ReportSummaryRecord,
          ReportSummaryRecord,
          QFilterCondition
        > {
  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  ahiIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ahiIndex', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  ahiIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ahiIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  ahiIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ahiIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  ahiIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ahiIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'asciiId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'asciiId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'asciiId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'asciiId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'asciiId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'asciiId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'asciiId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'asciiId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'asciiId', value: ''),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  asciiIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'asciiId', value: ''),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  dataLoadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dataLoaded', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deviceId', value: ''),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'deviceId', value: ''),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  leaveBedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'leaveBedCount', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  leaveBedCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'leaveBedCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  leaveBedCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'leaveBedCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  leaveBedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'leaveBedCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  longestSleepStartMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'longestSleepStartMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  longestSleepStartMinuteGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longestSleepStartMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  longestSleepStartMinuteLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longestSleepStartMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  longestSleepStartMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longestSleepStartMinute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  reserved1EqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reserved1', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  reserved1GreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reserved1',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  reserved1LessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reserved1',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  reserved1Between(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reserved1',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepEfficiencyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sleepEfficiency', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepEfficiencyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sleepEfficiency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepEfficiencyLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sleepEfficiency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepEfficiencyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sleepEfficiency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepLatencyMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sleepLatencyMinutes', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepLatencyMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sleepLatencyMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepLatencyMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sleepLatencyMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepLatencyMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sleepLatencyMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepQualityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sleepQuality', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepQualityGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sleepQuality',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepQualityLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sleepQuality',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepQualityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sleepQuality',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepRhythmPhaseEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sleepRhythmPhase', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepRhythmPhaseGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sleepRhythmPhase',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepRhythmPhaseLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sleepRhythmPhase',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  sleepRhythmPhaseBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sleepRhythmPhase',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  snoreTotalCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'snoreTotalCount', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  snoreTotalCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'snoreTotalCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  snoreTotalCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'snoreTotalCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  snoreTotalCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'snoreTotalCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startTime', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  syncedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncedAt', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  syncedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  syncedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  syncedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  totalSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalSleepMinutes', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
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

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  turnOverCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'turnOverCount', value: value),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  turnOverCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'turnOverCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  turnOverCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'turnOverCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterFilterCondition>
  turnOverCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'turnOverCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ReportSummaryRecordQueryObject
    on
        QueryBuilder<
          ReportSummaryRecord,
          ReportSummaryRecord,
          QFilterCondition
        > {}

extension ReportSummaryRecordQueryLinks
    on
        QueryBuilder<
          ReportSummaryRecord,
          ReportSummaryRecord,
          QFilterCondition
        > {}

extension ReportSummaryRecordQuerySortBy
    on QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QSortBy> {
  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByAhiIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahiIndex', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByAhiIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahiIndex', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByAsciiId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asciiId', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByAsciiIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asciiId', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByDataLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataLoaded', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByDataLoadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataLoaded', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByLeaveBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveBedCount', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByLeaveBedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveBedCount', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByLongestSleepStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStartMinute', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByLongestSleepStartMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStartMinute', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByReserved1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reserved1', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByReserved1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reserved1', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySleepEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepEfficiency', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySleepEfficiencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepEfficiency', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySleepLatencyMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepLatencyMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySleepLatencyMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepLatencyMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySleepQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepQuality', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySleepQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepQuality', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySleepRhythmPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepRhythmPhase', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySleepRhythmPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepRhythmPhase', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySnoreTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoreTotalCount', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySnoreTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoreTotalCount', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByTotalSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByTurnOverCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'turnOverCount', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  sortByTurnOverCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'turnOverCount', Sort.desc);
    });
  }
}

extension ReportSummaryRecordQuerySortThenBy
    on QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QSortThenBy> {
  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByAhiIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahiIndex', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByAhiIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahiIndex', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByAsciiId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asciiId', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByAsciiIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asciiId', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByDataLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataLoaded', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByDataLoadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataLoaded', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByLeaveBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveBedCount', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByLeaveBedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveBedCount', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByLongestSleepStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStartMinute', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByLongestSleepStartMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStartMinute', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByReserved1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reserved1', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByReserved1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reserved1', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySleepEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepEfficiency', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySleepEfficiencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepEfficiency', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySleepLatencyMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepLatencyMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySleepLatencyMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepLatencyMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySleepQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepQuality', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySleepQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepQuality', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySleepRhythmPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepRhythmPhase', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySleepRhythmPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepRhythmPhase', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySnoreTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoreTotalCount', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySnoreTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoreTotalCount', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByTotalSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByTurnOverCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'turnOverCount', Sort.asc);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QAfterSortBy>
  thenByTurnOverCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'turnOverCount', Sort.desc);
    });
  }
}

extension ReportSummaryRecordQueryWhereDistinct
    on QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct> {
  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByAhiIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ahiIndex');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByAsciiId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'asciiId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByDataLoaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataLoaded');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByDeviceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByLeaveBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leaveBedCount');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByLongestSleepStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longestSleepStartMinute');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByReserved1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reserved1');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctBySleepEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepEfficiency');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctBySleepLatencyMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepLatencyMinutes');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctBySleepQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepQuality');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctBySleepRhythmPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepRhythmPhase');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctBySnoreTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoreTotalCount');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSleepMinutes');
    });
  }

  QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QDistinct>
  distinctByTurnOverCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'turnOverCount');
    });
  }
}

extension ReportSummaryRecordQueryProperty
    on QueryBuilder<ReportSummaryRecord, ReportSummaryRecord, QQueryProperty> {
  QueryBuilder<ReportSummaryRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations> ahiIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ahiIndex');
    });
  }

  QueryBuilder<ReportSummaryRecord, String, QQueryOperations>
  asciiIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'asciiId');
    });
  }

  QueryBuilder<ReportSummaryRecord, bool, QQueryOperations>
  dataLoadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataLoaded');
    });
  }

  QueryBuilder<ReportSummaryRecord, String, QQueryOperations>
  deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceId');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  leaveBedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leaveBedCount');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  longestSleepStartMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestSleepStartMinute');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations> reserved1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reserved1');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  sleepEfficiencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepEfficiency');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  sleepLatencyMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepLatencyMinutes');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  sleepQualityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepQuality');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  sleepRhythmPhaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepRhythmPhase');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  snoreTotalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoreTotalCount');
    });
  }

  QueryBuilder<ReportSummaryRecord, DateTime, QQueryOperations>
  startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<ReportSummaryRecord, DateTime, QQueryOperations>
  syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  totalSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSleepMinutes');
    });
  }

  QueryBuilder<ReportSummaryRecord, int, QQueryOperations>
  turnOverCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'turnOverCount');
    });
  }
}
