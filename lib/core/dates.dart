/// `yyyy-MM-dd` for the device's local calendar date, as stored in Postgres
/// `date` columns (`started_at`, `finished_at`, `local_date`).
String localDateString(DateTime local) =>
    '${local.year.toString().padLeft(4, '0')}-'
    '${local.month.toString().padLeft(2, '0')}-'
    '${local.day.toString().padLeft(2, '0')}';
