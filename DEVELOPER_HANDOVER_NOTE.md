# Developer Handover Note - Muslim App (Ramadan 1446 H)

## Overview

This document explains the implementation of the Ramadan-themed Home Screen for the Muslim App. It provides details about the widget classes, API integration points, database schema, and new features including Tasbih (Dhikr) counter and Inspirational Quotes.

---

## 📡 API Integration Points

### 1. Prayer Schedule (Jadwal Shalat)

```
Endpoint: GET https://api.myquran.com/v2/sholat/jadwal/{kota}/{tahun}/{bulan}
Example: https://api.myquran.com/v2/sholat/jadwal/1206/2025/1

City ID Reference:
- 1206 = Jakarta
- 1101 = Bandung
- 3273 = Surabaya
(Sumber: https://github.com/pushdev-inline/jadwal-sholat-api)

Repository: ShalatRepository (lib/repository/shalat_repository.dart)
Model: ShalatScheduleResponse (lib/model/shalat_schedule_response.dart)
```

### 2. Al-Quran

```
Endpoint: GET https://equran.id/api/v2/surat
Response: List of 114 Surahs

Repository: QuranRepository (lib/repository/quran_repository.dart)
Model: Surah (lib/model/surah.dart)

Additional Endpoints:
- Detail Surah: https://equran.id/api/v2/surat/{nomor}
- Audio: Built into the API response
```

### 3. Daily Doa (Doa Harian)

```
Endpoint: GET https://doa-doa-api-ahmadramadhan.fly.dev/api

Repository: DoaRepository (lib/repository/doa_repository.dart)
Model: DoaModel (lib/model/doa.dart)
```

### 4. AI Chat (Islamic Q&A)

```
Provider: Google Gemini AI
API Key: AIzaSyD8OpL2TVa7ZObNiG_OxQXs4wV7HprDZMo
Model: gemini-2.0-flash

Service: GeminiService (lib/service/gemini_service.dart)
ViewModel: ChatViewModel (lib/viewmodel/chat_view_model.dart)
Page: ChatPage (lib/view/chat_page.dart)

System Prompt: Configured for Islamic context in GeminiService
```

---

## 🗄️ Supabase Database Schema

SQL file location: `supabase_schema.sql`

### Tables Created:

| Table                | Purpose                       |
| -------------------- | ----------------------------- |
| `profiles`           | User profile data             |
| `shalat_notes`       | Track daily prayer attendance |
| `ceramah_notes`      | Store lecture/tausiyah notes  |
| `infaq_notes`        | Record charity/donations      |
| `chat_history`       | Store AI chat conversations   |
| `bookmarks`          | Quran verse bookmarks         |
| `last_read_position` | Track Quran reading position  |

### Row Level Security (RLS)

All tables have RLS enabled with policies for:

- Users can only view their own data
- Users can only insert/update/delete their own data

---

## 📁 File Structure

### New Files Created

