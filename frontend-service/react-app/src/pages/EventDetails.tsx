import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { bookingApi } from '../services/api';
import SeatLayout from '../components/SeatLayout';
import Bill from '../components/Bill';
import { Calendar, MapPin, Ticket, ChevronLeft, Loader2, CreditCard } from 'lucide-react';
import { loadStripe } from '@stripe/stripe-js';
import { Elements, PaymentElement, useStripe, useElements } from '@stripe/react-stripe-js';

// Replace with your real Stripe public key
const stripePromise = loadStripe('pk_test_placeholder');

const CheckoutForm = ({ onCancel, onSuccess }: { onCancel: () => void, onSuccess: () => void }) => {
  const stripe = useStripe();
  const elements = useElements();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!stripe || !elements) return;

    setLoading(true);
    
    const result = await stripe.confirmPayment({
      elements,
      confirmParams: { return_url: window.location.origin + '/my-bookings' },
      redirect: 'if_required',
    });

    if (result.error) {
       setError(result.error.message || 'Payment failed');
       setLoading(false);
    } else if (result.paymentIntent && result.paymentIntent.status === 'succeeded') {
       onSuccess();
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <PaymentElement />
      {error && <div className="text-red-500 text-sm mt-2 font-medium bg-red-50 p-3 rounded-lg">{error}</div>}
      <div className="flex space-x-4 pt-4">
        <button type="button" onClick={onCancel} className="flex-1 px-4 py-3 bg-slate-100 text-slate-600 font-bold rounded-xl hover:bg-slate-200 transition-colors">Cancel</button>
        <button type="submit" disabled={!stripe || loading} className="flex-1 px-4 py-3 bg-indigo-600 text-white font-bold rounded-xl hover:bg-indigo-700 flex justify-center transition-colors shadow-lg shadow-indigo-500/20">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : "Pay Now"}
        </button>
      </div>
    </form>
  );
};

