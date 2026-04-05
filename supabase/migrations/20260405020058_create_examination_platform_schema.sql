/*
  # OmniTest Examination Platform Database Schema

  ## Overview
  Complete database schema for an AI-powered examination platform with support for:
  - User authentication and profiles
  - Exam creation and management
  - Question banks with multiple question types
  - AI-powered question generation
  - Student exam sessions and submissions
  - Automated grading and results
  - Performance analytics

  ## New Tables

  ### 1. profiles
  Extends Supabase auth.users with additional user information
  - `id` (uuid, FK to auth.users)
  - `email` (text)
  - `full_name` (text)
  - `role` (text: 'admin', 'instructor', 'student')
  - `avatar_url` (text, optional)
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ### 2. exams
  Stores exam definitions
  - `id` (uuid, PK)
  - `title` (text)
  - `description` (text)
  - `created_by` (uuid, FK to profiles)
  - `duration_minutes` (integer)
  - `total_marks` (integer)
  - `passing_marks` (integer)
  - `instructions` (text)
  - `is_published` (boolean)
  - `start_time` (timestamptz, optional)
  - `end_time` (timestamptz, optional)
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ### 3. questions
  Question bank with support for multiple question types
  - `id` (uuid, PK)
  - `exam_id` (uuid, FK to exams, optional for question bank)
  - `question_type` (text: 'mcq', 'true_false', 'short_answer', 'essay', 'code')
  - `question_text` (text)
  - `marks` (integer)
  - `options` (jsonb, for MCQ)
  - `correct_answer` (jsonb)
  - `explanation` (text, optional)
  - `ai_generated` (boolean)
  - `difficulty_level` (text: 'easy', 'medium', 'hard')
  - `order_number` (integer)
  - `created_by` (uuid, FK to profiles)
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ### 4. exam_sessions
  Tracks student exam attempts
  - `id` (uuid, PK)
  - `exam_id` (uuid, FK to exams)
  - `student_id` (uuid, FK to profiles)
  - `started_at` (timestamptz)
  - `submitted_at` (timestamptz, optional)
  - `time_remaining_seconds` (integer)
  - `status` (text: 'in_progress', 'submitted', 'graded', 'abandoned')
  - `total_score` (integer, optional)
  - `percentage` (numeric, optional)
  - `created_at` (timestamptz)

  ### 5. exam_answers
  Stores student answers for each question
  - `id` (uuid, PK)
  - `session_id` (uuid, FK to exam_sessions)
  - `question_id` (uuid, FK to questions)
  - `answer` (jsonb)
  - `is_correct` (boolean, optional)
  - `marks_awarded` (integer, optional)
  - `ai_feedback` (text, optional)
  - `answered_at` (timestamptz)
  - `created_at` (timestamptz)

  ### 6. exam_analytics
  Aggregated performance analytics
  - `id` (uuid, PK)
  - `exam_id` (uuid, FK to exams)
  - `student_id` (uuid, FK to profiles)
  - `average_score` (numeric)
  - `attempts_count` (integer)
  - `best_score` (integer)
  - `time_spent_minutes` (integer)
  - `last_attempt_at` (timestamptz)
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ## Security
  
  ### Row Level Security (RLS)
  - All tables have RLS enabled
  - Profiles: Users can read all profiles but only update their own
  - Exams: Instructors can manage their exams, students can view published exams
  - Questions: Tied to exam permissions
  - Exam Sessions: Students can only access their own sessions
  - Exam Answers: Students can only access answers for their sessions
  - Analytics: Users can only view their own analytics, instructors can view their students' analytics

  ## Important Notes
  
  1. All timestamps use `timestamptz` for timezone awareness
  2. JSONB columns allow flexible storage for options, answers, and AI feedback
  3. Foreign key constraints ensure data integrity
  4. Indexes are added on frequently queried columns
  5. RLS policies ensure data security at the database level
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text NOT NULL,
  full_name text NOT NULL,
  role text NOT NULL DEFAULT 'student' CHECK (role IN ('admin', 'instructor', 'student')),
  avatar_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create exams table
CREATE TABLE IF NOT EXISTS exams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  created_by uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  duration_minutes integer NOT NULL DEFAULT 60,
  total_marks integer NOT NULL DEFAULT 100,
  passing_marks integer NOT NULL DEFAULT 40,
  instructions text DEFAULT '',
  is_published boolean DEFAULT false,
  start_time timestamptz,
  end_time timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create questions table
CREATE TABLE IF NOT EXISTS questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id uuid REFERENCES exams(id) ON DELETE CASCADE,
  question_type text NOT NULL CHECK (question_type IN ('mcq', 'true_false', 'short_answer', 'essay', 'code')),
  question_text text NOT NULL,
  marks integer NOT NULL DEFAULT 1,
  options jsonb DEFAULT '[]'::jsonb,
  correct_answer jsonb,
  explanation text,
  ai_generated boolean DEFAULT false,
  difficulty_level text DEFAULT 'medium' CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
  order_number integer DEFAULT 0,
  created_by uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create exam_sessions table
CREATE TABLE IF NOT EXISTS exam_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id uuid NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
  student_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  started_at timestamptz DEFAULT now(),
  submitted_at timestamptz,
  time_remaining_seconds integer,
  status text DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'submitted', 'graded', 'abandoned')),
  total_score integer,
  percentage numeric,
  created_at timestamptz DEFAULT now(),
  UNIQUE(exam_id, student_id, started_at)
);

-- Create exam_answers table
CREATE TABLE IF NOT EXISTS exam_answers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL REFERENCES exam_sessions(id) ON DELETE CASCADE,
  question_id uuid NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  answer jsonb DEFAULT '{}'::jsonb,
  is_correct boolean,
  marks_awarded integer,
  ai_feedback text,
  answered_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(session_id, question_id)
);

-- Create exam_analytics table
CREATE TABLE IF NOT EXISTS exam_analytics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id uuid NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
  student_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  average_score numeric DEFAULT 0,
  attempts_count integer DEFAULT 0,
  best_score integer DEFAULT 0,
  time_spent_minutes integer DEFAULT 0,
  last_attempt_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(exam_id, student_id)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_exams_created_by ON exams(created_by);
CREATE INDEX IF NOT EXISTS idx_exams_is_published ON exams(is_published);
CREATE INDEX IF NOT EXISTS idx_questions_exam_id ON questions(exam_id);
CREATE INDEX IF NOT EXISTS idx_questions_created_by ON questions(created_by);
CREATE INDEX IF NOT EXISTS idx_exam_sessions_exam_id ON exam_sessions(exam_id);
CREATE INDEX IF NOT EXISTS idx_exam_sessions_student_id ON exam_sessions(student_id);
CREATE INDEX IF NOT EXISTS idx_exam_sessions_status ON exam_sessions(status);
CREATE INDEX IF NOT EXISTS idx_exam_answers_session_id ON exam_answers(session_id);
CREATE INDEX IF NOT EXISTS idx_exam_answers_question_id ON exam_answers(question_id);
CREATE INDEX IF NOT EXISTS idx_exam_analytics_exam_id ON exam_analytics(exam_id);
CREATE INDEX IF NOT EXISTS idx_exam_analytics_student_id ON exam_analytics(student_id);

-- Enable Row Level Security on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE exam_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE exam_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE exam_analytics ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can view all profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- RLS Policies for exams
CREATE POLICY "Authenticated users can view published exams"
  ON exams FOR SELECT
  TO authenticated
  USING (
    is_published = true OR 
    created_by = auth.uid()
  );

CREATE POLICY "Instructors and admins can create exams"
  ON exams FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('instructor', 'admin')
    )
  );

CREATE POLICY "Exam creators can update their exams"
  ON exams FOR UPDATE
  TO authenticated
  USING (created_by = auth.uid())
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "Exam creators can delete their exams"
  ON exams FOR DELETE
  TO authenticated
  USING (created_by = auth.uid());

-- RLS Policies for questions
CREATE POLICY "Users can view questions for accessible exams"
  ON questions FOR SELECT
  TO authenticated
  USING (
    exam_id IS NULL OR
    EXISTS (
      SELECT 1 FROM exams
      WHERE exams.id = questions.exam_id
      AND (exams.is_published = true OR exams.created_by = auth.uid())
    )
  );

CREATE POLICY "Question creators can create questions"
  ON questions FOR INSERT
  TO authenticated
  WITH CHECK (
    created_by = auth.uid() AND
    (exam_id IS NULL OR
    EXISTS (
      SELECT 1 FROM exams
      WHERE exams.id = questions.exam_id
      AND exams.created_by = auth.uid()
    ))
  );

CREATE POLICY "Question creators can update their questions"
  ON questions FOR UPDATE
  TO authenticated
  USING (created_by = auth.uid())
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "Question creators can delete their questions"
  ON questions FOR DELETE
  TO authenticated
  USING (created_by = auth.uid());

-- RLS Policies for exam_sessions
CREATE POLICY "Students can view own exam sessions"
  ON exam_sessions FOR SELECT
  TO authenticated
  USING (
    student_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM exams
      WHERE exams.id = exam_sessions.exam_id
      AND exams.created_by = auth.uid()
    )
  );

CREATE POLICY "Students can create own exam sessions"
  ON exam_sessions FOR INSERT
  TO authenticated
  WITH CHECK (student_id = auth.uid());

CREATE POLICY "Students can update own exam sessions"
  ON exam_sessions FOR UPDATE
  TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());

-- RLS Policies for exam_answers
CREATE POLICY "Users can view answers for their sessions"
  ON exam_answers FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM exam_sessions
      WHERE exam_sessions.id = exam_answers.session_id
      AND (
        exam_sessions.student_id = auth.uid() OR
        EXISTS (
          SELECT 1 FROM exams
          WHERE exams.id = exam_sessions.exam_id
          AND exams.created_by = auth.uid()
        )
      )
    )
  );

CREATE POLICY "Students can insert answers for their sessions"
  ON exam_answers FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM exam_sessions
      WHERE exam_sessions.id = exam_answers.session_id
      AND exam_sessions.student_id = auth.uid()
    )
  );

CREATE POLICY "Students can update answers for their sessions"
  ON exam_answers FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM exam_sessions
      WHERE exam_sessions.id = exam_answers.session_id
      AND exam_sessions.student_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM exam_sessions
      WHERE exam_sessions.id = exam_answers.session_id
      AND exam_sessions.student_id = auth.uid()
    )
  );

-- RLS Policies for exam_analytics
CREATE POLICY "Students can view own analytics"
  ON exam_analytics FOR SELECT
  TO authenticated
  USING (
    student_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM exams
      WHERE exams.id = exam_analytics.exam_id
      AND exams.created_by = auth.uid()
    )
  );

CREATE POLICY "System can insert analytics"
  ON exam_analytics FOR INSERT
  TO authenticated
  WITH CHECK (student_id = auth.uid());

CREATE POLICY "System can update analytics"
  ON exam_analytics FOR UPDATE
  TO authenticated
  USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());