| File                    | Path                                         | Description                                 |
| ----------------------- | -------------------------------------------- | ------------------------------------------- |
| Theme                   | `lib/theme/app_theme.dart`                   | Color palette (#0D5C46 green, #FFB800 gold) |
| CustomHeader            | `lib/widgets/custom_header.dart`             | Gradient header with Ramadan greeting       |
| PrayerTimeCard          | `lib/widgets/prayer_time_card.dart`          | Glassmorphism prayer card with countdown    |
| MainNavigationGrid      | `lib/widgets/main_navigation_grid.dart`      | 2-column grid for main features             |
| SecondaryNavigationGrid | `lib/widgets/secondary_navigation_grid.dart` | 3-column for Ramadan notes                  |
| BottomNavBar            | `lib/widgets/bottom_nav_bar.dart`            | Bottom navigation                           |
| ChatPage                | `lib/view/chat_page.dart`                    | AI Islamic Q&A page                         |
| Schema                  | `supabase_schema.sql`                        | Database tables SQL                         |

### Files to Create for New Features

| File              | Path                                   | Description                          |
| ----------------- | -------------------------------------- | ------------------------------------ |
| TasbihPage        | `lib/view/tasbih_page.dart`            | Dhikr counter main page              |
| TasbihViewModel   | `lib/viewmodel/tasbih_view_model.dart` | State management for Tasbih          |
| QuotesPage        | `lib/view/quotes_page.dart`            | Inspirational quotes page            |
| QuotesData        | `lib/data/quotes_data.dart`            | Static quotes data                   |
| DhikrCard         | `lib/widgets/dhikr_card.dart`          | Oval/round card for dhikr selection  |
| CounterCircle     | `lib/widgets/counter_circle.dart`      | Circular counter display widget      |
| LimitOptionButton | `lib/widgets/limit_option_button.dart` | Bottom limit selection button        |
| QuoteCard         | `lib/widgets/quote_card.dart`          | Card for displaying individual quote |

### Modified Files

| File                                 | Changes                                |
| ------------------------------------ | -------------------------------------- |
| `lib/view/home_page.dart`            | Complete redesign with new widgets     |
| `lib/main.dart`                      | Added TasbihPage and QuotesPage routes |
| `lib/service/gemini_service.dart`    | Added API key and system prompt        |
| `lib/viewmodel/chat_view_model.dart` | Added clearMessages method             |

---

## 🎨 UI Components

### 1. CustomHeader (`lib/widgets/custom_header.dart`)

- Gradient background (#0D5C46 → #1A8F6E)
- Ramadan 1446 H badge
- Location display
- Glassmorphism effect

### 2. PrayerTimeCard (`lib/widgets/prayer_time_card.dart`)

- Live countdown timer (updates every second)
- Next prayer name and time
- Gold accent color for countdown

### 3. MainNavigationGrid

- 2-column layout with small box
- Features: Al-Quran, Jadwal, Doa Harian, Kiblat, AI Islam
- White cards with soft shadow
- icon and text in center

### 4. SecondaryNavigationGrid

- 3-column layout with small box
- "Catatan Ramadhan" section
- Items: Shalat, Ceramah, Infaq
- icon and text in center

### 5. BottomNavBar

- 5 items: Home, Read, Schedule, Heart, Profile
- Animated icons

---

## 🕌 Feature 1: Tasbih (Dhikr) Counter

### Overview

The Tasbih feature provides a digital counter for Islamic remembrance (dhikr) with customizable limits and three popular dhikr texts.

### Screen Layout

```
┌─────────────────────────────────┐
│  ←  Tasbih (Dhikr)              │  <- AppBar with back arrow
├─────────────────────────────────┤
│                                 │
│  ┌─────────┐ ┌─────────┐        │
│  │Subhanallah│ │Alhmadulillah│   │  <- Top Bar: 3 selectable
│  │  سبحان  │ │  الحمد  │        │     oval/round cards
│  └─────────┘ └─────────┘        │
│         ┌─────────┐             │
│         │Allahu   │             │
│         │ Akbar   │             │
│         │ الله أكبر│             │
│         └─────────┘             │
│                                 │
│         ┌───────────┐           │
│         │           │           │
│         │     0     │           │  <- Main Counter Area
│         │           │           │     Large circular counter
│         └───────────┘           │
│                                 │
│  ┌──────┐ ┌──────┐ ┌──────┐     │
│  │  33  │ │  99  │ │Bebas │     │  <- Bottom Limit Options
│  └──────┘ └──────┘ └──────┘     │
│          ┌──────────┐            │
│          │  Reset   │            │  <- Red reset button
│          └──────────┘            │
└─────────────────────────────────┘
```

### Widget Specifications

#### 1. DhikrCard (`lib/widgets/dhikr_card.dart`)

**Purpose:** Display selectable dhikr text in oval/round card design

**Properties:**

```dart
class DhikrCard extends StatelessWidget {
  final String arabicText;      // e.g., "سبحان الله"
  final String transliteration; // e.g., "Subhanallah"
  final bool isSelected;        // Selected state
  final VoidCallback onTap;     // Selection callback
}
```

**Design Specs:**

- Shape: Rounded rectangle with `BorderRadius.circular(25)`
- Size: Width ~100, Height ~60
- Background: Selected: `AppColors.primaryGreen`, Unselected: `AppColors.cardBackground`
- Border: Selected: 2px `AppColors.accentGold`, Unselected: none
- Text: Arabic in `Amiri` or `ArabicUI` font, transliteration below
- Shadow: `BoxShadow(color: Colors.black12, blurRadius: 4)`

#### 2. CounterCircle (`lib/widgets/counter_circle.dart`)

**Purpose:** Display large circular counter with current count

**Properties:**

```dart
class CounterCircle extends StatelessWidget {
  final int count;           // Current count value
  final int? limit;           // Limit (33, 99, or null for unlimited)
  final double size;          // Circle diameter (default: 200)
}
```

**Design Specs:**

- Outer circle: `AppColors.primaryGreen` with gold border (3px)
- Inner display: White background
- Number: FontSize: 72, Bold, `AppColors.primaryGreen`
- Limit indicator: Below number, e.g., "0 / 33" in `AppColors.textSecondary`
- Tap area: Entire circle is tappable for increment
- Animation: Scale animation on tap (0.95 scale for 100ms)

#### 3. LimitOptionButton (`lib/widgets/limit_option_button.dart`)

**Purpose:** Display limit selection options (33, 99, Bebas)

**Properties:**

```dart
class LimitOptionButton extends StatelessWidget {
  final String label;        // "33", "99", "Bebas"
  final bool isSelected;      // Selection state
  final VoidCallback onTap;  // Selection callback
  final bool isReset;         // Special styling for reset button
}
```

**Design Specs:**

- Shape: Rounded rectangle `BorderRadius.circular(15)`
- Size: Width ~80, Height ~45
- Background (normal): `AppColors.cardBackground`
- Background (selected): `AppColors.primaryGreen`
- Text: Bold, 16px
- Reset button: Red background (`Colors.red.shade600`), white text

### State Management

**TasbihViewModel (`lib/viewmodel/tasbih_view_model.dart`):**

```dart
class TasbihViewModel extends ChangeNotifier {
  // Selected Dhikr
  DhikrType _selectedDhikr = DhikrType.subhanallah;
  DhikrType get selectedDhikr => _selectedDhikr;

  // Counter
  int _count = 0;
  int get count => _count;

  // Limit
  int? _limit = 33;  // null = unlimited/bebas
  int? get limit => _limit;

  // Methods
  void selectDhikr(DhikrType type);
  void increment();  // Increments count, respects limit
  void setLimit(int? limit);  // 33, 99, or null (bebas)
  void reset();  // Reset count to 0 and clear selection
}

enum DhikrType {
  subhanallah,    // سبحان الله
  alhmadulillah,  // الحمد لله
  allahuAkbar,    // الله أكبر
}
```

**Logic:**

- When `limit` is set (33 or 99): Counter stops incrementing at limit
- When `limit` is null (Bebas): Counter continues indefinitely
- Reset: Sets count to 0, but keeps current dhikr and limit selection

### Page Implementation

**TasbihPage (`lib/view/tasbih_page.dart`):**

```dart
class TasbihPage extends StatelessWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TasbihViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasbih (Dhikr)'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar - Dhikr Selection
              _buildDhikrSelector(),

              // Main Counter Area
              Expanded(
                child: Center(
                  child: Consumer<TasbihViewModel>(
                    builder: (context, vm, _) => CounterCircle(
                      count: vm.count,
                      limit: vm.limit,
                      onTap: vm.increment,
                    ),
                  ),
                ),
              ),

              // Bottom Limit Options
              _buildLimitOptions(),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Integration with Navigation

Add to `MainNavigationGrid` or create new navigation entry:

```dart
// In main_navigation_grid.dart, add:
NavigationItem(
  icon: Icons.touch_app,
  label: 'Tasbih',
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const TasbihPage()),
  ),
),
```

---

## 💬 Feature 2: Inspirational Quotes (Nasihat)

### Overview

The Inspirational Quotes feature displays 10 carefully curated quotes covering four themes: religious knowledge, worship, environmental stewardship, and family devotion.

### Quotes Data (`lib/data/quotes_data.dart`)

```dart
class Quote {
  final String id;
  final String text;         // Indonesian/English text
  final String arabic;       // Arabic text
  final String source;      // Source/reference
  final QuoteCategory category;
}

