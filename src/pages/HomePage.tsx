import { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { useNavigate } from 'react-router-dom';

export function HomePage() {
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session) {
        navigate('/dashboard');
      }
      setLoading(false);
    });
  }, [navigate]);

  if (loading) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
        <p>Loading...</p>
      </div>
    );
  }

  return (
    <div style={{
      maxWidth: '1200px',
      margin: '0 auto',
      padding: '48px 24px',
      textAlign: 'center'
    }}>
      <h1 style={{
        fontSize: '48px',
        fontWeight: '700',
        marginBottom: '24px',
        color: '#1a1a1a'
      }}>
        OmniTest
      </h1>
      <p style={{
        fontSize: '24px',
        color: '#666',
        marginBottom: '48px',
        lineHeight: '1.5'
      }}>
        AI-Powered Examination Platform
      </p>

      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
        gap: '24px',
        marginTop: '48px'
      }}>
        <div style={{
          padding: '32px',
          backgroundColor: 'white',
          borderRadius: '12px',
          boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{ fontSize: '24px', marginBottom: '16px', color: '#1a1a1a' }}>
            Create Exams
          </h3>
          <p style={{ color: '#666', lineHeight: '1.6' }}>
            Build comprehensive exams with multiple question types including MCQ, short answer, and essay questions
          </p>
        </div>

        <div style={{
          padding: '32px',
          backgroundColor: 'white',
          borderRadius: '12px',
          boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{ fontSize: '24px', marginBottom: '16px', color: '#1a1a1a' }}>
            AI-Powered Grading
          </h3>
          <p style={{ color: '#666', lineHeight: '1.6' }}>
            Automatic grading with AI feedback for subjective answers and detailed analytics
          </p>
        </div>

        <div style={{
          padding: '32px',
          backgroundColor: 'white',
          borderRadius: '12px',
          boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{ fontSize: '24px', marginBottom: '16px', color: '#1a1a1a' }}>
            Track Progress
          </h3>
          <p style={{ color: '#666', lineHeight: '1.6' }}>
            Monitor student performance with comprehensive analytics and insights
          </p>
        </div>
      </div>

      <div style={{ marginTop: '48px' }}>
        <p style={{ color: '#999', fontSize: '14px' }}>
          Sign in to get started with your examination platform
        </p>
      </div>
    </div>
  );
}
