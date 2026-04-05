import { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { useNavigate } from 'react-router-dom';
import type { Database } from '../types/database';

type Profile = Database['public']['Tables']['profiles']['Row'];
type Exam = Database['public']['Tables']['exams']['Row'];

export function DashboardPage() {
  const [profile, setProfile] = useState<Profile | null>(null);
  const [exams, setExams] = useState<Exam[]>([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      const { data: { session } } = await supabase.auth.getSession();

      if (!session) {
        navigate('/');
        return;
      }

      const { data: profileData } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', session.user.id)
        .maybeSingle();

      if (profileData) {
        setProfile(profileData);
      }

      const { data: examsData } = await supabase
        .from('exams')
        .select('*')
        .order('created_at', { ascending: false });

      if (examsData) {
        setExams(examsData);
      }
    } catch (error) {
      console.error('Error loading data:', error);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
        <p>Loading...</p>
      </div>
    );
  }

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f5f5f5' }}>
      <header style={{
        backgroundColor: 'white',
        borderBottom: '1px solid #e0e0e0',
        padding: '16px 24px'
      }}>
        <div style={{ maxWidth: '1200px', margin: '0 auto', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h1 style={{ fontSize: '24px', fontWeight: '600' }}>OmniTest</h1>
          <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
            <span>{profile?.full_name || profile?.email}</span>
            <span style={{
              padding: '4px 12px',
              backgroundColor: '#e3f2fd',
              borderRadius: '16px',
              fontSize: '14px',
              color: '#1976d2'
            }}>
              {profile?.role}
            </span>
          </div>
        </div>
      </header>

      <main style={{ maxWidth: '1200px', margin: '0 auto', padding: '32px 24px' }}>
        <div style={{ marginBottom: '32px' }}>
          <h2 style={{ fontSize: '32px', fontWeight: '600', marginBottom: '8px' }}>
            Dashboard
          </h2>
          <p style={{ color: '#666' }}>
            Welcome to your examination platform
          </p>
        </div>

        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
          gap: '24px',
          marginBottom: '48px'
        }}>
          <div style={{
            padding: '24px',
            backgroundColor: 'white',
            borderRadius: '12px',
            boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
          }}>
            <h3 style={{ fontSize: '14px', color: '#666', marginBottom: '8px' }}>Total Exams</h3>
            <p style={{ fontSize: '32px', fontWeight: '600', color: '#1a1a1a' }}>{exams.length}</p>
          </div>

          <div style={{
            padding: '24px',
            backgroundColor: 'white',
            borderRadius: '12px',
            boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
          }}>
            <h3 style={{ fontSize: '14px', color: '#666', marginBottom: '8px' }}>Published</h3>
            <p style={{ fontSize: '32px', fontWeight: '600', color: '#1a1a1a' }}>
              {exams.filter(e => e.is_published).length}
            </p>
          </div>

          <div style={{
            padding: '24px',
            backgroundColor: 'white',
            borderRadius: '12px',
            boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
          }}>
            <h3 style={{ fontSize: '14px', color: '#666', marginBottom: '8px' }}>Database Status</h3>
            <p style={{ fontSize: '18px', fontWeight: '600', color: '#4caf50' }}>Connected</p>
          </div>
        </div>

        <div style={{
          backgroundColor: 'white',
          borderRadius: '12px',
          padding: '24px',
          boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{ fontSize: '20px', fontWeight: '600', marginBottom: '16px' }}>
            Recent Exams
          </h3>
          {exams.length === 0 ? (
            <p style={{ color: '#666', padding: '32px', textAlign: 'center' }}>
              No exams found. The database is ready for you to create exams.
            </p>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {exams.slice(0, 5).map(exam => (
                <div
                  key={exam.id}
                  style={{
                    padding: '16px',
                    border: '1px solid #e0e0e0',
                    borderRadius: '8px',
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center'
                  }}
                >
                  <div>
                    <h4 style={{ fontSize: '16px', fontWeight: '500', marginBottom: '4px' }}>
                      {exam.title}
                    </h4>
                    <p style={{ fontSize: '14px', color: '#666' }}>
                      {exam.duration_minutes} minutes • {exam.total_marks} marks
                    </p>
                  </div>
                  <span style={{
                    padding: '4px 12px',
                    backgroundColor: exam.is_published ? '#e8f5e9' : '#fff3e0',
                    color: exam.is_published ? '#2e7d32' : '#f57c00',
                    borderRadius: '16px',
                    fontSize: '14px'
                  }}>
                    {exam.is_published ? 'Published' : 'Draft'}
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
