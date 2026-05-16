import React, { useState } from 'react';

interface SeatLayoutProps {
  onSelect: (selectedSeats: string[]) => void;
}

const SeatLayout: React.FC<SeatLayoutProps> = ({ onSelect }) => {
  const [selected, setSelected] = useState<string[]>([]);

  
  const rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  const seatsPerRow = 10;
  
  const toggleSeat = (id: string) => {
    const newSelected = selected.includes(id)
      ? selected.filter(s => s !== id)
      : [...selected, id];
    
    setSelected(newSelected);
    onSelect(newSelected);
  };

  return (
    <div className="bg-slate-900 p-8 rounded-3xl border border-slate-800 space-y-8">
      <div className="flex justify-center mb-12">
        <div className="w-2/3 h-2 bg-indigo-500/20 rounded-full relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-transparent via-indigo-500/50 to-transparent animate-pulse"></div>
          <p className="text-center text-[10px] uppercase tracking-[0.2em] text-indigo-400 mt-4 font-bold">Screen / Stage This Way</p>
        </div>
      </div>

      <div className="grid gap-4 justify-center">
        {rows.map((row) => (
          <div key={row} className="flex gap-4 items-center">
            <span className="w-6 text-slate-500 font-bold text-sm">{row}</span>
            <div className="flex gap-2">
              {Array.from({ length: seatsPerRow }).map((_, i) => {
                const id = `${row}${i + 1}`;
                const isSelected = selected.includes(id);
                const isReserved = Math.random() < 0.1; 

                return (
                  <button
                    key={id}
                    disabled={isReserved}
                    onClick={() => toggleSeat(id)}
                    className={`w-8 h-8 rounded-md text-[10px] font-bold transition-all transform hover:scale-110 
                      ${isReserved ? 'bg-slate-800 text-slate-600 cursor-not-allowed' : 
                        isSelected ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-500/40 scale-110' : 
                        'bg-slate-700 text-slate-400 hover:bg-slate-600'}`}
                  >
                    {i + 1}
                  </button>
                );
              })}
            </div>
          </div>
        ))}
      </div>

      <div className="flex justify-center space-x-8 pt-8 border-t border-slate-800">
        <StatusIndicator color="bg-slate-700" label="Available" />
        <StatusIndicator color="bg-indigo-600" label="Selected" />
        <StatusIndicator color="bg-slate-800" label="Reserved" />
      </div>
    </div>
  );
};

function StatusIndicator({ color, label }: { color: string, label: string }) {
  return (
    <div className="flex items-center space-x-2">
      <div className={`w-4 h-4 rounded ${color}`}></div>
      <span className="text-sm text-slate-400">{label}</span>
    </div>
  );
}

export default SeatLayout;
