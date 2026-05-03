import React from 'react';
import { Download, CheckCircle, MapPin, Calendar, Ticket, User, CreditCard } from 'lucide-react';

interface BillProps {
  booking: {
    pnr: string;
    customerName: string;
    eventName: string;
    venue: string;
    seats: string;
    totalAmount: number;
    eventDateTime: string;
    status: string;
  };
  onClose: () => void;
}

const Bill: React.FC<BillProps> = ({ booking, onClose }) => {
  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-slate-950/95 backdrop-blur-xl animate-in fade-in duration-300">
      <div className="bg-white text-slate-900 w-full max-w-2xl rounded-[2.5rem] overflow-hidden shadow-2xl shadow-indigo-500/20 flex flex-col md:flex-row print:shadow-none print:w-full print:max-w-none">
        
        {/* Left Side - Visual Header */}
        <div className="bg-indigo-600 p-12 text-white flex flex-col justify-between md:w-1/3 print:hidden">
          <div>
            <div className="bg-white/20 w-16 h-16 rounded-2xl flex items-center justify-center mb-6">
              <CheckCircle className="w-10 h-10" />
            </div>
            <h2 className="text-3xl font-black leading-tight">Payment<br />Successful!</h2>
          </div>
          <p className="text-indigo-100 text-sm font-medium">Your ticket is confirmed. Enjoy the show!</p>
        </div>

        {/* Right Side - Bill Details */}
        <div className="flex-1 p-8 md:p-12 space-y-8 bg-white">
          <div className="flex justify-between items-start">
            <div>
              <p className="text-[10px] uppercase tracking-[0.2em] font-bold text-slate-400 mb-1">Electronic Ticket</p>
              <h3 className="text-2xl font-black text-slate-900 uppercase">WaygonWay</h3>
            </div>
            <div className="text-right">
              <p className="text-[10px] uppercase tracking-[0.2em] font-bold text-slate-400 mb-1">PNR Number</p>
              <p className="text-xl font-mono font-black text-indigo-600">{booking.pnr}</p>
            </div>
          </div>

          <div className="border-y border-slate-100 py-8 grid grid-cols-2 gap-8">
            <div className="space-y-1">
              <div className="flex items-center space-x-2 text-slate-400">
                <User className="w-3.5 h-3.5" />
                <span className="text-[10px] uppercase font-bold tracking-widest">Customer</span>
              </div>
              <p className="font-bold text-slate-900">{booking.customerName}</p>
            </div>
            <div className="space-y-1">
              <div className="flex items-center space-x-2 text-slate-400">
                <Ticket className="w-3.5 h-3.5" />
                <span className="text-[10px] uppercase font-bold tracking-widest">Event</span>
              </div>
              <p className="font-bold text-slate-900 line-clamp-1">{booking.eventName}</p>
            </div>
            <div className="space-y-1">
              <div className="flex items-center space-x-2 text-slate-400">
                <Calendar className="w-3.5 h-3.5" />
                <span className="text-[10px] uppercase font-bold tracking-widest">Date & Time</span>
              </div>
              <p className="font-bold text-slate-900">{new Date(booking.eventDateTime).toLocaleString()}</p>
            </div>
            <div className="space-y-1">
              <div className="flex items-center space-x-2 text-slate-400">
                <MapPin className="w-3.5 h-3.5" />
                <span className="text-[10px] uppercase font-bold tracking-widest">Venue</span>
              </div>
              <p className="font-bold text-slate-900 line-clamp-1">{booking.venue}</p>
            </div>
          </div>

          <div className="flex justify-between items-center bg-slate-50 p-6 rounded-2xl">
            <div className="space-y-1">
              <p className="text-[10px] uppercase font-bold text-slate-400 tracking-widest">Seats</p>
              <p className="font-mono font-black text-slate-900">{booking.seats}</p>
            </div>
            <div className="text-right">
              <p className="text-[10px] uppercase font-bold text-slate-400 tracking-widest">Total Amount Paid</p>
              <p className="text-3xl font-black text-indigo-600">${booking.totalAmount.toFixed(2)}</p>
            </div>
          </div>

          <div className="flex flex-col sm:flex-row gap-4 pt-4 print:hidden">
            <button 
              onClick={handlePrint}
              className="flex-1 bg-slate-900 text-white font-bold py-4 rounded-2xl flex items-center justify-center space-x-2 hover:bg-slate-800 transition-all shadow-xl"
            >
              <Download className="w-5 h-5" />
              <span>Download PDF</span>
            </button>
            <button 
              onClick={onClose}
              className="flex-1 bg-slate-100 text-slate-600 font-bold py-4 rounded-2xl hover:bg-slate-200 transition-all"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Bill;
