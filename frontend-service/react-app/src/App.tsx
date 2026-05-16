import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Auth from './pages/Auth';
import EventDetails from './pages/EventDetails';
import Profile from './pages/Profile';
import AdminDashboard from './pages/AdminDashboard';
import AdminEventManagement from './pages/AdminEventManagement';
import AdminUserManagement from './pages/AdminUserManagement';
import { Ticket } from 'lucide-react';
import MyBookings from './pages/MyBookings';
import TravelHome from './pages/TravelHome';
import CustomerSupport from './pages/CustomerSupport';
import AdminTransportManagement from './pages/AdminTransportManagement';
import AdminSupportManagement from './pages/AdminSupportManagement';
import AdminBookingManagement from './pages/AdminBookingManagement';
import OrganizerDashboard from './pages/OrganizerDashboard';


const AdminRoute = ({ children }: { children: React.ReactNode }) => {
  const user = JSON.parse(localStorage.getItem('user') || 'null');
  const isAdmin = user && (user.role === 'ADMIN' || user.username === 'admin' || user.email === 'admin@waygonway.com');
  
  if (!isAdmin) {
    return <Home />;
  }
  return <>{children}</>;
};

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-slate-950 w-full flex flex-col">
        <Navbar />
        
        <main className="flex-grow">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/travel" element={<TravelHome />} />
            <Route path="/support" element={<CustomerSupport />} />
            <Route path="/auth" element={<Auth />} />
            <Route path="/event/:id" element={<EventDetails />} />
            <Route path="/profile" element={<Profile />} />
            <Route path="/my-bookings" element={<MyBookings />} />
            
            <Route path="/admin" element={<AdminRoute><AdminDashboard /></AdminRoute>} />
            <Route path="/admin/events" element={<AdminEventManagement />} />
            <Route path="/admin/users" element={<AdminUserManagement />} />
            <Route path="/admin/bookings" element={<AdminBookingManagement />} />
            <Route path="/admin/transport" element={<AdminTransportManagement />} />
            <Route path="/admin/support" element={<AdminSupportManagement />} />
            <Route path="/organizer" element={<OrganizerDashboard />} />

          </Routes>
        </main>

        <footer className="py-12 border-t border-slate-900 bg-slate-950">
          <div className="max-w-7xl mx-auto px-4 text-center">
            <div className="flex justify-center items-center space-x-2 mb-4">
              <Ticket className="w-6 h-6 text-indigo-500" />
              <span className="text-xl font-bold text-slate-300">WaygonWay</span>
            </div>
            <p className="text-slate-500 text-sm"> 2025 WaygonWay Ticket Reservation System. Built with React & Spring Boot.</p>
          </div>
        </footer>
      </div>
    </Router>
  );
}

export default App;
