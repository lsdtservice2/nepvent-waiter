class TokenModel {
  final int tokenId;
  final String numberOfPeople;
  final double amount;
  final String tokenNumber;
  final String date;
  final bool isClaimable;
  final String type;

  TokenModel({
    required this.numberOfPeople,
    required this.amount,
    required this.tokenNumber,
    required this.tokenId,
    required this.date,
    required this.isClaimable,
    required this.type,
  });
}
