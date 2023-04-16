class Quote {
  final String author;
  final String quote;
  final List<String> tags;
  final String email;
  final dynamic createdAt;
  final int likes;
  final String quoteId;

  Quote({
    required this.author,
    required this.quote,
    required this.tags,
    required this.email,
    required this.createdAt,
    required this.likes,
    required this.quoteId,
  });
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      author: map['author'],
      quote: map['quote'],
      tags: List<String>.from(map['tags']),
      email: map['email'],
      createdAt: map['createdAt'],
      likes: map['likes'],
      quoteId: map['quoteId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'quote': quote,
      'tags': tags,
      'email': email,
      'createdAt': createdAt,
      'likes': likes,
      'quoteId': quoteId,
    };
  }
}
