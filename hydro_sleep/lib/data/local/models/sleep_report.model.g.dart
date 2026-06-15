// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_report.model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepReportCollection on Isar {
  IsarCollection<SleepReport> get sleepReports => this.collection();
}

const SleepReportSchema = CollectionSchema(
  name: r'SleepReport',
  id: -602473489360408529,
  properties: {
    r'ahi': PropertySchema(id: 0, name: r'ahi', type: IsarType.long),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'efficiency': PropertySchema(
      id: 2,
      name: r'efficiency',
      type: IsarType.double,
    ),
    r'longestSleepStart': PropertySchema(
      id: 3,
      name: r'longestSleepStart',
      type: IsarType.string,
    ),
    r'outOfBedCount': PropertySchema(
      id: 4,
      name: r'outOfBedCount',
      type: IsarType.long,
    ),
    r'score': PropertySchema(id: 5, name: r'score', type: IsarType.long),
    r'tossCount': PropertySchema(
      id: 6,
      name: r'tossCount',
      type: IsarType.long,
    ),
    r'totalSleepMinutes': PropertySchema(
      id: 7,
      name: r'totalSleepMinutes',
      type: IsarType.long,
    ),
    r'totalSnoring': PropertySchema(
      id: 8,
      name: r'totalSnoring',
      type: IsarType.long,
    ),
  },

  estimateSize: _sleepReportEstimateSize,
  serialize: _sleepReportSerialize,
  deserialize: _sleepReportDeserialize,
  deserializeProp: _sleepReportDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _sleepReportGetId,
  getLinks: _sleepReportGetLinks,
  attach: _sleepReportAttach,
  version: '3.3.0',
);

int _sleepReportEstimateSize(
  SleepReport object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.longestSleepStart.length * 3;
  return bytesCount;
}

void _sleepReportSerialize(
  SleepReport object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ahi);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeDouble(offsets[2], object.efficiency);
  writer.writeString(offsets[3], object.longestSleepStart);
  writer.writeLong(offsets[4], object.outOfBedCount);
  writer.writeLong(offsets[5], object.score);
  writer.writeLong(offsets[6], object.tossCount);
  writer.writeLong(offsets[7], object.totalSleepMinutes);
  writer.writeLong(offsets[8], object.totalSnoring);
}

SleepReport _sleepReportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepReport();
  object.ahi = reader.readLong(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.efficiency = reader.readDouble(offsets[2]);
  object.id = id;
  object.longestSleepStart = reader.readString(offsets[3]);
  object.outOfBedCount = reader.readLong(offsets[4]);
  object.score = reader.readLong(offsets[5]);
  object.tossCount = reader.readLong(offsets[6]);
  object.totalSleepMinutes = reader.readLong(offsets[7]);
  object.totalSnoring = reader.readLong(offsets[8]);
  return object;
}

P _sleepReportDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepReportGetId(SleepReport object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepReportGetLinks(SleepReport object) {
  return [];
}

void _sleepReportAttach(
  IsarCollection<dynamic> col,
  Id id,
  SleepReport object,
) {
  object.id = id;
}

extension SleepReportQueryWhereSort
    on QueryBuilder<SleepReport, SleepReport, QWhere> {
  QueryBuilder<SleepReport, SleepReport, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension SleepReportQueryWhere
    on QueryBuilder<SleepReport, SleepReport, QWhereClause> {
  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idBetween(
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

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateEqualTo(
    DateTime date,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'date', value: [date]),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateNotEqualTo(
    DateTime date,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [date],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [],
          upper: [date],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [lowerDate],
          includeLower: includeLower,
          upper: [upperDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SleepReportQueryFilter
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {
  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> ahiEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ahi', value: value),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> ahiGreaterThan(
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> ahiLessThan(
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> ahiBetween(
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
  longestSleepStartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'longestSleepStart', value: ''),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
  longestSleepStartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'longestSleepStart', value: ''),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
  outOfBedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'outOfBedCount', value: value),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> scoreEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'score', value: value),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> scoreLessThan(
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> scoreBetween(
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
  tossCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tossCount', value: value),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
  totalSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalSleepMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
  totalSnoringEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalSnoring', value: value),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
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

extension SleepReportQueryObject
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {}

extension SleepReportQueryLinks
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {}

extension SleepReportQuerySortBy
    on QueryBuilder<SleepReport, SleepReport, QSortBy> {
  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByAhiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'efficiency', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByEfficiencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'efficiency', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  sortByLongestSleepStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStart', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  sortByLongestSleepStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStart', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByOutOfBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedCount', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  sortByOutOfBedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedCount', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByTossCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tossCount', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByTossCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tossCount', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  sortByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  sortByTotalSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByTotalSnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSnoring', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  sortByTotalSnoringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSnoring', Sort.desc);
    });
  }
}

extension SleepReportQuerySortThenBy
    on QueryBuilder<SleepReport, SleepReport, QSortThenBy> {
  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByAhiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ahi', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'efficiency', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByEfficiencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'efficiency', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  thenByLongestSleepStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStart', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  thenByLongestSleepStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestSleepStart', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByOutOfBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedCount', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  thenByOutOfBedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outOfBedCount', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByTossCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tossCount', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByTossCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tossCount', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  thenByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  thenByTotalSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByTotalSnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSnoring', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
  thenByTotalSnoringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSnoring', Sort.desc);
    });
  }
}

extension SleepReportQueryWhereDistinct
    on QueryBuilder<SleepReport, SleepReport, QDistinct> {
  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByAhi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ahi');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByEfficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'efficiency');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
  distinctByLongestSleepStart({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'longestSleepStart',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByOutOfBedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outOfBedCount');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByTossCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tossCount');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
  distinctByTotalSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByTotalSnoring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSnoring');
    });
  }
}

extension SleepReportQueryProperty
    on QueryBuilder<SleepReport, SleepReport, QQueryProperty> {
  QueryBuilder<SleepReport, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> ahiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ahi');
    });
  }

  QueryBuilder<SleepReport, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SleepReport, double, QQueryOperations> efficiencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'efficiency');
    });
  }

  QueryBuilder<SleepReport, String, QQueryOperations>
  longestSleepStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestSleepStart');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> outOfBedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outOfBedCount');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> tossCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tossCount');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> totalSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> totalSnoringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSnoring');
    });
  }
}