const EventDetails = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [event, setEvent] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [selectedSeats, setSelectedSeats] = useState<string[]>([]);
  const [bookingLoading, setBookingLoading] = useState(false);
  const [bookingResponse, setBookingResponse] = useState<any>(null);
  const [showBill, setShowBill] = useState(false);
  const [finalBooking, setFinalBooking] = useState<any>(null);

  useEffect(() => {
    const fetchEvent = async () => {
      try {
        const response = await bookingApi.getEventById(id!);
        setEvent(response.data);
      } catch (error) {
        console.error("Failed to fetch event:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchEvent();
  }, [id]);

  const handleBookingInit = async () => {
    if (selectedSeats.length === 0) return;
    
    setBookingLoading(true);
    try {
      const response = await bookingApi.createBooking({
        eventId: event.id,
        userId: "USER123", // Mock User
        customerName: "Jass Karan",
        seats: selectedSeats.join(','),
        paymentMethod: "CARD"
      });
      
      if (response.data.success) {
        setBookingResponse(response.data.data);
      } else {
        alert("Booking Failed: " + response.data.error);
      }
    } catch (error) {
      alert("An error occurred during booking initialization.");
    } finally {
      setBookingLoading(false);
    }
  };

  const handlePaymentSuccess = async () => {
    try {
      const response = await bookingApi.updateBookingStatus(bookingResponse.pnr, 'PAID');
      setFinalBooking({
        ...response.data.data,
        eventDateTime: event.startDateTime // Merge event time if not in booking
      });
      setShowBill(true);
      setBookingResponse(null);
    } catch (err) {
      alert("Error confirming payment.");
    }
  };

  if (loading) return (
    <div className="flex justify-center items-center min-h-[60vh]">
      <Loader2 className="w-12 h-12 text-indigo-500 animate-spin" />
    </div>
  );

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <button 
        onClick={() => navigate(-1)}
        className="flex items-center space-x-2 text-slate-400 hover:text-white mb-8 transition-colors"
      >
        <ChevronLeft className="w-5 h-5" />
        <span>Back to Events</span>
      </button>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
        <div className="lg:col-span-2 space-y-12">
          {/* Header */}
          <div className="space-y-4">
            <h1 className="text-5xl font-black text-white">{event.eventName}</h1>
            <div className="flex flex-wrap gap-6 text-slate-400">
              <div className="flex items-center space-x-2">
                <Calendar className="w-5 h-5 text-indigo-500" />
                <span>{new Date(event.startDateTime).toLocaleString()}</span>
              </div>
              <div className="flex items-center space-x-2">
                <MapPin className="w-5 h-5 text-indigo-500" />
                <span>{event.venue}, {event.location}</span>
              </div>
              <div className="flex items-center space-x-2">
                <Ticket className="w-5 h-5 text-indigo-500" />
                <span className="bg-indigo-500/10 text-indigo-400 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider">{event.category}</span>
              </div>
            </div>
          </div>

          {/* Seat Map */}
          <div className="space-y-6">
            <h2 className="text-2xl font-bold text-white">Select Your Seats</h2>
            <SeatLayout onSelect={setSelectedSeats} />
          </div>
        </div>

        {/* Sidebar / Summary */}
        <div className="lg:col-span-1">
          <div className="bg-slate-900 border border-slate-800 rounded-3xl p-8 sticky top-24 space-y-8">
            <h3 className="text-xl font-bold text-white border-b border-slate-800 pb-4">Booking Summary</h3>
            
            <div className="space-y-4">
              <div className="flex justify-between text-slate-400">
                <span>Base Price (per seat)</span>
                <span>${event.basePrice}</span>
              </div>
              <div className="flex justify-between text-slate-400">
                <span>Selected Seats</span>
                <span className="text-white font-bold">{selectedSeats.length > 0 ? selectedSeats.join(', ') : 'None'}</span>
              </div>
              <div className="flex justify-between items-center border-t border-slate-800 pt-6">
                <span className="text-lg font-bold text-white">Total Amount</span>
                <span className="text-2xl font-black text-indigo-500">
                  ${(event.basePrice * selectedSeats.length).toFixed(2)}
                </span>
              </div>
            </div>

            <button 
              disabled={selectedSeats.length === 0 || bookingLoading}
              onClick={handleBookingInit}
              className={`w-full py-4 rounded-2xl font-bold transition-all transform active:scale-95 flex items-center justify-center space-x-2
                ${selectedSeats.length > 0 
                  ? 'bg-indigo-600 hover:bg-indigo-700 text-white shadow-lg shadow-indigo-500/20' 
                  : 'bg-slate-800 text-slate-500 cursor-not-allowed'}`}
            >
              {bookingLoading ? (
                <Loader2 className="w-6 h-6 animate-spin" />
              ) : (
                <>
                  <span>Proceed to Payment</span>
                  <ChevronLeft className="w-5 h-5 rotate-180" />
                </>
              )}
            </button>
            <p className="text-[10px] text-slate-500 text-center uppercase tracking-widest">Secure Payment Processing</p>
          </div>
        </div>
      </div>

      {/* Stripe Payment Modal */}
      {bookingResponse && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-slate-950/90 backdrop-blur-md">
            <div className="bg-white rounded-[2.5rem] w-full max-w-md p-8 shadow-2xl space-y-6 transform transition-all">
                <div className="flex items-center space-x-3 text-slate-900 mb-6">
                    <div className="bg-indigo-100 p-3 rounded-2xl">
                        <CreditCard className="w-6 h-6 text-indigo-600" />
                    </div>
                    <h3 className="text-2xl font-black">Complete Payment</h3>
                </div>
                
                {bookingResponse.clientSecret.includes('mock') ? (
                    <div className="space-y-6">
                        <div className="bg-orange-50 border border-orange-200 p-4 rounded-xl text-orange-800 text-sm font-medium">
                            Running in simulation mode. No credit card required.
                        </div>
                        <div className="flex flex-col space-y-4 pt-4">
                            <button 
                                onClick={handlePaymentSuccess}
                                className="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-4 rounded-2xl flex items-center justify-center space-x-2 shadow-lg shadow-indigo-500/20 transition-all"
                            >
                                <span>Simulate Successful Payment</span>
                            </button>
                            <button 
                                onClick={() => setBookingResponse(null)}
                                className="w-full bg-slate-100 hover:bg-slate-200 text-slate-600 font-bold py-4 rounded-2xl transition-all"
                            >
                                Cancel
                            </button>
                        </div>
                    </div>
                ) : (
                    <Elements stripe={stripePromise} options={{ clientSecret: bookingResponse.clientSecret }}>
                        <CheckoutForm 
                            onCancel={() => setBookingResponse(null)}
                            onSuccess={handlePaymentSuccess}
                        />
                    </Elements>
                )}
            </div>
        </div>
      )}
      {/* Bill Section */}
      {showBill && finalBooking && (
        <Bill 
          booking={finalBooking} 
          onClose={() => {
            setShowBill(false);
            navigate('/my-bookings');
          }} 
        />
      )}
    </div>
  );
};

export default EventDetails;
