import { useEffect, useState } from 'react';
import { organizerApi } from '../services/api';
import { BarChart3, Calendar, Users, DollarSign, Activity, Ticket as TicketIcon } from 'lucide-react';

const OrganizerDashboard = () => {
  const [stats, setStats] = useState<any>(null);
  const [events, setEvents] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  
  const organizerId = "ORG123";

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [statsRes, eventsRes] = await Promise.all([
          organizerApi.getDashboardStats(organizerId),
          organizerApi.getEvents(organizerId)
        ]);
        setStats(statsRes.data.data);
        setEvents(eventsRes.data.data);
      } catch (error) {
        console.error("Failed to load organizer dashboard:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  if (loading) {
    return (
      <div className="flex justify-center items-center py-20">
        <div className="w-12 h-12 border-4 border-indigo-500 border-t-transparent rounded-full animate-spin"></div>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-8">
      {}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center p-8 bg-slate-900 border border-slate-800 rounded-3xl space-y-4 md:space-y-0 shadow-xl relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl -mr-20 -mt-20 pointer-events-none"></div>
        <div className="z-10">
          <h1 className="text-4xl font-black text-white">Organizer Dashboard</h1>
          <p className="text-slate-400 mt-2">Manage your events and track ticket sales in real-time.</p>
        </div>
        <button className="z-10 bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-2xl font-bold transition-all shadow-lg shadow-indigo-500/20 active:scale-95 flex items-center space-x-2">
          <Calendar className="w-5 h-5" />
          <span>Create New Event</span>
        </button>
      </div>

      {}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard title="Total Revenue" value={`$${stats?.totalRevenue?.toLocaleString() || '0'}`} icon={<DollarSign className="w-6 h-6 text-emerald-400" />} color="bg-emerald-500/10" border="border-emerald-500/20" />
        <StatCard title="Tickets Sold" value={stats?.ticketsSold?.toString() || '0'} icon={<TicketIcon className="w-6 h-6 text-indigo-400" />} color="bg-indigo-500/10" border="border-indigo-500/20" />
        <StatCard title="Active Events" value={stats?.totalEvents?.toString() || '0'} icon={<Activity className="w-6 h-6 text-orange-400" />} color="bg-orange-500/10" border="border-orange-500/20" />
        <StatCard title="Total Bookings" value={stats?.totalBookings?.toString() || '0'} icon={<Users className="w-6 h-6 text-blue-400" />} color="bg-blue-500/10" border="border-blue-500/20" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 bg-slate-900 border border-slate-800 rounded-3xl p-8">
          <div className="flex justify-between items-center mb-8">
            <h2 className="text-2xl font-bold text-white flex items-center gap-3">
              <BarChart3 className="w-6 h-6 text-indigo-500" />
              Your Events
            </h2>
          </div>
          <div className="space-y-4">
            {events.length === 0 ? (
              <div className="text-center py-10 text-slate-500 italic">No events managed by you yet.</div>
            ) : (
              events.map((event: any) => (
                <div key={event.id} className="flex flex-col md:flex-row justify-between items-center p-5 bg-slate-950/50 hover:bg-slate-800/80 rounded-2xl border border-slate-800 transition-colors">
                  <div className="flex flex-col mb-4 md:mb-0">
                    <span className="text-white font-bold text-lg">{event.eventName}</span>
                    <span className="text-slate-500 text-sm mt-1">{new Date(event.startDateTime).toLocaleDateString()}  {event.venue}</span>
                  </div>
                  <div className="flex items-center space-x-8">
                    <div className="text-center">
                      <span className="block text-slate-500 text-xs font-bold uppercase tracking-widest">Seats Left</span>
                      <span className="text-indigo-400 font-black">{event.availableSeats}</span>
                    </div>
                    <div className="text-center">
                      <span className="block text-slate-500 text-xs font-bold uppercase tracking-widest">Price</span>
                      <span className="text-white font-black">${event.basePrice}</span>
                    </div>
                    <button className="text-sm border border-slate-700 hover:bg-slate-700 text-white px-4 py-2 rounded-xl transition-colors">
                      Manage
                    </button>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        <div className="lg:col-span-1 bg-slate-900 border border-slate-800 rounded-3xl p-8">
          <h2 className="text-2xl font-bold text-white mb-6">Recent Activity</h2>
          <div className="space-y-6 relative before:absolute before:inset-0 before:ml-5 before:-translate-x-px md:before:mx-auto md:before:translate-x-0 before:h-full before:w-0.5 before:bg-gradient-to-b before:from-transparent before:via-slate-800 before:to-transparent">
            <p className="text-slate-500 italic text-center py-10 relative z-10 bg-slate-900">Activity logs will appear here based on new real-time bookings.</p>
          </div>
        </div>
      </div>
    </div>
  );
};

const StatCard = ({ title, value, icon, color, border }: any) => (
  <div className={`bg-slate-900/50 backdrop-blur-sm p-6 rounded-3xl border ${border} transition-transform hover:-translate-y-1`}>
    <div className="flex items-center justify-between mb-4">
      <div className={`p-3 rounded-2xl ${color}`}>{icon}</div>
    </div>
    <div className="space-y-1">
      <p className="text-slate-400 font-bold text-sm tracking-wide">{title}</p>
      <p className="text-4xl font-black text-white tracking-tight">{value}</p>
    </div>
  </div>
);

export default OrganizerDashboard;
