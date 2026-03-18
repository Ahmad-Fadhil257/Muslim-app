/// Data class for inspirational quotes
class Quote {
  final String id;
  final String text; // Indonesian/English text
  final String arabic; // Arabic text
  final String source; // Source/reference
  final QuoteCategory category;

  const Quote({
    required this.id,
    required this.text,
    required this.arabic,
    required this.source,
    required this.category,
  });
}

/// Categories for quotes
enum QuoteCategory {
  menuntutIlmu, // Seeking religious knowledge
  beribadah, // Worship and devotion
  berbaktiLingkungan, // Environmental stewardship
  berbaktiKeluarga, // Family devotion
}

/// 10 inspirational quotes covering four themes
final List<Quote> inspirationalQuotes = [
  // Seeking Religious Knowledge (3 quotes)
  Quote(
    id: '1',
    text:
        'Orang yang menuntut ilmu adalah orang yang paling dekat dengan Allah',
    arabic: 'طَلَبُ الْعِلْمِ فَرِيضَةٌ',
    source: 'HR. Bukhari',
    category: QuoteCategory.menuntutIlmu,
  ),
  Quote(
    id: '2',
    text: 'Bertakwalah kepada Allah dan Allah akan memberikan ilmu kepada kamu',
    arabic: 'وَاتَّقُوا اللَّهَ وَيُعَلِّمُكُمُ اللَّهُ',
    source: 'QS. Al-Baqarah: 282',
    category: QuoteCategory.menuntutIlmu,
  ),
  Quote(
    id: '3',
    text: 'Carilah ilmu dari lahir hingga liang lahat',
    arabic: 'اِطْلُبُ الْعِلْمَ مِنَ الْمَهْدِ إِلَى اللَّهْدِ',
    source: 'HR. Ibn Majah',
    category: QuoteCategory.menuntutIlmu,
  ),
  // Worship and Devotion (3 quotes)
  Quote(
    id: '4',
    text: 'Beribadahlah kepada Allah dengan penuh ketundukan dan harapan',
    arabic: 'اعْبُدُوا اللَّهَ مُخْلِصِينَ لَهُ الدِّينَ',
    source: 'QS. Al-Bayyinah: 5',
    category: QuoteCategory.beribadah,
  ),
  Quote(
    id: '5',
    text: 'Sesungguhnya Allah mencintai hamba yang merasa diawasi',
    arabic: 'إِنَّ اللَّهَ يُحِبُّ مَنْ يَعْبُدُهُ',
    source: 'HR. Muslim',
    category: QuoteCategory.beribadah,
  ),
  Quote(
    id: '6',
    text: 'Shalat adalah tiang agama',
    arabic: 'الصَّلَاةُ عِمَادُ الدِّينِ',
    source: 'HR. Ibn Majah',
    category: QuoteCategory.beribadah,
  ),
  // Environmental Stewardship (2 quotes)
  Quote(
    id: '7',
    text:
        'Peliharalah alam seisinya, karena kita mempinjamnya dari anak cucu kita',
    arabic: 'وَلاَ تُفْسِدُوا فِي الأَرْضِ بَعْدَ إِصْلاَحِهَا',
    source: 'QS. Al-A\'raf: 56',
    category: QuoteCategory.berbaktiLingkungan,
  ),
  Quote(
    id: '8',
    text: 'Bersihkanlah bumi sebagaimana kamu membersihkan hati kamu',
    arabic: 'طَهِّرُوا الأَرْضَ كَمَا تُطَهِّرُونَ قُلُوبَكُمْ',
    source: 'HR. Thabrani',
    category: QuoteCategory.berbaktiLingkungan,
  ),
  // Family Devotion (2 quotes)
  Quote(
    id: '9',
    text: 'Berbaktilah kepada orang tua, dan hormatilah keluarga',
    arabic: 'وَبَرَّ والِدَيْكَ وَصِلْ رَحِمَكَ',
    source: 'QS. An-Nisa: 36',
    category: QuoteCategory.berbaktiKeluarga,
  ),
  Quote(
    id: '10',
    text: 'Surga berada di bawah telapak kaki ibu',
    arabic: 'الْجَنَّةُ تَحْتَ أَقْدَامِ الأُمَّهَاتِ',
    source: 'HR. Ahmad',
    category: QuoteCategory.berbaktiKeluarga,
  ),
];
