import { useEffect, useState } from 'react';
import { supportApi } from '../services/api';
import { 
  MessageSquare, 
  CheckCircle, 
  Clock, 
  User, 
  Search, 
  Loader2,
  AlertCircle
} from 'lucide-react';

const AdminSupportManagement = () => {
  const [tickets, setTickets] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  const fetchTickets = async () => {
    setLoading(true);
    try {
      const response = await supportApi.getAllTickets();
      setTickets(response.data.data || []);
    } catch (error) {
      console.error("Failed to fetch tickets:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTickets();
  }, []);

  const handleResolve = async (id: string) => {
    if (window.confirm("Mark this ticket as resolved?")) {
      try {
        await supportApi.resolveTicket(id, "Ticket resolved by administrator.");
        fetchTickets();
      } catch (error) {

        alert("Failed to resolve ticket.");
      }
    }
  };

  const filteredTickets = Array.isArray(tickets) ? tickets.filter((t: any) => 
    t.subject.toLowerCase().includes(searchTerm.toLowerCase()) ||
    t.customerName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    t.pnr?.toLowerCase().includes(searchTerm.toLowerCase())
  ) : [];

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-8">
      <div className="flex justify-between items-center text-white">
        <div>
          <h1 className="text-3xl font-black">Support Dashboard</h1>
          <p className="text-slate-400">Manage customer queries and resolve platform issues</p>
        </div>
        <div className="flex items-center space-x-4">
           <div className="bg-orange-500/10 border border-orange-500/20 px-4 py-2 rounded-xl text-orange-400 font-bold text-sm">
             {filteredTickets.filter(t => t.status === 'OPEN').length} Open Tickets
           </div>
        </div>
      </div>

      <div className="relative">
        <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
        <input 
          type="text" 
          placeholder="Search by subject, customer name or PNR..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full bg-slate-900 border border-slate-800 rounded-2xl py-3 pl-12 pr-4 text-white focus:ring-2 focus:ring-orange-500/50 outline-none"
        />
      </div>

      {loading ? (
        <div className="flex justify-center py-20">
          <Loader2 className="w-12 h-12 text-orange-500 animate-spin" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredTickets.map((t) => (
            <div key={t.id} className="bg-slate-900 border border-slate-800 rounded-3xl p-6 space-y-4 hover:border-slate-700 transition-all flex flex-col justify-between shadow-xl">
              <div className="space-y-4">
                <div className="flex justify-between items-start">
                  <span className={`px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest border ${
                    t.status === 'OPEN' 
                    ? 'bg-orange-500/10 text-orange-400 border-orange-500/20' 
                    : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
                  }`}>
                    {t.status}
                  </span>
                  <span className="text-xs text-slate-500 font-bold">{t.category}</span>
                </div>
                
                <div>
                  <h3 className="text-lg font-bold text-white">{t.subject}</h3>
                  <p className="text-slate-400 text-sm mt-2 line-clamp-3 italic opacity-80">"{t.description}"</p>
                </div>

                <div className="pt-4 border-t border-slate-800/50 space-y-2">
                  <div className="flex items-center space-x-2 text-xs text-slate-300">
                    <User className="w-4 h-4 text-slate-500" />
                    <span className="font-bold">{t.customerName}</span>
                    <span className="text-slate-600"></span>
                    <span className="text-slate-500 font-mono">{t.customerEmail}</span>
                  </div>
                  {t.pnr && (
                    <div className="flex items-center space-x-2 text-xs">
                      <AlertCircle className="w-4 h-4 text-indigo-400" />
                      <span className="text-indigo-400 font-black uppercase">Related PNR: {t.pnr}</span>
                    </div>
                  )}
                  <div className="flex items-center space-x-2 text-[10px] text-slate-500">
                    <Clock className="w-3 h-3" />
                    <span>Raised on {new Date(t.createdAt).toLocaleString()}</span>
                  </div>
                </div>
              </div>

              {t.status === 'OPEN' ? (
                <button 
                  onClick={() => handleResolve(t.id)}
                  className="mt-6 w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3 rounded-xl flex items-center justify-center space-x-2 transition-all shadow-lg shadow-emerald-500/10"
                >
                  <CheckCircle className="w-5 h-5" />
                  <span>Mark Resolved</span>
                </button>
              ) : (
                <div className="mt-6 w-full bg-slate-800 py-3 rounded-xl text-slate-500 text-center font-bold text-sm">
                  Ticket Resolved
                </div>
              )}
            </div>
          ))}

          {filteredTickets.length === 0 && (
            <div className="col-span-full py-20 flex flex-col items-center justify-center text-slate-500 space-y-4">
              <MessageSquare className="w-16 h-16 opacity-20" />
              <p className="font-bold text-lg">No support tickets found.</p>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default AdminSupportManagement;
