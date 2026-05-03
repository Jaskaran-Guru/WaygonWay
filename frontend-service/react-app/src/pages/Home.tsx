import React, { useEffect, useState } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { Film, Music, Mic2, Star, Loader2, Search as SearchIcon } from 'lucide-react';
import EventCard from '../components/EventCard';
import { bookingApi } from '../services/api';

const Home = () => {
  const [events, setEvents] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [searchParams] = useSearchParams();
  const [searchQuery, setSearchQuery] = useState('');
  const navigate = useNavigate();
  
  // Pagination State
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  
  const currentCategory = searchParams.get('category');

  const fetchEvents = async (pageToFetch: number, append: boolean = false) => {
    if (append) setLoadingMore(true);
    else setLoading(true);
    
    try {
      // Map frontend category to backend category
      let apiCategory = currentCategory;
      if (currentCategory === 'movies') apiCategory = 'MOVIE';
      else if (currentCategory === 'concerts') apiCategory = 'CONCERT';
      else if (currentCategory === 'stand-up') apiCategory = 'COMEDY';
      else if (currentCategory === 'evergreen') apiCategory = 'EVERGREEN';

      const response = await bookingApi.getEventsPaged(pageToFetch, 6, apiCategory || undefined); 
      const data = response.data;
      
      if (append) {
        setEvents(prev => [...(prev || []), ...(data?.content || [])]);
      } else {
        setEvents(data?.content || []);
      }
      setTotalPages(data?.totalPages || 0);
    } catch (error) {
      console.error("Failed to fetch events:", error);
    } finally {
      setLoading(false);
      setLoadingMore(false);
    }
  };

  useEffect(() => {
    // Reset and fetch on category change
    setPage(0);
    fetchEvents(0, false);

    // Real-time syncing (Active polling every 5 seconds)
    const interval = setInterval(() => {
      let apiCategory = currentCategory;
      if (currentCategory === 'movies') apiCategory = 'MOVIE';
      else if (currentCategory === 'concerts') apiCategory = 'CONCERT';
      else if (currentCategory === 'stand-up') apiCategory = 'COMEDY';
      else if (currentCategory === 'evergreen') apiCategory = 'EVERGREEN';

      bookingApi.getEventsPaged(0, 6, apiCategory || undefined).then(res => {
        // Silently sync newest events so buttons show 'Sold Out' instantly without hard refresh
        setEvents(prev => {
          if ((prev || []).length <= 6) return res.data?.content || []; // only sync if not loaded more
          return prev;
        });
      }).catch(console.error);
    }, 5000);

    return () => clearInterval(interval);
  }, [currentCategory]);

  const handleLoadMore = () => {
    const nextPage = page + 1;
    setPage(nextPage);
    fetchEvents(nextPage, true);
  };

  const filteredEvents = (events || []).filter(e => {
    const matchesSearch = !searchQuery || e.eventName?.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesSearch;
  });

  const getCategoryImage = (category: string) => {
    if (!category) return "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&q=80&w=800";
    
    const cat = category.toUpperCase();
    if (cat === 'MOVIE') return "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&q=80&w=800";
    if (cat === 'CONCERT') return "https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?auto=format&fit=crop&q=80&w=800";
    if (cat === 'COMEDY' || cat === 'STANDUP' || cat === 'STAND-UP') return "https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&q=80&w=800";
    if (cat === 'EVERGREEN') return "https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&q=80&w=800";
    
    return "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&q=80&w=800";
  };

  return (
    <div className="w-full">
      {/* Hero Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 text-center space-y-8">
        <h1 className="text-6xl md:text-8xl font-black tracking-tight leading-none text-white">
          EVERY <span className="text-indigo-500">EXPERIENCE</span>,<br />
          JUST A <span className="text-purple-500 uppercase">TICKET</span> AWAY.
        </h1>
        <p className="text-xl text-slate-400 max-w-2xl mx-auto">
          Book the best seats for movies, concerts, and comedy shows worldwide. 
          Experience high-performance ticketing with WaygonWay.
        </p>
        <div className="flex justify-center space-x-4">
          <button 
            onClick={() => document.getElementById('featured-events')?.scrollIntoView({ behavior: 'smooth' })}
            className="bg-white text-slate-950 px-8 py-3 rounded-full font-bold text-lg hover:bg-indigo-100 transition-all transform hover:-translate-y-1 shadow-xl"
          >
            Explore Now
          </button>
          <button 
            onClick={() => navigate('/support')}
            className="border border-slate-700 px-8 py-3 rounded-full font-bold text-lg hover:bg-white/5 transition-all text-white"
          >
            How it works
          </button>
        </div>
      </section>

      {/* Categories */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
          <CategoryCard icon={<Film className="w-6 h-6" />} label="Movies" color="bg-orange-500" />
          <CategoryCard icon={<Music className="w-6 h-6" />} label="Concerts" color="bg-pink-500" />
          <CategoryCard icon={<Mic2 className="w-6 h-6" />} label="Stand-up" color="bg-blue-500" />
          <CategoryCard icon={<Star className="w-6 h-6" />} label="Evergreen" color="bg-indigo-500" />
        </div>
      </section>

      {/* Featured Events */}
      <section id="featured-events" className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24 space-y-12">
        <div className="flex flex-col md:flex-row justify-between items-end space-y-6 md:space-y-0">
          <div>
            <h2 className="text-3xl font-bold text-white">
              {currentCategory ? `${currentCategory} Events` : 'Featured Events'}
            </h2>
            <p className="text-slate-400">Handpicked experiences for you</p>
          </div>
          
          <div className="relative w-full md:w-96">
            <SearchIcon className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
            <input 
              type="text" 
              placeholder="Search by event name..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-slate-900 border border-slate-800 rounded-2xl py-3 pl-12 pr-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all shadow-lg"
            />
          </div>
        </div>
        
        {loading ? (
          <div className="flex justify-center py-20">
            <Loader2 className="w-12 h-12 text-indigo-500 animate-spin" />
          </div>
        ) : filteredEvents.length === 0 ? (
          <div className="text-center py-20 bg-slate-900/50 rounded-3xl border border-slate-800 border-dashed">
            <p className="text-slate-500 text-lg italic">No events found matching your criteria.</p>
          </div>
        ) : (
          <div className="space-y-12">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              {filteredEvents.map((event) => (
                <EventCard 
                  key={event.id}
                  id={event.id}
                  image={getCategoryImage(event.category)}
                  title={event.eventName}
                  date={new Date(event.startDateTime).toLocaleDateString()}
                  location={event.venue}
                  price={`$${event.basePrice}`}
                />
              ))}
            </div>
            
            {page < totalPages - 1 && (
              <div className="flex justify-center pt-8">
                <button 
                  onClick={handleLoadMore}
                  disabled={loadingMore}
                  className="bg-slate-900 hover:bg-slate-800 border border-slate-800 text-white font-bold px-12 py-4 rounded-full transition-all flex items-center space-x-3 shadow-xl group disabled:opacity-50"
                >
                  {loadingMore ? (
                    <Loader2 className="w-5 h-5 animate-spin" />
                  ) : (
                    <>
                      <span>Load More Experiences</span>
                      <Star className="w-5 h-5 group-hover:rotate-12 transition-transform text-indigo-500" />
                    </>
                  )}
                </button>
              </div>
            )}
          </div>
        )}
      </section>
    </div>
  );
};

function CategoryCard({ icon, label, color }: { icon: React.ReactNode, label: string, color: string }) {
  const [, setSearchParams] = useSearchParams();
  
  return (
    <div 
      onClick={() => setSearchParams({ category: label.toLowerCase() })}
      className="bg-slate-900 border border-slate-800 p-8 rounded-2xl hover:bg-slate-800/50 transition-all cursor-pointer group shadow-md shadow-slate-950/30"
    >
      <div className={`${color} w-12 h-12 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform text-white`}>
        {icon}
      </div>
      <h3 className="font-bold text-lg text-white">{label}</h3>
    </div>
  );
}

export default Home;
