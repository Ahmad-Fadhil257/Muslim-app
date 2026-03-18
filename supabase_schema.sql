-- =====================================================
-- MUSLIM APP SUPABASE DATABASE SCHEMA
-- For Ramadan 1446 H / 2025
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- USER PROFILES TABLE
-- =====================================================
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security for profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- =====================================================
-- SHALAT (PRAYER) NOTES TABLE
-- Track user's daily prayer attendance
-- =====================================================
CREATE TABLE public.shalat_notes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    date DATE NOT NULL,
    prayer_name TEXT NOT NULL, -- 'Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya'
    is_completed BOOLEAN DEFAULT false,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, date, prayer_name)
);

ALTER TABLE public.shalat_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own salat notes"
    ON public.shalat_notes FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own salat notes"
    ON public.shalat_notes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own salat notes"
    ON public.shalat_notes FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own salat notes"
    ON public.shalat_notes FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- CERAMAH (LECTURE) NOTES TABLE
-- Store lecture/tausiyah notes attended during Ramadan
-- =====================================================
CREATE TABLE public.ceramah_notes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    speaker TEXT,
    location TEXT,
    date DATE NOT NULL,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.ceramah_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own ceramah notes"
    ON public.ceramah_notes FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own ceramah notes"
    ON public.ceramah_notes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own ceramah notes"
    ON public.ceramah_notes FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own ceramah notes"
    ON public.ceramah_notes FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- INFAQ/TRACKING TABLE
-- Record charity/donations during Ramadan
-- =====================================================
CREATE TABLE public.infaq_notes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    recipient TEXT, -- mosque name, charity organization, etc.
    description TEXT,
    date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.infaq_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own infaq notes"
    ON public.infaq_notes FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own infaq notes"
    ON public.infaq_notes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own infaq notes"
    ON public.infaq_notes FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own infaq notes"
    ON public.infaq_notes FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- CHAT HISTORY TABLE
-- Store AI chat conversations
-- =====================================================
CREATE TABLE public.chat_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    message TEXT NOT NULL,
    response TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.chat_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own chat history"
    ON public.chat_history FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own chat history"
    ON public.chat_history FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own chat history"
    ON public.chat_history FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- BOOKMARKS TABLE (for Quran/Audio)
-- =====================================================
CREATE TABLE public.bookmarks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    surah_number INTEGER NOT NULL,
    verse_number INTEGER,
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own bookmarks"
    ON public.bookmarks FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bookmarks"
    ON public.bookmarks FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own bookmarks"
    ON public.bookmarks FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- LAST READ POSITION TABLE
-- Track user's last read Quran position
-- =====================================================
CREATE TABLE public.last_read_position (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    surah_number INTEGER NOT NULL,
    verse_number INTEGER NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

ALTER TABLE public.last_read_position ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own last read"
    ON public.last_read_position FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own last read"
    ON public.last_read_position FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own last read"
    ON public.last_read_position FOR UPDATE
    USING (auth.uid() = user_id);

-- =====================================================
-- FUNCTION TO AUTO-CREATE PROFILE ON SIGNUP
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name)
    VALUES (
        NEW.id,
        NEW.email,
        NEW.raw_user_meta_data->>'full_name'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user signup
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- INDEXES FOR BETTER PERFORMANCE
-- =====================================================
CREATE INDEX idx_shalat_notes_user_date ON public.shalat_notes(user_id, date);
CREATE INDEX idx_ceramah_notes_user_date ON public.ceramah_notes(user_id, date);
CREATE INDEX idx_infaq_notes_user_date ON public.infaq_notes(user_id, date);
CREATE INDEX idx_chat_history_user_date ON public.chat_history(user_id, created_at);