enum QuoteCategory {
  menuntutIlmu,     // Seeking religious knowledge
  beribadah,       // Worship and devotion
  berbaktiLingkungan, // Environmental stewardship
  berbaktiKeluarga,   // Family devotion
}

// 10 Quotes
final List<Quote> inspirationalQuotes = [
  // Seeking Religious Knowledge (3 quotes)
  Quote(
    id: '1',
    text: 'Orang yang menuntut ilmu adalah orang yang paling dekat dengan Allah',
    arabic: 'طَلَبُ الْعِلْمِ فَرِيضَةٌ',
    source: 'HR. Bukhari',
    category: QuoteCategory.menuntutIlmu,
  ),
  // ... (10 total quotes, 2-3 per category)
];
```

### Quotes List

| #   | Category            | Indonesian Text                                                           | Arabic                                            |
| --- | ------------------- | ------------------------------------------------------------------------- | ------------------------------------------------- |
| 1   | Tuntutan Ilmu       | "Orang yang menuntut ilmu adalah orang yang paling dekat dengan Allah"    | طَلَبُ الْعِلْمِ فَرِيضَةٌ                        |
| 2   | Tuntutan Ilmu       | "Bertakwalah kepada Allah dan Allah akan memberikan ilmu kepada kamu"     | وَاتَّقُوا اللَّهَ وَيُعَلِّمُكُمُ اللَّهُ        |
| 3   | Tuntutan Ilmu       | "Carilah ilmu dari lahir hingga liang lahat"                              | اِطْلُبُ الْعِلْمَ مِنَ الْمَهْدِ إِلَى اللَّهْدِ |
| 4   | Beribadah           | "Beribadahlah kepada Allah dengan penuh ketundukan dan harapan"           | اعْبُدُوا اللَّهَ مُخْلِصِينَ لَهُ الدِّينَ       |
| 5   | Beribadah           | "Sesungguhnya Allah mencintai hamba yang merasa diawasi"                  | إِنَّ اللَّهَ يُحِبُّ مَنْ يَعْبُدُهُ             |
| 6   | Beribadah           | "Shalat adalah tiang agama"                                               | الصَّلَاةُ عِمَادُ الدِّينِ                       |
| 7   | Berbakti Lingkungan | "Peliharalah alam seisinya, karena kita mempinjamnya dari anak cucu kita" | وَلاَ تُفْسِدُوا فِي الأَرْضِ بَعْدَ إِصْلاَحِهَا |
| 8   | Berbakti Lingkungan | "Bersihkanlah bumi sebagaimana kamu membersihkan hati kamu"               | طَهِّرُوا الأَرْضَ كَمَا تُطَهِّرُونَ قُلُوبَكُمْ |
| 9   | Berbakti Keluarga   | "Berbaktilah kepada orang tua, dan hormatilah keluarga"                   | وَبَرَّ والِدَيْكَ وَصِلْ رَحِمَكَ                |
| 10  | Berbakti Keluarga   | "Surga berada di bawah telapak kaki ibu"                                  | الْجَنَّةُ تَحْتَ أَقْدَامِ الأُمَّهَاتِ          |

### Widget Specifications

#### QuoteCard (`lib/widgets/quote_card.dart`)

**Purpose:** Display individual inspirational quote

**Properties:**

```dart
class QuoteCard extends StatelessWidget {
  final Quote quote;
  final int index;  // For alternating card styling
}
```

**Design Specs:**

- Container: Rounded rectangle, `BorderRadius.circular(20)`
- Background: Alternating between `AppColors.primaryGreen` (light shade) and white
- Padding: 20px all sides
- Arabic text: Top, right-aligned, `Amiri` font, 24px, `AppColors.primaryGreen`
- Indonesian text: Below Arabic, 16px, `AppColors.textPrimary`, italic style
- Source: Bottom, smaller text (12px), `AppColors.textSecondary`
- Icon: Decorative Islamic pattern or icon in corner
- Shadow: Soft shadow for depth

#### QuotesPage (`lib/view/quotes_page.dart`)

**Layout:**

```
┌─────────────────────────────────┐
│  ←  Nasihat & Quotes            │  <- AppBar
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │  "Arabic quote here"       │  │
│  │  "Indonesian translation"  │  │  <- QuoteCard
│  │  - Source                  │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │  "Arabic quote here"      │  │
│  │  "Indonesian translation" │  │  <- QuoteCard (alt color)
│  │  - Source                 │  │
│  └───────────────────────────┘  │
│                                 │
│         (Scrollable)            │
│                                 │
└─────────────────────────────────┘
```

**Page Design:**

- AppBar: Title "Nasihat & Quotes", back arrow
- Body: `ListView.builder` with `QuoteCard` items
- Decorative header: Islamic pattern or verse decoration at top
- Spacing: 16px between cards

### State Management

The Quotes feature uses static data (no complex state management needed):

```dart
// Simple StatelessWidget - no ChangeNotifier needed
class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasihat & Quotes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: inspirationalQuotes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: QuoteCard(
              quote: inspirationalQuotes[index],
              index: index,
            ),
          );
        },
      ),
    );
  }
}
```

---

## 🛠️ TODO / Future Development

1. **Location Services**: Implement GPS-based prayer times
   - Use `geolocator` package
   - Auto-detect city for prayer schedule

2. **Catatan Shalat Page**: Edit Catatan Shalat Page feature
   - User can Only track daily prayer in that day can't another time

3. **Upgrade UI**: Improve UI in page
   - Al-Quran, Jadwal, Doa Harian, Kiblat
   - User can read Surat, Ayat di Al-Quran
   - User can only see Jadwal shalat in that day
   - Kiblat use gps to track kiblat

4. **New Features**:
   - ✅ Tasbih (Dhikr) Counter
   - ✅ Inspirational Quotes (Nasihat) 

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.6.0
  provider: ^6.1.5+1
  google_generative_ai: ^0.4.7
  google_fonts: ^5.0.0
  supabase_flutter: ^2.8.0

# Future additions:
# geolocator: ^11.0.0
# flutter_local_notifications: ^14.0.0
```

