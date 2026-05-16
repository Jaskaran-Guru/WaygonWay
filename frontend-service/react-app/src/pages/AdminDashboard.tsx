import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { bookingApi, transportApi, supportApi } from '../services/api';
import { 
  DollarSign, 
  Calendar, 
  ArrowUpRight, 
  Loader2,
  Package,
  HeadphonesIcon
} from 'lucide-react';

const AdminDashboard = () => {
  const [stats, setStats] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        
        const [eventRes, transportRes, supportRes] = await Promise.all([
          bookingApi.getDashboardStats().catch(() => ({ data: { totalRevenue: 0, totalBookings: 0, totalEvents: 0, recentBookings: [], categoryDistribution: {} } })),
          transportApi.getAllBookings().catch(() => ({ data: { data: [] } })),
          supportApi.getAllTickets().catch(() => ({ data: { data: [] } }))
        ]);
        
        const eventStats = eventRes.data;
        const transportBookings = transportRes.data.data;
        const supportTickets = supportRes.data.data;

        const transportRevenue = transportBookings.reduce((sum: number, b: any) => sum + (b.totalAmount || 0), 0);
        const openTickets = supportTickets.filter((t: any) => t.status === 'OPEN').length;

        
        const recentTransport = transportBookings.slice(-5).map((b: any) => ({
          pnr: b.pnr,
          customerName: b.customerName,
          eventName: b.source + ' to ' + b.destination,
          eventCategory: b.transportType,
          totalAmount: b.totalAmount,
          status: b.status
        }));
        
        let allRecent = [...eventStats.recentBookings, ...recentTransport];
        
        allRecent = allRecent.slice(-10);

        setStats({
          totalRevenue: eventStats.totalRevenue + transportRevenue,
          totalBookings: eventStats.totalBookings + transportBookings.length,
          totalEvents: eventStats.totalEvents,
          openSupportTickets: openTickets,
          recentBookings: allRecent,
          categoryDistribution: eventStats.categoryDistribution
        });
      } catch (error) {
        console.error("Failed to fetch dashboard stats:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchStats();
    
    const interval = setInterval(fetchStats, 5000);
    return () => clearInterval(interval);
  }, []);

  if (loading || !stats) return (
    <div className="flex justify-center items-center min-h-[60vh] bg-slate-950">
      <Loader2 className="w-12 h-12 text-indigo-500 animate-spin" />
    </div>
  );

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-12">
      <div className="flex justify-between items-end">
        <div className="space-y-2">
          <h1 className="text-4xl font-black text-white">Master Admin Dashboard</h1>
          <p className="text-slate-400 text-lg">Real-time aggregate analytics across Events, Travel & Support via MongoDB</p>
        </div>
        <div className="bg-emerald-600/10 border border-emerald-500/20 px-4 py-2 rounded-xl flex items-center space-x-2 text-emerald-400">
          <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
          <span className="text-sm font-bold uppercase tracking-wider">Live Polling Active</span>
        </div>
      </div>

      {}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard 
          icon={<DollarSign className="w-6 h-6" />} 
          label="Global Revenue" 
          value={`$${stats.totalRevenue.toLocaleString()}`} 
          trend="LIVE" 
          color="bg-emerald-500" 
        />
        <StatCard 
          icon={<Package className="w-6 h-6" />} 
          label="Total Inter-Platform Bookings" 
          value={stats.totalBookings.toLocaleString()} 
          trend="LIVE" 
          color="bg-blue-500" 
        />
        <StatCard 
          icon={<HeadphonesIcon className="w-6 h-6" />} 
          label="Open Support Tickets" 
          value={stats.openSupportTickets.toString()} 
          trend={stats.openSupportTickets > 5 ? "High Load" : "Normal"} 
          color="bg-red-500" 
        />
        <StatCard 
          icon={<Calendar className="w-6 h-6" />} 
          label="Active Live Events" 
          value={stats.totalEvents.toLocaleString()} 
          trend="LIVE" 
          color="bg-purple-500" 
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
        {}
        <div className="lg:col-span-2 space-y-6">
          <div className="flex justify-between items-center">
            <h2 className="text-2xl font-bold text-white">Live Transactions Stream</h2>
            <Link 
              to="/admin/bookings" 
              className="text-indigo-400 hover:text-indigo-300 text-sm font-bold flex items-center space-x-1"
            >
              <span>View Full Report</span>
              <ArrowUpRight className="w-4 h-4" />
            </Link>
          </div>
          <div className="bg-slate-900 border border-slate-800 rounded-3xl overflow-hidden shadow-2xl">
            <table className="w-full text-left bg-slate-900">
              <thead>
                <tr className="border-b border-slate-800 text-slate-500 text-[10px] uppercase tracking-widest font-black bg-slate-800/20">
                  <th className="px-6 py-4">Customer</th>
                  <th className="px-6 py-4">Item (Event / Transit)</th>
                  <th className="px-6 py-4">Amount</th>
                  <th className="px-6 py-4">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800/50">
                {stats.recentBookings.map((booking: any, idx: number) => (
                  <tr key={booking.pnr || idx} className="group hover:bg-slate-800/50 transition-colors">
                    <td className="px-6 py-4">
                      <p className="text-white font-bold">{booking.customerName}</p>
                      <p className="text-slate-500 text-xs font-mono">PNR: {booking.pnr}</p>
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-slate-300 font-medium">{booking.eventName}</p>
                      <p className="text-indigo-400 opacity-70 text-[10px] font-black uppercase tracking-wider">{booking.eventCategory}</p>
                    </td>
                    <td className="px-6 py-4 font-black text-white">${booking.totalAmount?.toFixed(2) || '0.00'}</td>
                    <td className="px-6 py-4">
                      <span className={`px-3 py-1 rounded-md text-[10px] font-black uppercase tracking-widest
                        ${booking.status === 'PAID' ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' 
                        : booking.status === 'PENDING' ? 'bg-orange-500/10 text-orange-400 border border-orange-500/20'
                        : 'bg-slate-500/10 text-slate-400 border border-slate-500/20'}`}>
                        {booking.status}
                      </span>
                    </td>
                  </tr>
                ))}
                {stats.recentBookings.length === 0 && (
                  <tr>
                    <td colSpan={4} className="px-6 py-8 text-center text-slate-500">No recent transactions tracked.</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {}
        <div className="space-y-6">
          <h2 className="text-2xl font-bold text-white">Event Distribution</h2>
          <div className="bg-slate-900 border border-slate-800 rounded-3xl p-8 space-y-6 shadow-2xl">
            {Object.keys(stats.categoryDistribution || {}).length === 0 ? (
               <p className="text-slate-500 text-center py-4">No event data yet.</p>
            ) : Object.entries(stats.categoryDistribution).map(([cat, count]: [string, any]) => (
              <div key={cat} className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-slate-300 font-medium">{cat}</span>
                  <span className="text-white font-bold">{count} Bookings</span>
                </div>
                <div className="w-full h-2 bg-slate-800 rounded-full overflow-hidden">
                  <div 
                    className="h-full bg-indigo-500 transition-all duration-1000" 
                    style={{ width: `${(count / stats.totalBookings) * 100}%` }}
                  ></div>
                </div>
              </div>
            ))}
            <div className="pt-6 border-t border-slate-800">
              <button 
                onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
                className="w-full bg-slate-800 hover:bg-slate-700 text-white font-bold py-3 rounded-xl transition-all shadow-md"
              >
                Download Global Report
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

const StatCard = ({ icon, label, value, trend, color }: any) => (
  <div className="bg-slate-900 border border-slate-800 p-6 rounded-3xl space-y-4 hover:border-slate-700 transition-all group shadow-xl">
    <div className={`w-12 h-12 ${color}/10 rounded-2xl flex items-center justify-center ${color.replace('bg-', 'text-')} group-hover:scale-110 transition-transform`}>
      {icon}
    </div>
    <div>
      <p className="text-slate-400 text-sm font-bold uppercase tracking-wider">{label}</p>
      <div className="flex items-baseline space-x-3 mt-1">
        <h3 className="text-3xl font-black text-white">{value}</h3>
        <span className={`text-xs font-black px-2 py-0.5 rounded uppercase ${trend.includes('LIVE') ? 'bg-emerald-500/10 text-emerald-400' : 'bg-rose-500/10 text-rose-400'}`}>{trend}</span>
      </div>
    </div>
  </div>
);

export default AdminDashboard;
