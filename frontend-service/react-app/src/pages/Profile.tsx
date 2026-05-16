import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { userApi } from '../services/api';
import { Mail, Shield, Calendar, Trash2, AlertTriangle, ArrowLeft } from 'lucide-react';

const Profile = () => {
  const navigate = useNavigate();
  const user = JSON.parse(localStorage.getItem('user') || 'null');
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [loading, setLoading] = useState(false);

  if (!user) {
    navigate('/auth');
    return null;
  }

  const handleDeleteAccount = async () => {
    setLoading(true);
    try {
      await userApi.deleteAccount(user.id);
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      navigate('/');
      window.location.reload();
    } catch (error) {
      alert("Failed to delete account. Please try again later.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 text-white py-20 px-4">
      <div className="max-w-3xl mx-auto space-y-8">
        <button 
          onClick={() => navigate('/')}
          className="flex items-center space-x-2 text-slate-400 hover:text-white transition-colors group"
        >
          <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition-transform" />
          <span>Back to Home</span>
        </button>

        <div className="bg-slate-900 border border-slate-800 rounded-[2.5rem] p-12 shadow-2xl relative overflow-hidden">
          <div className="absolute top-0 right-0 w-64 h-64 bg-indigo-600/10 blur-[100px] -z-10"></div>
          
          <div className="flex flex-col md:flex-row items-center md:items-start space-y-6 md:space-y-0 md:space-x-8">
            <div className="w-32 h-32 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-[2rem] flex items-center justify-center text-5xl font-black shadow-xl shadow-indigo-500/20">
              {user.username?.[0]?.toUpperCase()}
            </div>
            
            <div className="flex-1 text-center md:text-left space-y-1">
              <h1 className="text-4xl font-black tracking-tighter uppercase italic">{user.username}</h1>
              <div className="flex flex-wrap justify-center md:justify-start gap-4 pt-4">
                <div className="flex items-center space-x-2 bg-slate-800/50 px-4 py-2 rounded-xl border border-slate-800 shadow-sm">
                  <Mail className="w-4 h-4 text-indigo-400" />
                  <span className="text-slate-300 font-medium">{user.email}</span>
                </div>
                <div className="flex items-center space-x-2 bg-slate-800/50 px-4 py-2 rounded-xl border border-slate-800 shadow-sm">
                  <Shield className="w-4 h-4 text-purple-400" />
                  <span className="text-slate-300 font-medium uppercase tracking-widest text-xs font-black">{user.role}</span>
                </div>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-12 pb-12 border-b border-slate-800">
            <div className="p-6 bg-slate-950 rounded-3xl border border-slate-800">
              <p className="text-slate-500 text-xs font-black uppercase tracking-widest mb-2">Member Since</p>
              <div className="flex items-center space-x-3">
                <Calendar className="w-6 h-6 text-indigo-500" />
                <p className="text-xl font-bold italic tracking-tight">Active WaygonWay Member</p>
              </div>
            </div>
            <div className="p-6 bg-slate-950 rounded-3xl border border-slate-800">
              <p className="text-slate-500 text-xs font-black uppercase tracking-widest mb-2">Account Status</p>
              <div className="flex items-center space-x-3">
                <div className="w-6 h-6 bg-emerald-500/20 rounded-full flex items-center justify-center">
                  <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></div>
                </div>
                <p className="text-xl font-bold text-emerald-500 italic tracking-tight uppercase">Verified</p>
              </div>
            </div>
          </div>

          <div className="mt-12 space-y-6">
            <h2 className="text-2xl font-black uppercase italic tracking-tighter">Danger Zone</h2>
            <div className="bg-rose-500/5 border border-rose-500/20 rounded-3xl p-8 flex flex-col md:flex-row items-center justify-between space-y-6 md:space-y-0">
              <div className="flex items-center space-x-4">
                <div className="w-12 h-12 bg-rose-500/10 rounded-2xl flex items-center justify-center">
                  <AlertTriangle className="w-6 h-6 text-rose-500" />
                </div>
                <div>
                  <h3 className="text-lg font-bold text-white leading-none">Delete Account</h3>
                  <p className="text-slate-400 text-sm mt-1">Once you delete your account, there is no going back. Please be certain.</p>
                </div>
              </div>
              <button 
                onClick={() => setShowDeleteModal(true)}
                className="bg-rose-500 hover:bg-rose-600 text-white px-8 py-3 rounded-2xl font-black uppercase tracking-widest transition-all shadow-lg shadow-rose-900/20 active:scale-95 whitespace-nowrap"
              >
                Delete Account
              </button>
            </div>
          </div>
        </div>
      </div>

      {}
      {showDeleteModal && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center px-4">
          <div className="absolute inset-0 bg-slate-950/80 backdrop-blur-md" onClick={() => setShowDeleteModal(false)}></div>
          <div className="bg-slate-900 border border-slate-800 rounded-[2.5rem] p-10 max-w-lg w-full relative shadow-2xl animate-in fade-in zoom-in duration-300">
            <div className="bg-rose-500/10 w-20 h-20 rounded-[1.5rem] flex items-center justify-center mx-auto mb-6">
              <Trash2 className="w-10 h-10 text-rose-500" />
            </div>
            <h2 className="text-3xl font-black text-center uppercase tracking-tighter mb-4 italic">Are you absolutely sure?</h2>
            <p className="text-slate-400 text-center mb-10 text-lg leading-relaxed">
              This action will permanently delete your <span className="text-white font-bold">WaygonWay</span> account and remove all your data from our servers.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <button 
                onClick={() => setShowDeleteModal(false)}
                className="flex-1 bg-slate-800 hover:bg-slate-700 text-white py-4 rounded-2xl font-bold transition-all"
              >
                Cancel
              </button>
              <button 
                onClick={handleDeleteAccount}
                disabled={loading}
                className="flex-1 bg-rose-500 hover:bg-rose-600 text-white py-4 rounded-2xl font-black uppercase tracking-widest transition-all shadow-xl shadow-rose-900/40 flex items-center justify-center"
              >
                {loading ? "Processing..." : "Yes, Delete"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Profile;
