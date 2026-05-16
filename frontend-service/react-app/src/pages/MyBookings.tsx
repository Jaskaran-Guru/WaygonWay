import { useEffect, useState } from 'react';
import { bookingApi } from '../services/api';
import { Ticket, Calendar, MapPin, CheckCircle2, Clock, X, Download, Share2 } from 'lucide-react';

const MyBookings = () => {
  const [bookings, setBookings] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedTicket, setSelectedTicket] = useState<any>(null);
  const userId = "USER123"; 

  useEffect(() => {
    const fetchBookings = async () => {
      try {
        const response = await bookingApi.getUserBookings(userId);
        setBookings(response.data.data);
      } catch (error) {
        console.error("Failed to fetch bookings:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchBookings();
  }, []);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-12">
      <div className="space-y-2">
        <h1 className="text-4xl font-black text-white">My Bookings</h1>
        <p className="text-slate-400 text-lg">Manage your tickets and upcoming experiences</p>
      </div>

      {loading ? (
        <div className="space-y-4">
          {[1, 2].map(i => (
            <div key={i} className="h-32 bg-slate-900/50 rounded-3xl animate-pulse"></div>
          ))}
        </div>
      ) : bookings.length === 0 ? (
        <div className="text-center py-20 bg-slate-900 rounded-3xl border border-slate-800 border-dashed">
          <Ticket className="w-16 h-16 text-slate-700 mx-auto mb-4" />
          <h3 className="text-xl font-bold text-slate-300">No bookings yet</h3>
          <p className="text-slate-500 mt-2">Explore events and book your first experience today!</p>
        </div>
      ) : (
        <div className="grid gap-6">
          {bookings.map((booking) => (
            <div key={booking.id} className="bg-slate-900 border border-slate-800 rounded-3xl p-6 md:p-8 flex flex-col md:flex-row justify-between items-start md:items-center space-y-6 md:space-y-0 hover:border-indigo-500/30 transition-all group">
              <div className="flex items-center space-x-6">
                <div className="w-16 h-16 bg-indigo-500/10 rounded-2xl flex items-center justify-center text-indigo-500 group-hover:scale-110 transition-transform">
                  <Ticket className="w-8 h-8" />
                </div>
                <div className="space-y-1">
                  <div className="flex items-center space-x-3">
                    <h3 className="text-xl font-bold text-white group-hover:text-indigo-400 transition-colors">{booking.eventName}</h3>
                    <span className="bg-slate-800 text-slate-400 px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-widest">{booking.eventCategory}</span>
                  </div>
                  <div className="flex flex-wrap gap-4 text-sm text-slate-400">
                    <div className="flex items-center space-x-1">
                      <Calendar className="w-4 h-4" />
                      <span>{new Date(booking.eventDateTime).toLocaleDateString()}</span>
                    </div>
                    <div className="flex items-center space-x-1">
                      <MapPin className="w-4 h-4" />
                      <span>{booking.venue}</span>
                    </div>
                  </div>
                </div>
              </div>

              <div className="flex items-center space-x-12 w-full md:w-auto border-t md:border-t-0 border-slate-800 pt-6 md:pt-0">
                <div className="text-center">
                  <p className="text-[10px] uppercase tracking-widest text-slate-500 mb-1">Seats</p>
                  <p className="font-bold text-white">{booking.seats}</p>
                </div>
                <div className="text-center">
                  <p className="text-[10px] uppercase tracking-widest text-slate-500 mb-1">PNR</p>
                  <p className="font-mono text-indigo-400 font-bold">{booking.pnr}</p>
                </div>
                <div className="flex flex-col items-end space-y-2">
                  <div className={`flex items-center space-x-1.5 px-3 py-1 rounded-full text-xs font-bold
                    ${booking.status === 'PAID' ? 'bg-emerald-500/10 text-emerald-500' : 'bg-orange-500/10 text-orange-500'}`}>
                    {booking.status === 'PAID' ? <CheckCircle2 className="w-3.5 h-3.5" /> : <Clock className="w-3.5 h-3.5" />}
                    <span className="uppercase tracking-wider">{booking.status}</span>
                  </div>
                  <p className="text-lg font-black text-white">${booking.totalAmount.toFixed(2)}</p>
                  <button 
                    onClick={() => setSelectedTicket(booking)}
                    className="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-4 py-2 rounded-xl transition-all transform active:scale-95 shadow-lg shadow-indigo-500/20"
                  >
                    View Ticket
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {}
      {selectedTicket && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-slate-950/90 backdrop-blur-md">
          <div className="bg-white rounded-[2.5rem] w-full max-w-sm overflow-hidden shadow-2xl relative transform transition-all">
            {}
            <div className="bg-indigo-600 px-8 py-10 text-white relative">
              <button 
                onClick={() => setSelectedTicket(null)}
                className="absolute top-6 right-6 p-2 hover:bg-white/10 rounded-full transition-colors"
              >
                <X className="w-5 h-5 transition-transform hover:rotate-90" />
              </button>
              <div className="space-y-1">
                <p className="text-indigo-200 text-[10px] font-black uppercase tracking-widest leading-none">Admission Pass</p>
                <h2 className="text-3xl font-black tracking-tight leading-tight">{selectedTicket.eventName}</h2>
              </div>
              <div className="mt-6 flex items-center space-x-3 text-indigo-100/80">
                <MapPin className="w-4 h-4" />
                <span className="text-xs font-bold">{selectedTicket.venue}</span>
              </div>
            </div>

            {}
            <div className="p-8 space-y-8 bg-white relative">
              {}
              <div className="absolute -top-3 left-0 right-0 flex justify-between px-4">
                {[...Array(20)].map((_, i) => (
                  <div key={i} className="w-2 h-2 bg-indigo-600 rounded-full"></div>
                ))}
              </div>

              <div className="grid grid-cols-2 gap-8">
                <div className="space-y-1">
                  <p className="text-[10px] text-slate-400 font-black uppercase tracking-widest">Date</p>
                  <p className="text-slate-900 font-bold">{new Date(selectedTicket.eventDateTime).toLocaleDateString()}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-[10px] text-slate-400 font-black uppercase tracking-widest">Seats</p>
                  <p className="text-slate-900 font-bold">{selectedTicket.seats}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-[10px] text-slate-400 font-black uppercase tracking-widest">PNR Number</p>
                  <p className="text-indigo-600 font-black tracking-tighter">{selectedTicket.pnr}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-[10px] text-slate-400 font-black uppercase tracking-widest">Gate</p>
                  <p className="text-slate-900 font-bold">Main Hall A</p>
                </div>
              </div>

              {}
              <div className="bg-slate-50 border-2 border-dashed border-slate-200 rounded-3xl p-8 flex flex-col items-center justify-center space-y-4">
                <div className="w-48 h-48 bg-white p-4 shadow-inner rounded-2xl">
                  <img 
                    src={`https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${selectedTicket.pnr}`}
                    alt="Ticket QR Code"
                    className="w-full h-full mix-blend-multiply"
                  />
                </div>
                <p className="text-[10px] text-slate-500 font-bold tracking-[0.3em] uppercase">Scan for Entry</p>
              </div>

              {}
              <div className="flex space-x-4 pt-4">
                <button className="flex-1 border-2 border-slate-100 hover:bg-slate-50 text-slate-600 font-bold py-4 rounded-2xl flex items-center justify-center space-x-2 transition-all">
                  <Download className="w-5 h-5" />
                  <span>Save</span>
                </button>
                <button className="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-4 rounded-2xl flex items-center justify-center space-x-2 shadow-lg shadow-indigo-500/20 transition-all">
                  <Share2 className="w-5 h-5" />
                  <span>Share</span>
                </button>
              </div>
            </div>
            
            {}
            <div className="h-6 bg-slate-900 flex items-center justify-center space-x-1">
               <div className="w-1 h-1 bg-slate-800 rounded-full"></div>
               <div className="w-1 h-1 bg-slate-800 rounded-full"></div>
               <div className="w-1 h-1 bg-slate-800 rounded-full"></div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default MyBookings;
