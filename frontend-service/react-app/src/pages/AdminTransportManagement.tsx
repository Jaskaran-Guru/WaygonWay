import { useEffect, useState } from 'react';
import { transportApi } from '../services/api';
import { 
  Plus, 
  Trash2, 
  Search, 
  Loader2,
  X,
  Save,
  MapPin
} from 'lucide-react';


const AdminTransportManagement = () => {
  const [schedules, setSchedules] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  
  const [formData, setFormData] = useState({
    type: 'FLIGHT',
    operatorName: '',
    source: '',
    destination: '',
    departureTime: '2026-10-10T10:00', 
    arrivalTime: '2026-10-10T22:00',
    basePrice: 0,
    totalSeats: 0,
    availableSeats: 0
  });



  const fetchSchedules = async () => {
    setLoading(true);
    try {
      const response = await transportApi.getAllSchedules();
      setSchedules(response.data.data || []);
    } catch (error) {
      console.error("Failed to fetch schedules:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSchedules();
  }, []);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await transportApi.createSchedule(formData);
      setIsModalOpen(false);
      fetchSchedules();
    } catch (error) {
      alert("Failed to save schedule. Please check your data.");
    }
  };

  const handleDelete = async (id: string) => {
    if (window.confirm("Delete this schedule?")) {
      try {
        await transportApi.deleteSchedule(id);
        fetchSchedules();
      } catch (error) {
        alert("Failed to delete schedule.");
      }
    }
  };

  const filteredSchedules = Array.isArray(schedules) ? schedules.filter((s: any) => 
    s.operatorName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    s.source.toLowerCase().includes(searchTerm.toLowerCase()) ||
    s.destination.toLowerCase().includes(searchTerm.toLowerCase())
  ) : [];

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-8">
      <div className="flex justify-between items-center text-white">
        <div>
          <h1 className="text-3xl font-black">Transport Management</h1>
          <p className="text-slate-400">Manage global transit schedules for Flights, Trains & Buses</p>
        </div>
        <button 
          onClick={() => setIsModalOpen(true)}
          className="bg-blue-600 hover:bg-blue-700 text-white font-bold px-6 py-3 rounded-2xl flex items-center space-x-2 shadow-lg shadow-blue-500/20"
        >
          <Plus className="w-5 h-5" />
          <span>Add New Schedule</span>
        </button>
      </div>

      <div className="relative">
        <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
        <input 
          type="text" 
          placeholder="Search by operator, source or destination..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full bg-slate-900 border border-slate-800 rounded-2xl py-3 pl-12 pr-4 text-white focus:ring-2 focus:ring-blue-500/50 outline-none"
        />
      </div>

      {loading ? (
        <div className="flex justify-center py-20">
          <Loader2 className="w-12 h-12 text-blue-500 animate-spin" />
        </div>
      ) : (
        <div className="bg-slate-900 border border-slate-800 rounded-3xl overflow-hidden text-white">
          <table className="w-full text-left">
            <thead>
              <tr className="bg-slate-950/50 border-b border-slate-800 text-slate-500 text-[10px] uppercase font-black tracking-widest">
                <th className="px-8 py-5">Operator & Route</th>
                <th className="px-8 py-5">Type</th>
                <th className="px-8 py-5">Price & Seats</th>
                <th className="px-8 py-5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800/50">
              {filteredSchedules.map((s) => (
                <tr key={s.id} className="group hover:bg-white/5 transition-colors">
                  <td className="px-8 py-6">
                    <div className="font-bold text-white">{s.operatorName}</div>
                    <div className="text-xs text-slate-500 flex items-center mt-1">
                      <MapPin className="w-3 h-3 mr-1" />
                      {s.source}  {s.destination}
                    </div>
                  </td>
                  <td className="px-8 py-6">
                    <span className="bg-blue-500/10 text-blue-400 px-3 py-1 rounded-full text-[10px] font-black border border-blue-500/20">
                      {s.transportType}
                    </span>
                  </td>
                  <td className="px-8 py-6">
                    <div className="font-bold text-white">${s.basePrice}</div>
                    <div className="text-xs text-slate-500">{s.availableSeats} Seats Left</div>
                  </td>
                  <td className="px-8 py-6 text-right">
                    <button 
                      onClick={() => handleDelete(s.id)}
                      className="p-2.5 bg-slate-800 text-red-500 hover:bg-red-500/10 rounded-xl transition-all"
                    >
                      <Trash2 className="w-5 h-5" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {isModalOpen && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm">
          <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-2xl max-h-[90vh] overflow-y-auto shadow-2xl relative text-white">
            <div className="px-8 py-6 border-b border-slate-800 flex justify-between items-center">
              <h2 className="text-xl font-black uppercase">Schedule New Transit</h2>
              <button onClick={() => setIsModalOpen(false)} className="text-slate-500 hover:text-white"><X /></button>
            </div>
            <form onSubmit={handleSave} className="p-8 space-y-6">
              <div className="grid grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase text-slate-500">Transport Type</label>
                  <select 
                    value={formData.type}
                    onChange={(e) => setFormData({...formData, type: e.target.value})}
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 px-4 outline-none focus:ring-2 focus:ring-blue-500/50"
                  >
                    <option value="FLIGHT">Flight</option>
                    <option value="TRAIN">Train</option>
                    <option value="BUS">Bus</option>
                  </select>
                </div>

                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase text-slate-500">Operator Name</label>
                  <input type="text" value={formData.operatorName} onChange={(e) => setFormData({...formData, operatorName: e.target.value})} className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 px-4" required />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase text-slate-500">Source</label>
                  <input type="text" value={formData.source} onChange={(e) => setFormData({...formData, source: e.target.value})} className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 px-4" required />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase text-slate-500">Destination</label>
                  <input type="text" value={formData.destination} onChange={(e) => setFormData({...formData, destination: e.target.value})} className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 px-4" required />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase text-slate-500">Departure Time</label>
                  <input 
                    type="datetime-local" 
                    value={formData.departureTime} 
                    onChange={(e) => setFormData({...formData, departureTime: e.target.value})} 
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 px-4 color-scheme-dark outline-none focus:ring-2 focus:ring-blue-500/50" 
                    required 
                  />
                  <p className="text-[8px] text-slate-600 ml-1">Fill all segments (DD-MM-YYYY HH:MM)</p>
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase text-slate-500">Arrival Time</label>
                  <input 
                    type="datetime-local" 
                    value={formData.arrivalTime} 
                    onChange={(e) => setFormData({...formData, arrivalTime: e.target.value})} 
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 px-4 color-scheme-dark outline-none focus:ring-2 focus:ring-blue-500/50" 
                    required 
                  />
                </div>

                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase text-slate-500">Price ($)</label>
                  <input type="number" value={formData.basePrice} onChange={(e) => setFormData({...formData, basePrice: parseFloat(e.target.value)})} className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 px-4" required />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase text-slate-500">Total Seats</label>
                  <input type="number" value={formData.totalSeats} onChange={(e) => setFormData({...formData, totalSeats: parseInt(e.target.value), availableSeats: parseInt(e.target.value)})} className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 px-4" required />
                </div>
              </div>
              <button type="submit" className="w-full bg-blue-600 hover:bg-blue-700 py-4 rounded-2xl font-black uppercase tracking-widest shadow-xl flex items-center justify-center space-x-2">
                <Save className="w-5 h-5" />
                <span>Publish Schedule</span>
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminTransportManagement;