### Additional Dependencies for New Features

```yaml
# For Tasbih and Quotes (optional enhancements)
google_fonts: ^5.0.0 # Required for Arabic/Amiri font
# No additional packages needed - uses built-in Flutter widgets
```

---

## 🚀 Build & Run

```bash
cd muslim_app
flutter pub get
flutter run
```

---

## 📋 Implementation Checklist

### Tasbih Feature

- [ ] Create `lib/view/tasbih_page.dart`
- [ ] Create `lib/viewmodel/tasbih_view_model.dart`
- [ ] Create `lib/widgets/dhikr_card.dart`
- [ ] Create `lib/widgets/counter_circle.dart`
- [ ] Create `lib/widgets/limit_option_button.dart`
- [ ] Add route in `lib/main.dart`
- [ ] Add navigation item in appropriate grid

### Quotes Feature

- [ ] Create `lib/data/quotes_data.dart`
- [ ] Create `lib/view/quotes_page.dart`
- [ ] Create `lib/widgets/quote_card.dart`
- [ ] Add route in `lib/main.dart`
- [ ] Add navigation item in appropriate grid

---

## 🎯 Design Guidelines

### Theme Consistency

All new features must follow the existing theme:

1. **Primary Color:** `#0D5C46` (Islamic Green)
2. **Accent Color:** `#FFB800` (Gold)
3. **Typography:** Use `google_fonts` package for consistent typography
4. **Border Radius:** 12-30px for rounded elements
5. **Shadows:** Soft, subtle shadows for depth

### Islamic Aesthetics

- Use Arabic calligraphy fonts where appropriate
- Incorporate Islamic geometric patterns
- Maintain respectful, spiritual atmosphere
- Use gold/green color scheme consistently

---

_Generated for Muslim App - Ramadan 1446 H / 2025_
