enum TransactionType {
  transaction,
  reward,

}
/// TransactionTypes
///
/// TransactionType.transaction
/// {
///   "from_address": "frompublickey",
///   "to_address": "topublickey",
///   "signature": "sendersignature",
///   "amount": 10000,
///   "timestamp": 111111111111
/// }
///
/// TransactionType.reward
/// {
///   "from_address": "path/to/pull/request",
///   "to_address": "topublickey",
///   "amount": 100,
///   "timestamp": "closed_at"
/// }