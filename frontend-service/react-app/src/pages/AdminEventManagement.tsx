import { useEffect, useState } from 'react';
import { bookingApi } from '../services/api';
import { 
  Plus, 
  Edit2, 
  Trash2, 
  Search, 
  Loader2,
  X,
  Save,
  ChevronLeft,
  ChevronRight,
  Download
} from 'lucide-react';

const AdminEventManagement = () => {
  const [events, setEvents] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingEvent, setEditingEvent] = useState<any>(null);
  
  
  const [page, setPage] = useState(0);
  const [size] = useState(10);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);

  const [formData, setFormData] = useState({
    eventName: '',
    category: 'Movies',
    venue: '',
    location: '',
    description: '',
    basePrice: 0,
    totalSeats: 0,
    availableSeats: 0,
    startDateTime: '',
    endDateTime: ''
  });

  const fetchEvents = async () => {
    setLoading(true);
    try {
      const response = await bookingApi.getAdminEventsPaged(page, size);
      const data = response.data;
      setEvents(data.content);
      setTotalPages(data.totalPages);
      setTotalElements(data.totalElements);
    } catch (error) {
      console.error("Failed to fetch events:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchEvents();
  }, [page]);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingEvent) {
        await bookingApi.updateEvent(editingEvent.id, formData);
      } else {
        await bookingApi.createEvent(formData);
      }
      setIsModalOpen(false);
      fetchEvents();
    } catch (error) {
      alert("Failed to save event. Please check your data.");
    }
  };

  const handleExportCSV = () => {
    const headers = ["ID", "Event Name", "Category", "Venue", "Location", "Price", "Total Seats", "Available Seats", "Date"];
    const csvContent = [
      headers.join(","),
      ...events.map(e => [
        e.id,
        e.eventName,
        e.category,
        e.venue,
        e.location,
        e.basePrice,
        e.totalSeats,
        e.availableSeats,
        new Date(e.startDateTime).toLocaleDateString()
      ].map(field => `"${field}"`).join(","))
    ].join("\n");

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement("a");
    const url = URL.createObjectURL(blob);
    link.setAttribute("href", url);
    link.setAttribute("download", `events_export_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const openModal = (event: any = null) => {
    if (event) {
      setEditingEvent(event);
      setFormData({
        ...event,
        startDateTime: event.startDateTime.split('.')[0], 
        endDateTime: event.endDateTime?.split('.')[0] || ''
      });
    } else {
      setEditingEvent(null);
      setFormData({
        eventName: '',
        category: 'Movies',
        venue: '',
        location: '',
        description: '',
        basePrice: 0,
        totalSeats: 0,
        availableSeats: 0,
        startDateTime: '',
        endDateTime: ''
      });
    }
    setIsModalOpen(true);
  };

  const handleDelete = async (id: string) => {
    if (window.confirm("Are you sure you want to delete this event? This action cannot be undone.")) {
      try {
        await bookingApi.deleteEvent(id);
        fetchEvents();
      } catch (error) {
        alert("Failed to delete event. Please try again.");
      }
    }
  };

  const filteredEvents = events.filter((e: any) => 
    e.eventName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    e.category.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-8">
      {}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center space-y-4 md:space-y-0 text-white">
        <div className="space-y-1 text-white">
          <h1 className="text-3xl font-black text-white">Event Management</h1>
          <p className="text-slate-400">Create, edit, and organize platform experiences</p>
        </div>
        <div className="flex items-center space-x-4">
          <button 
            onClick={handleExportCSV}
            className="flex items-center space-x-2 bg-slate-900 hover:bg-slate-800 border border-slate-800 px-6 py-3 rounded-2xl text-slate-300 hover:text-white transition-all shadow-xl font-bold group"
          >
            <Download className="w-5 h-5 group-hover:-translate-y-1 transition-transform" />
            <span>Export Events</span>
          </button>
          <button 
            onClick={() => openModal()}
            className="bg-indigo-600 hover:bg-indigo-700 text-white font-bold px-6 py-3 rounded-2xl flex items-center space-x-2 shadow-lg shadow-indigo-500/20 transition-all transform active:scale-95 leading-none"
          >
            <Plus className="w-5 h-5" />
            <span>Create New Event</span>
          </button>
        </div>
      </div>

      {}
      <div className="flex flex-col md:flex-row space-y-4 md:space-y-0 md:space-x-4">
        <div className="relative flex-1">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
          <input 
            type="text" 
            placeholder="Search events by name or category..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full bg-slate-900 border border-slate-800 rounded-2xl py-3 pl-12 pr-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all"
          />
        </div>
      </div>

      {loading ? (
        <div className="flex justify-center py-20">
          <Loader2 className="w-12 h-12 text-indigo-500 animate-spin" />
        </div>
      ) : (
        <div className="bg-slate-900 border border-slate-800 rounded-3xl overflow-hidden shadow-2xl text-white">
          <div className="overflow-x-auto text-white">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-slate-950/50 border-b border-slate-800 text-slate-500 text-[10px] uppercase tracking-widest font-black">
                  <th className="px-8 py-5">Event Details</th>
                  <th className="px-8 py-5">Category</th>
                  <th className="px-8 py-5">Venue & Location</th>
                  <th className="px-8 py-5 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800/50">
                {filteredEvents.map((event) => (
                  <tr key={event.id} className="group hover:bg-white/[0.02] transition-colors">
                    <td className="px-8 py-6">
                      <div className="flex items-center space-x-4">
                        <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-indigo-500/20 to-purple-600/20 flex items-center justify-center font-black text-indigo-400 border border-indigo-500/20 shadow-inner group-hover:scale-110 transition-transform">
                          {event.eventName[0]}
                        </div>
                        <div>
                          <p className="text-white font-bold text-lg leading-tight">{event.eventName}</p>
                          <p className="text-slate-500 text-xs mt-1 font-medium">{new Date(event.startDateTime).toLocaleDateString(undefined, { dateStyle: 'long' })}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-8 py-6">
                      <span className="bg-indigo-500/10 text-indigo-400 px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest border border-indigo-500/20">
                        {event.category}
                      </span>
                    </td>
                    <td className="px-8 py-6">
                      <p className="text-slate-300 font-bold">{event.venue}</p>
                      <p className="text-slate-500 text-xs font-medium">{event.location}</p>
                    </td>
                    <td className="px-8 py-6 text-right">
                      <div className="flex justify-end items-center space-x-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <button 
                          onClick={() => openModal(event)}
                          className="p-2.5 bg-slate-800 text-slate-400 hover:text-indigo-400 hover:bg-indigo-400/10 rounded-xl transition-all shadow-lg shadow-black/20"
                          title="Edit Event"
                        >
                          <Edit2 className="w-5 h-5" />
                        </button>
                        <button 
                          onClick={() => handleDelete(event.id)}
                          className="p-2.5 bg-slate-800 text-slate-400 hover:text-red-400 hover:bg-red-400/10 rounded-xl transition-all shadow-lg shadow-black/20"
                          title="Delete Event"
                        >
                          <Trash2 className="w-5 h-5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            {}
            <div className="bg-slate-950/50 px-8 py-5 border-t border-slate-800 flex items-center justify-between">
              <div className="text-slate-500 text-xs font-bold">
                Showing <span className="text-white">{events.length}</span> of <span className="text-white">{totalElements}</span> events
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
          
          {filteredEvents.length === 0 && !loading && (
            <div className="py-20 flex flex-col items-center justify-center text-slate-500 italic space-y-4">
              <Search className="w-16 h-16 text-slate-800" />
              <p>No events found for your search.</p>
            </div>
          )}
        </div>
      )}

      {}
      {isModalOpen && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm">
          <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-2xl max-h-[90vh] overflow-y-auto overflow-x-hidden shadow-2xl relative animate-in zoom-in-95 duration-200">
            <div className="sticky top-0 bg-slate-900 px-8 py-6 border-b border-slate-800 flex justify-between items-center z-10 text-white">
              <h2 className="text-2xl font-black text-white uppercase tracking-tight">{editingEvent ? 'Modifier Event' : 'Create New Experience'}</h2>
              <button 
                onClick={() => setIsModalOpen(false)}
                className="p-2 hover:bg-white/5 rounded-xl text-slate-400 transition-colors"
                title="Close"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleSave} className="p-8 space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Event Name</label>
                  <input 
                    type="text" 
                    value={formData.eventName}
                    onChange={(e) => setFormData({...formData, eventName: e.target.value})}
                    placeholder="e.g. Neon Nights Concert"
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3.5 px-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all placeholder:text-slate-700 font-medium"
                    required
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Category</label>
                  <select 
                    value={formData.category}
                    onChange={(e) => setFormData({...formData, category: e.target.value})}
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3.5 px-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all font-medium appearance-none"
                  >
                    <option>Movies</option>
                    <option>Concerts</option>
                    <option>Comedy</option>
                    <option>Sports</option>
                  </select>
                </div>
                <div className="space-y-2 text-white">
                  <label className="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Venue</label>
                  <input 
                    type="text" 
                    value={formData.venue}
                    onChange={(e) => setFormData({...formData, venue: e.target.value})}
                    placeholder="e.g. Grand Arena"
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3.5 px-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all placeholder:text-slate-700 font-medium"
                    required
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Location</label>
                  <input 
                    type="text" 
                    value={formData.location}
                    onChange={(e) => setFormData({...formData, location: e.target.value})}
                    placeholder="e.g. Mumbai, BKC"
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3.5 px-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all placeholder:text-slate-700 font-medium"
                    required
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Base Price ($)</label>
                  <input 
                    type="number" 
                    value={formData.basePrice}
                    onChange={(e) => setFormData({...formData, basePrice: parseFloat(e.target.value)})}
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3.5 px-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all font-bold"
                    required
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Total Seats</label>
                  <input 
                    type="number" 
                    value={formData.totalSeats}
                    onChange={(e) => setFormData({...formData, totalSeats: parseInt(e.target.value), availableSeats: parseInt(e.target.value)})}
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3.5 px-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all font-bold"
                    required
                  />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Event Timing</label>
                  <input 
                    type="datetime-local" 
                    value={formData.startDateTime}
                    onChange={(e) => setFormData({...formData, startDateTime: e.target.value})}
                    className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3.5 px-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all font-medium color-scheme-dark"
                    required
                  />
                </div>
              </div>
              
              <div className="space-y-2">
                <label className="text-[10px] font-black uppercase tracking-widest text-slate-500 ml-1">Description</label>
                <textarea 
                  value={formData.description}
                  onChange={(e) => setFormData({...formData, description: e.target.value})}
                  placeholder="Tell the world about this experience..."
                  className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3.5 px-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all h-32 resize-none font-medium placeholder:text-slate-700"
                  required
                ></textarea>
              </div>

              <div className="pt-4 flex space-x-4">
                <button 
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="flex-1 bg-slate-800 hover:bg-slate-700 text-slate-300 font-bold py-4 rounded-2xl transition-all border border-slate-700 shadow-xl"
                >
                  Discard Changes
                </button>
                <button 
                  type="submit"
                  className="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white font-black py-4 rounded-2xl flex items-center justify-center space-x-2 shadow-xl shadow-indigo-600/30 transition-all uppercase tracking-widest text-xs"
                >
                  <Save className="w-5 h-5" />
                  <span>{editingEvent ? 'Save Updates' : 'Publish Event'}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminEventManagement;
