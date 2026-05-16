import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { Ticket, LogOut, Menu, X, User } from 'lucide-react';

const Navbar = () => {
  const navigate = useNavigate();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const user = JSON.parse(localStorage.getItem('user') || 'null');

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setIsMobileMenuOpen(false);
    navigate('/auth');
  };

  const toggleMobileMenu = () => setIsMobileMenuOpen(!isMobileMenuOpen);

  return (
    <nav className="border-b border-slate-800 bg-slate-950/80 backdrop-blur-md sticky top-0 z-50">
      <div className="max-w-[1920px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-20">
          <Link to="/" className="flex items-center space-x-2 group">
            <div className="w-10 h-10 bg-indigo-600 rounded-xl flex items-center justify-center group-hover:rotate-12 transition-transform shadow-lg shadow-indigo-500/20">
              <Ticket className="w-6 h-6 text-white" />
            </div>
            <span className="text-2xl font-black text-white tracking-tighter uppercase italic">WaygonWay</span>
          </Link>

          {/* Desktop Menu */}
          <div className="hidden lg:flex items-center space-x-8 text-white text-sm">
            <div className="flex space-x-6 mr-4 border-r border-slate-800 pr-8">
              <Link to="/" className="text-slate-300 hover:text-white transition-colors font-bold tracking-wide">Live Events</Link>
              <Link to="/travel" className="text-slate-300 hover:text-white transition-colors font-bold tracking-wide flex items-center space-x-1"><span className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></span><span>Transit</span></Link>
              <Link to="/support" className="text-slate-300 hover:text-white transition-colors font-bold tracking-wide">Support</Link>
            </div>
            {user && (
              <div className="flex items-center space-x-6">
                <Link to="/my-bookings" className="text-indigo-400 hover:text-indigo-300 font-bold">My Bookings</Link>
                {(user.role === 'ADMIN' || user.username === 'admin' || user.email === 'admin@waygonway.com') && (
                  <div className="flex items-center space-x-6 px-4 border-l border-slate-800 ml-4">
                    <Link to="/admin" className="text-purple-400 hover:text-purple-300 font-bold uppercase tracking-tight text-xs bg-purple-500/10 px-3 py-1 rounded-lg border border-purple-500/20 shadow-sm">Dashboard</Link>
                    <Link to="/admin/events" className="text-slate-300 hover:text-white font-bold">Events</Link>
                    <Link to="/admin/transport" className="text-slate-300 hover:text-white font-bold">Transit</Link>
                    <Link to="/admin/users" className="text-slate-300 hover:text-white font-bold">Users</Link>
                  </div>
                )}
              </div>
            )}
            
            <div className="flex items-center space-x-4 border-l border-slate-800 pl-8">
              {user ? (
                <div className="flex items-center space-x-6">
                  <Link to="/profile" className="flex items-center space-x-3 bg-slate-900 border border-slate-800 py-1.5 pl-1.5 pr-4 rounded-full hover:bg-slate-800 transition-colors">
                    <div className="w-8 h-8 rounded-full bg-indigo-600 flex items-center justify-center font-bold text-sm">
                      {user.username?.[0]?.toUpperCase() || 'U'}
                    </div>
                    <span className="text-sm font-medium text-slate-300">{user.username}</span>
                  </Link>
                  <button 
                    onClick={handleLogout}
                    className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2 text-sm font-medium"
                  >
                    <LogOut className="w-4 h-4" />
                    <span>Logout</span>
                  </button>
                </div>
              ) : (
                <div className="flex items-center space-x-4">
                  <Link to="/auth" className="text-slate-300 hover:text-white text-sm font-medium">Login</Link>
                  <Link 
                    to="/auth" 
                    className="bg-white text-slate-950 px-6 py-2 rounded-full font-bold hover:bg-indigo-100 transition-all shadow-lg text-sm"
                  >
                    Join Now
                  </Link>
                </div>
              )}
            </div>
          </div>

          {/* Mobile Menu Button */}
          <div className="lg:hidden">
            <button onClick={toggleMobileMenu} className="p-2 text-slate-400 hover:text-white transition-colors">
              {isMobileMenuOpen ? <X className="w-8 h-8" /> : <Menu className="w-8 h-8" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Sidebar Overlay */}
      {isMobileMenuOpen && (
        <div className="fixed inset-0 z-[60] lg:hidden">
          <div className="fixed inset-0 bg-slate-950/90 backdrop-blur-sm transition-opacity" onClick={toggleMobileMenu}></div>
          <div className="fixed inset-y-0 right-0 w-80 bg-slate-900 shadow-2xl p-8 flex flex-col transform transition-transform animate-in slide-in-from-right-full duration-300">
            <div className="flex justify-between items-center mb-12">
              <span className="text-2xl font-black text-white italic tracking-tighter">Menu</span>
              <button onClick={toggleMobileMenu} className="text-slate-400 hover:text-white">
                <X className="w-6 h-6" />
              </button>
            </div>

            <div className="flex flex-col space-y-6">
              <Link to="/" onClick={toggleMobileMenu} className="text-xl font-bold text-white hover:text-indigo-400 transition-colors">Live Events</Link>
              <Link to="/travel" onClick={toggleMobileMenu} className="text-xl font-bold text-white hover:text-indigo-400 transition-colors">Transit</Link>
              <Link to="/support" onClick={toggleMobileMenu} className="text-xl font-bold text-white hover:text-indigo-400 transition-colors">Support</Link>
              
              {user ? (
                <>
                  <div className="h-px bg-slate-800 my-4"></div>
                  <Link to="/my-bookings" onClick={toggleMobileMenu} className="text-xl font-bold text-indigo-400">My Bookings</Link>
                  <Link to="/profile" onClick={toggleMobileMenu} className="text-xl font-bold text-slate-300 flex items-center space-x-2"><User className="w-5 h-5" /><span>Profile</span></Link>
                  {(user.role === 'ADMIN' || user.username === 'admin' || user.email === 'admin@waygonway.com') && (
                    <div className="flex flex-col space-y-4 pt-4 border-t border-slate-800">
                      <span className="text-[10px] font-black uppercase tracking-widest text-slate-500">Admin Control</span>
                      <Link to="/admin" onClick={toggleMobileMenu} className="text-lg font-bold text-purple-400">Dashboard</Link>
                      <Link to="/admin/users" onClick={toggleMobileMenu} className="text-lg font-bold text-slate-300">Manage Users</Link>
                    </div>
                  )}
                  <button 
                    onClick={handleLogout}
                    className="flex items-center space-x-3 text-rose-500 font-bold text-lg pt-12"
                  >
                    <LogOut className="w-6 h-6" />
                    <span>Logout</span>
                  </button>
                </>
              ) : (
                <Link 
                  to="/auth" 
                  onClick={toggleMobileMenu}
                  className="bg-indigo-600 text-white text-center py-4 rounded-2xl font-black uppercase tracking-widest shadow-xl shadow-indigo-900/40 mt-12"
                >
                  Join Account
                </Link>
              )}
            </div>
          </div>
        </div>
      )}
    </nav>
  );
};

export default Navbar;
