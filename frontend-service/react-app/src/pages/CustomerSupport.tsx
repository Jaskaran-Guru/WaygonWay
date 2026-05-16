import { useState } from 'react';
import { supportApi } from '../services/api';
import { MessageSquare, HelpCircle, Phone, Send, Loader2, CheckCircle2 } from 'lucide-react';

const CustomerSupport = () => {
  const [subject, setSubject] = useState('');
  const [description, setDescription] = useState('');
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);

  
  const mockUser = { id: 'usr_xyz', name: 'John Doe', email: 'john@example.com' };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      const res = await supportApi.createTicket({
        userId: mockUser.id,
        customerName: mockUser.name,
        customerEmail: mockUser.email,
        subject,
        description
      });
      if (res.data.success) {
        setSuccess(true);
        setSubject('');
        setDescription('');
      }
    } catch (err) {
      console.error('Failed to submit ticket');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 text-white py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h1 className="text-4xl font-black text-white">How can we help you?</h1>
          <p className="mt-4 text-xl text-slate-400">Our support team is active 24/7 to resolve your queries instantly.</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
          <div className="bg-slate-900/50 border border-slate-800 rounded-3xl p-8 text-center flex flex-col items-center hover:bg-slate-900 transition-colors">
            <div className="w-16 h-16 bg-blue-500/10 rounded-full flex items-center justify-center text-blue-500 mb-6">
              <MessageSquare className="w-8 h-8" />
            </div>
            <h3 className="text-xl font-bold mb-2">Live Chat</h3>
            <p className="text-slate-400 text-sm">Average response time: 2 mins</p>
          </div>
          <div className="bg-slate-900/50 border border-slate-800 rounded-3xl p-8 text-center flex flex-col items-center hover:bg-slate-900 transition-colors">
            <div className="w-16 h-16 bg-indigo-500/10 rounded-full flex items-center justify-center text-indigo-500 mb-6">
              <HelpCircle className="w-8 h-8" />
            </div>
            <h3 className="text-xl font-bold mb-2">FAQs</h3>
            <p className="text-slate-400 text-sm">Find answers to common questions</p>
          </div>
          <div className="bg-slate-900/50 border border-slate-800 rounded-3xl p-8 text-center flex flex-col items-center hover:bg-slate-900 transition-colors">
            <div className="w-16 h-16 bg-emerald-500/10 rounded-full flex items-center justify-center text-emerald-500 mb-6">
              <Phone className="w-8 h-8" />
            </div>
            <h3 className="text-xl font-bold mb-2">Call Us</h3>
            <p className="text-slate-400 text-sm">1-800-WAYGON-WAY</p>
          </div>
        </div>

        <div className="max-w-3xl mx-auto bg-slate-900 border border-slate-800 rounded-3xl p-8 shadow-2xl">
          <h2 className="text-2xl font-bold mb-6 flex items-center space-x-3">
            <span>Submit a Support Ticket</span>
          </h2>
          
          {success ? (
            <div className="bg-emerald-500/10 border border-emerald-500/20 rounded-2xl p-8 text-center space-y-4">
              <CheckCircle2 className="w-16 h-16 text-emerald-500 mx-auto" />
              <h3 className="text-2xl font-bold text-white">Ticket Created!</h3>
              <p className="text-slate-400">Our team will get back to you shortly via email.</p>
              <button onClick={() => setSuccess(false)} className="mt-4 text-emerald-500 hover:text-emerald-400 font-bold">
                Submit another ticket
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label className="text-sm font-bold text-slate-400">Name</label>
                  <input type="text" value={mockUser.name} disabled className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-3 text-slate-500 cursor-not-allowed" />
                </div>
                <div className="space-y-2">
                  <label className="text-sm font-bold text-slate-400">Email Address</label>
                  <input type="email" value={mockUser.email} disabled className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-3 text-slate-500 cursor-not-allowed" />
                </div>
              </div>
              
              <div className="space-y-2">
                <label className="text-sm font-bold text-slate-400">Subject</label>
                <input 
                  type="text" 
                  value={subject}
                  onChange={(e) => setSubject(e.target.value)}
                  placeholder="E.g., Issue with booking reference PNR-1234"
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-blue-500 transition-colors"
                  required
                />
              </div>

              <div className="space-y-2">
                <label className="text-sm font-bold text-slate-400">Description</label>
                <textarea 
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Please describe your issue in detail..."
                  rows={5}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-blue-500 transition-colors resize-none"
                  required
                ></textarea>
              </div>

              <button 
                type="submit"
                disabled={loading}
                className="w-full bg-blue-600 hover:bg-blue-500 text-white rounded-xl py-4 font-bold flex items-center justify-center space-x-2 transition-all disabled:opacity-50"
              >
                {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Send className="w-5 h-5" />}
                <span>Send Message</span>
              </button>
            </form>
          )}
        </div>

      </div>
    </div>
  );
};

export default CustomerSupport;
