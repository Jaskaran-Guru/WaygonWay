import { useNavigate } from 'react-router-dom';

interface EventCardProps {
  id: string;
  image: string;
  title: string;
  date: string;
  location: string;
  price: string;
}

const EventCard: React.FC<EventCardProps> = ({ id, image, title, date, location, price }) => {
  const navigate = useNavigate();

  return (
    <div 
      onClick={() => navigate(`/event/${id}`)}
      className="bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden hover:border-indigo-500/50 transition-all group cursor-pointer shadow-lg shadow-slate-950/50"
    >
      <div className="relative h-48 overflow-hidden">
        <img 
          src={image} 
          alt={title} 
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
          onError={(e) => {
            (e.target as HTMLImageElement).src = "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&q=80&w=800";
          }}
        />
        <div className="absolute bottom-4 right-4 bg-indigo-600 px-3 py-1 rounded-full font-bold text-sm text-white">
          {price}
        </div>
      </div>
      <div className="p-6 space-y-4">
        <div>
          <h3 className="text-xl font-bold group-hover:text-indigo-400 transition-colors text-white">{title}</h3>
          <p className="text-slate-400 text-sm">{date}</p>
        </div>
        <p className="text-slate-500 text-sm">{location}</p>
      </div>
    </div>
  );
};

export default EventCard;
