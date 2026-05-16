import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plane, Train, Bus, MapPin, Search, Calendar, ChevronRight, Loader2 } from 'lucide-react';
import { transportApi } from '../services/api';

const TravelHome = () => {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'FLIGHT' | 'TRAIN' | 'BUS'>('FLIGHT');
  const [source, setSource] = useState('');
  const [destination, setDestination] = useState('');
  const [schedules, setSchedules] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [hasSearched, setHasSearched] = useState(false);

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setHasSearched(true);
    try {
      const res = await transportApi.searchSchedules(activeTab, source, destination);
      if (res.data.success) {
        setSchedules(res.data.data);
      }
    } catch (err) {
      console.error('Failed to fetch schedules');
    } finally {
      setLoading(false);
    }
  };

  
  useEffect(() => {
    if (!hasSearched) return;
    const interval = setInterval(() => {
      transportApi.searchSchedules(activeTab, source, destination).then((res) => {
        if (res.data.success) setSchedules(res.data.data);
      });
    }, 10000);
    return () => clearInterval(interval);
  }, [hasSearched, activeTab, source, destination]);

  return (
    <div className="min-h-screen bg-slate-950 text-white pb-20">
      {}
      <div className="relative pt-24 pb-32 overflow-hidden flex justify-center items-center flex-col">
        <div className="absolute inset-0 bg-gradient-to-br from-blue-900/20 to-slate-900 z-0" />
        <h1 className="text-5xl md:text-6xl font-black text-white text-center z-10 tracking-tight leading-tight">
          TRAVEL THE WORLD, <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-indigo-500">
            ALL IN ONE PLACE.
          </span>
        </h1>
        <p className="mt-6 text-xl text-slate-400 max-w-2xl text-center z-10 px-4">
          Book Flights, Trains, and Buses with real-time analytics and instant confirmation.
        </p>
      </div>

      {}
      <div className="max-w-5xl mx-auto -mt-16 relative z-20 px-4">
        <div className="bg-slate-900/80 backdrop-blur-xl rounded-3xl border border-slate-800 shadow-2xl overflow-hidden p-2">
          
          {}
          <div className="flex space-x-2 p-2 border-b border-slate-800/50">
            {[
              { id: 'FLIGHT', icon: <Plane className="w-5 h-5"/>, label: 'Flights' },
              { id: 'TRAIN', icon: <Train className="w-5 h-5"/>, label: 'Trains' },
              { id: 'BUS', icon: <Bus className="w-5 h-5"/>, label: 'Buses' },
            ].map(tab => (
              <button
                key={tab.id}
                onClick={() => { setActiveTab(tab.id as 'FLIGHT'|'TRAIN'|'BUS'); setHasSearched(false); }}
                className={`flex items-center space-x-2 px-6 py-4 rounded-2xl font-bold transition-all ${
                  activeTab === tab.id 
                  ? 'bg-blue-600 text-white shadow-lg shadow-blue-500/20' 
                  : 'text-slate-400 hover:bg-slate-800 hover:text-white'
                }`}
              >
                {tab.icon}
                <span>{tab.label}</span>
              </button>
            ))}
          </div>

          {}
          <form onSubmit={handleSearch} className="p-6 grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-400 uppercase tracking-wider">From</label>
              <div className="relative">
                <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
                <input 
                  type="text" 
                  value={source}
                  onChange={(e) => setSource(e.target.value)}
                  placeholder="City or Airport"
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl py-4 pl-12 pr-4 text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
                  required
                />
              </div>
            </div>
            
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-400 uppercase tracking-wider">To</label>
              <div className="relative">
                <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
                <input 
                  type="text" 
                  value={destination}
                  onChange={(e) => setDestination(e.target.value)}
                  placeholder="City or Airport"
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl py-4 pl-12 pr-4 text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
                  required
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-400 uppercase tracking-wider">Departure Date</label>
              <div className="relative">
                <Calendar className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
                <input 
                  type="date" 
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl py-4 pl-12 pr-4 text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all select-none"
                  min={new Date().toISOString().split('T')[0]}
                  required
                />
              </div>
            </div>

            <button 
              type="submit"
              disabled={loading}
              className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white rounded-xl py-4 px-8 font-bold flex items-center justify-center space-x-2 transition-all disabled:opacity-50 shadow-xl shadow-blue-500/20"
            >
              {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
              <span>Search {activeTab.toLowerCase()}s</span>
            </button>
          </form>
        </div>
      </div>

      {}
      <div className="max-w-5xl mx-auto px-4 mt-12">
        {hasSearched && !loading && schedules.length === 0 && (
          <div className="text-center py-20 bg-slate-900/50 rounded-3xl border border-slate-800/50">
            <h3 className="text-2xl font-bold text-white mb-2">No schedules found</h3>
            <p className="text-slate-500">We couldn't find any {activeTab.toLowerCase()}s for your route. Try different cities or dates.</p>
          </div>
        )}

        <div className="space-y-4">
          {schedules.map((schedule) => (
            <div key={schedule.id} className="bg-slate-900 border border-slate-800 rounded-3xl p-6 hover:border-blue-500/50 transition-all flex flex-col md:flex-row items-center justify-between group">
              <div className="flex items-center space-x-6 w-full md:w-auto">
                <div className="w-16 h-16 bg-blue-500/10 rounded-2xl flex items-center justify-center text-blue-500">
                  {activeTab === 'FLIGHT' ? <Plane className="w-8 h-8"/> : activeTab === 'TRAIN' ? <Train className="w-8 h-8"/> : <Bus className="w-8 h-8"/>}
                </div>
                <div>
                  <h3 className="text-xl font-bold text-white">{schedule.operatorName}</h3>
                  <div className="flex items-center space-x-2 text-slate-400 text-sm mt-1">
                    <span>{schedule.source}</span>
                    <ChevronRight className="w-4 h-4 text-slate-600" />
                    <span>{schedule.destination}</span>
                  </div>
                </div>
              </div>
              
              <div className="flex items-center space-x-8 mt-6 md:mt-0 w-full md:w-auto justify-between md:justify-end">
                <div className="text-right">
                  <div className="text-2xl font-black text-white">${schedule.basePrice}</div>
                  <div className={`text-xs font-bold uppercase tracking-wider mt-1 ${schedule.availableSeats > 0 ? 'text-emerald-500' : 'text-red-500'}`}>
                    {schedule.availableSeats > 0 ? `${schedule.availableSeats} Seats Left` : 'Sold Out'}
                  </div>
                </div>
                <button 
                  disabled={schedule.availableSeats <= 0}
                  onClick={() => navigate('/auth')}
                  className="bg-white text-slate-950 px-8 py-3 rounded-xl font-black hover:bg-slate-200 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Book
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default TravelHome;
