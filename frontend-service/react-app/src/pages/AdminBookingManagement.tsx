import { useEffect, useState } from 'react';
import { bookingApi } from '../services/api';
import { 
  Package, 
  Search, 
  Loader2,
  ChevronLeft,
  ChevronRight,
  Filter,
  CheckCircle2,
  XCircle,
  Clock,
  Download
} from 'lucide-react';

const AdminBookingManagement = () => {
  const [bookings, setBookings] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('ALL');
  
  
  const [page, setPage] = useState(0);
  const [size] = useState(10);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);

  const fetchBookings = async () => {
    setLoading(true);
    try {
      const response = await bookingApi.getBookingsPaged(page, size);
      const data = response.data;
      setBookings(data.content);
      setTotalPages(data.totalPages);
      setTotalElements(data.totalElements);
    } catch (error) {
      console.error("Failed to fetch bookings:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBookings();
  }, [page]);

  const handleUpdateStatus = async (pnr: string, status: string) => {
    try {
      await bookingApi.updateBookingStatus(pnr, status);
      fetchBookings();
    } catch (error) {
      alert("Failed to update booking status");
    }
  };

  const handleExportCSV = () => {
    const headers = ["PNR", "Customer", "Event", "Category", "Venue", "Amount", "Status", "Date"];
    const csvContent = [
      headers.join(","),
      ...bookings.map(b => [
        b.pnr,
        b.customerName,
        b.eventName,
        b.eventCategory,
        b.venue,
        b.totalAmount,
        b.status,
        new Date(b.eventDateTime).toLocaleDateString()
      ].map(field => `"${field}"`).join(","))
    ].join("\n");

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement("a");
    const url = URL.createObjectURL(blob);
    link.setAttribute("href", url);
    link.setAttribute("download", `bookings_export_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const filteredBookings = bookings.filter(booking => {
    const matchesSearch = 
      booking.pnr.toLowerCase().includes(searchTerm.toLowerCase()) ||
      booking.customerName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      booking.eventName.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesStatus = filterStatus === 'ALL' || booking.status === filterStatus;

    return matchesSearch && matchesStatus;
  });

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-8">
      {}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center space-y-4 md:space-y-0">
        <div>
          <h1 className="text-4xl font-black text-white flex items-center space-x-3 text-white">
            <Package className="w-10 h-10 text-indigo-500" />
            <span>Booking Management</span>
          </h1>
          <p className="text-slate-400 mt-1">Audit and manage platform transactions</p>
        </div>
        <button 
          onClick={handleExportCSV}
          className="flex items-center space-x-2 bg-slate-900 hover:bg-slate-800 border border-slate-800 px-6 py-3 rounded-2xl text-slate-300 hover:text-white transition-all shadow-xl font-bold group"
        >
          <Download className="w-5 h-5 group-hover:-translate-y-1 transition-transform" />
          <span>Export Transactions</span>
        </button>
      </div>

      {}
      <div className="bg-slate-900/50 border border-slate-800 p-6 rounded-3xl flex flex-col md:flex-row gap-4 text-white">
        <div className="relative flex-1">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
          <input 
            type="text" 
            placeholder="Search by PNR, Customer, or Event..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 pl-12 pr-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all"
          />
        </div>
        <div className="flex items-center space-x-4">
          <div className="flex items-center space-x-2 text-slate-500 bg-slate-950 px-4 py-3 rounded-2xl border border-slate-800">
            <Filter className="w-4 h-4" />
            <select 
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
              className="bg-transparent text-white focus:outline-none appearance-none cursor-pointer text-sm font-bold"
            >
              <option value="ALL">All Status</option>
              <option value="PAID">Paid</option>
              <option value="CONFIRMED">Confirmed</option>
              <option value="CANCELLED">Cancelled</option>
            </select>
          </div>
        </div>
      </div>

      {}
      <div className="bg-slate-900 border border-slate-800 rounded-3xl overflow-hidden shadow-2xl">
        {loading ? (
          <div className="py-20 flex flex-col items-center justify-center space-y-4">
            <Loader2 className="w-12 h-12 text-indigo-500 animate-spin" />
            <p className="text-slate-500 animate-pulse font-bold">Auditing transaction ledger...</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-slate-950/50 text-slate-500 text-[10px] uppercase tracking-widest font-black border-b border-slate-800">
                  <th className="px-8 py-5">Transaction ID (PNR)</th>
                  <th className="px-8 py-5">Customer & Event</th>
                  <th className="px-8 py-5">Amount</th>
                  <th className="px-8 py-5">Date</th>
                  <th className="px-8 py-5">Status</th>
                  <th className="px-8 py-5 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800">
                {filteredBookings.map((booking) => (
                  <tr key={booking.pnr} className="hover:bg-white/[0.02] transition-colors group">
                    <td className="px-8 py-6">
                      <span className="text-white font-mono font-bold bg-indigo-500/10 px-3 py-1 rounded-lg border border-indigo-500/20">
                        {booking.pnr}
                      </span>
                    </td>
                    <td className="px-8 py-6">
                      <p className="text-white font-bold text-lg leading-none">{booking.customerName}</p>
                      <p className="text-slate-500 text-sm mt-1">
                        {booking.eventName}  <span className="text-indigo-400/70">{booking.eventCategory}</span>
                      </p>
                    </td>
                    <td className="px-8 py-6">
                      <p className="text-white font-black text-xl">${booking.totalAmount.toFixed(2)}</p>
                    </td>
                    <td className="px-8 py-6">
                      <div className="flex items-center space-x-2 text-slate-400 text-sm font-medium">
                        <Clock className="w-4 h-4 text-slate-600" />
                        <span>{new Date(booking.eventDateTime).toLocaleDateString(undefined, { dateStyle: 'long' })}</span>
                      </div>
                    </td>
                    <td className="px-8 py-6">
                      <div className={`inline-flex items-center space-x-1.5 px-3 py-1 rounded-full text-[10px] font-black tracking-widest uppercase
                        ${booking.status === 'PAID' ? 'bg-emerald-500/10 text-emerald-500 border border-emerald-500/20' : 
                          booking.status === 'CANCELLED' ? 'bg-rose-500/10 text-rose-500 border border-rose-500/20' : 
                          'bg-orange-500/10 text-orange-500 border border-orange-500/20'}`}>
                        {booking.status === 'PAID' ? <CheckCircle2 className="w-3 h-3" /> : 
                         booking.status === 'CANCELLED' ? <XCircle className="w-3 h-3" /> : <Clock className="w-3 h-3" />}
                        <span>{booking.status}</span>
                      </div>
                    </td>
                    <td className="px-8 py-6">
                      <div className="flex justify-end space-x-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        {booking.status !== 'CANCELLED' && (
                          <button 
                            onClick={() => handleUpdateStatus(booking.pnr, 'CANCELLED')}
                            className="p-2.5 bg-slate-800 text-slate-400 hover:text-rose-500 hover:bg-rose-500/10 rounded-xl transition-all shadow-lg shadow-black/20"
                            title="Cancel Booking"
                          >
                            <XCircle className="w-5 h-5" />
                          </button>
                        )}
                        {booking.status === 'CONFIRMED' && (
                          <button 
                            onClick={() => handleUpdateStatus(booking.pnr, 'PAID')}
                            className="p-2.5 bg-slate-800 text-slate-400 hover:text-emerald-500 hover:bg-emerald-500/10 rounded-xl transition-all shadow-lg shadow-black/20"
                            title="Mark as Paid"
                          >
                            <CheckCircle2 className="w-5 h-5" />
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            {}
            <div className="bg-slate-950/50 px-8 py-5 border-t border-slate-800 flex items-center justify-between">
              <div className="text-slate-500 text-xs font-bold">
                Showing <span className="text-white">{bookings.length}</span> of <span className="text-white">{totalElements}</span> transactions
              </div>
              <div className="flex items-center space-x-2">
                <button 
                  onClick={() => setPage(p => Math.max(0, p - 1))}
                  disabled={page === 0}
                  className="p-2 rounded-xl bg-slate-900 border border-slate-800 text-slate-400 hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                >
                  <ChevronLeft className="w-5 h-5" />
                </button>
                <div className="flex items-center px-4 space-x-1 text-xs">
                  <span className="text-white font-black">Page {page + 1}</span>
                  <span className="text-slate-600">of</span>
                  <span className="text-slate-400">{totalPages || 1}</span>
                </div>
                <button 
                  onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
                  disabled={page >= totalPages - 1}
                  className="p-2 rounded-xl bg-slate-900 border border-slate-800 text-slate-400 hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                >
                  <ChevronRight className="w-5 h-5" />
                </button>
              </div>
            </div>
          </div>
        )}
      </div>

      {filteredBookings.length === 0 && !loading && (
        <div className="py-20 flex flex-col items-center justify-center text-slate-500 italic space-y-4">
          <Package className="w-16 h-16 text-slate-800" />
          <p>No transaction records found matching your query.</p>
        </div>
      )}
    </div>
  );
};

export default AdminBookingManagement;
