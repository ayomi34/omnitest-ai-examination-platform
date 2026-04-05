export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          email: string;
          full_name: string;
          role: 'admin' | 'instructor' | 'student';
          avatar_url: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          email: string;
          full_name: string;
          role?: 'admin' | 'instructor' | 'student';
          avatar_url?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          full_name?: string;
          role?: 'admin' | 'instructor' | 'student';
          avatar_url?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      exams: {
        Row: {
          id: string;
          title: string;
          description: string;
          created_by: string;
          duration_minutes: number;
          total_marks: number;
          passing_marks: number;
          instructions: string;
          is_published: boolean;
          start_time: string | null;
          end_time: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          title: string;
          description?: string;
          created_by: string;
          duration_minutes?: number;
          total_marks?: number;
          passing_marks?: number;
          instructions?: string;
          is_published?: boolean;
          start_time?: string | null;
          end_time?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          title?: string;
          description?: string;
          created_by?: string;
          duration_minutes?: number;
          total_marks?: number;
          passing_marks?: number;
          instructions?: string;
          is_published?: boolean;
          start_time?: string | null;
          end_time?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      questions: {
        Row: {
          id: string;
          exam_id: string | null;
          question_type: 'mcq' | 'true_false' | 'short_answer' | 'essay' | 'code';
          question_text: string;
          marks: number;
          options: Json;
          correct_answer: Json | null;
          explanation: string | null;
          ai_generated: boolean;
          difficulty_level: 'easy' | 'medium' | 'hard';
          order_number: number;
          created_by: string;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          exam_id?: string | null;
          question_type: 'mcq' | 'true_false' | 'short_answer' | 'essay' | 'code';
          question_text: string;
          marks?: number;
          options?: Json;
          correct_answer?: Json | null;
          explanation?: string | null;
          ai_generated?: boolean;
          difficulty_level?: 'easy' | 'medium' | 'hard';
          order_number?: number;
          created_by: string;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          exam_id?: string | null;
          question_type?: 'mcq' | 'true_false' | 'short_answer' | 'essay' | 'code';
          question_text?: string;
          marks?: number;
          options?: Json;
          correct_answer?: Json | null;
          explanation?: string | null;
          ai_generated?: boolean;
          difficulty_level?: 'easy' | 'medium' | 'hard';
          order_number?: number;
          created_by?: string;
          created_at?: string;
          updated_at?: string;
        };
      };
      exam_sessions: {
        Row: {
          id: string;
          exam_id: string;
          student_id: string;
          started_at: string;
          submitted_at: string | null;
          time_remaining_seconds: number | null;
          status: 'in_progress' | 'submitted' | 'graded' | 'abandoned';
          total_score: number | null;
          percentage: number | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          exam_id: string;
          student_id: string;
          started_at?: string;
          submitted_at?: string | null;
          time_remaining_seconds?: number | null;
          status?: 'in_progress' | 'submitted' | 'graded' | 'abandoned';
          total_score?: number | null;
          percentage?: number | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          exam_id?: string;
          student_id?: string;
          started_at?: string;
          submitted_at?: string | null;
          time_remaining_seconds?: number | null;
          status?: 'in_progress' | 'submitted' | 'graded' | 'abandoned';
          total_score?: number | null;
          percentage?: number | null;
          created_at?: string;
        };
      };
      exam_answers: {
        Row: {
          id: string;
          session_id: string;
          question_id: string;
          answer: Json;
          is_correct: boolean | null;
          marks_awarded: number | null;
          ai_feedback: string | null;
          answered_at: string;
          created_at: string;
        };
        Insert: {
          id?: string;
          session_id: string;
          question_id: string;
          answer?: Json;
          is_correct?: boolean | null;
          marks_awarded?: number | null;
          ai_feedback?: string | null;
          answered_at?: string;
          created_at?: string;
        };
        Update: {
          id?: string;
          session_id?: string;
          question_id?: string;
          answer?: Json;
          is_correct?: boolean | null;
          marks_awarded?: number | null;
          ai_feedback?: string | null;
          answered_at?: string;
          created_at?: string;
        };
      };
      exam_analytics: {
        Row: {
          id: string;
          exam_id: string;
          student_id: string;
          average_score: number;
          attempts_count: number;
          best_score: number;
          time_spent_minutes: number;
          last_attempt_at: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          exam_id: string;
          student_id: string;
          average_score?: number;
          attempts_count?: number;
          best_score?: number;
          time_spent_minutes?: number;
          last_attempt_at?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          exam_id?: string;
          student_id?: string;
          average_score?: number;
          attempts_count?: number;
          best_score?: number;
          time_spent_minutes?: number;
          last_attempt_at?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
    };
    Views: {};
    Functions: {};
    Enums: {};
  };
}
