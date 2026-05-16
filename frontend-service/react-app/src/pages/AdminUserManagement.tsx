import { useEffect, useState } from 'react';
import { adminApi } from '../services/api';
import { 
  Users, 
  Search, 
  Shield, 
  ShieldAlert, 
  Trash2, 
  Mail,
  MapPin,
  CheckCircle2,
  XCircle,
  Loader2,
  ChevronLeft,
  ChevronRight,
  MoreVertical,
  Download
} from 'lucide-react';

const AdminUserManagement = () => {
  const [users, setUsers] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterRole, setFilterRole] = useState('ALL');
  const [filterStatus, setFilterStatus] = useState('ALL');
  
  
  const [page, setPage] = useState(0);
  const [size] = useState(10);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);

  
  const [selectedUserIds, setSelectedUserIds] = useState<string[]>([]);

  useEffect(() => {
    fetchUsers();
  }, [page, filterRole, filterStatus]);

  const fetchUsers = async () => {
    setLoading(true);
    try {
      
      const response = await adminApi.getUsersPaged(page, size);
      const data = response.data.data;
      setUsers(data.content);
      setTotalPages(data.totalPages);
      setTotalElements(data.totalElements);
    } catch (error) {
      console.error("Failed to fetch users:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleToggleStatus = async (userId: string, currentStatus: string) => {
    const newStatus = currentStatus === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE';
    try {
      await adminApi.updateUserStatus(userId, newStatus);
      fetchUsers();
    } catch (error) {
      alert("Failed to update user status");
    }
  };

  const handleToggleRole = async (userId: string, currentRole: string) => {
    const newRole = currentRole === 'ADMIN' ? 'USER' : 'ADMIN';
    if (window.confirm(`Are you sure you want to change this user's role to ${newRole}?`)) {
      try {
        await adminApi.updateUserRole(userId, newRole);
        fetchUsers();
      } catch (error) {
        alert("Failed to update user role");
      }
    }
  };

  const handleBulkStatusUpdate = async (status: string) => {
    if (selectedUserIds.length === 0) return;
    try {
      await adminApi.bulkUpdateStatus(selectedUserIds, status);
      setSelectedUserIds([]);
      fetchUsers();
    } catch (error) {
      alert("Bulk update failed");
    }
  };

  const toggleSelectAll = () => {
    if (selectedUserIds.length === filteredUsers.length) {
      setSelectedUserIds([]);
    } else {
      setSelectedUserIds(filteredUsers.map(u => u.id));
    }
  };

  const toggleSelectUser = (userId: string) => {
    setSelectedUserIds(prev => 
      prev.includes(userId) ? prev.filter(id => id !== userId) : [...prev, userId]
    );
  };

  const handleDeleteUser = async (userId: string) => {
    if (window.confirm("Are you sure you want to delete this user? This action is IRREVERSIBLE.")) {
      try {
        await adminApi.deleteUser(userId);
        fetchUsers();
      } catch (error) {
        alert("Failed to delete user");
      }
    }
  };

  const handleExportCSV = () => {
    const headers = ["ID", "Username", "Email", "First Name", "Last Name", "Role", "Status", "City", "Country"];
    const csvContent = [
      headers.join(","),
      ...users.map(u => [
        u.id,
        u.username,
        u.email,
        u.firstName,
        u.lastName,
        u.role,
        u.status,
        u.address?.city || 'N/A',
        u.address?.country || 'India'
      ].map(field => `"${field}"`).join(","))
    ].join("\n");

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement("a");
    const url = URL.createObjectURL(blob);
    link.setAttribute("href", url);
    link.setAttribute("download", `users_export_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const filteredUsers = users.filter(user => {
    const matchesSearch = 
      user.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      `${user.firstName} ${user.lastName}`.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesRole = filterRole === 'ALL' || user.role === filterRole;
    const matchesStatus = filterStatus === 'ALL' || user.status === filterStatus;

    return matchesSearch && matchesRole && matchesStatus;
  });

  return (
    <div className="max-w-[1920px] mx-auto px-4 sm:px-6 lg:px-8 py-12 space-y-8">
      {}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center space-y-4 md:space-y-0">
        <div>
          <h1 className="text-4xl font-black text-white flex items-center space-x-3">
            <Users className="w-10 h-10 text-indigo-500" />
            <span>User Management</span>
          </h1>
          <p className="text-slate-400 mt-1">Monitor and moderate registered user accounts</p>
        </div>
        <button 
          onClick={handleExportCSV}
          className="flex items-center space-x-2 bg-slate-900 hover:bg-slate-800 border border-slate-800 px-6 py-3 rounded-2xl text-slate-300 hover:text-white transition-all shadow-xl font-bold group"
        >
          <Download className="w-5 h-5 group-hover:-translate-y-1 transition-transform" />
          <span>Export Users</span>
        </button>
      </div>

      {}
      <div className="bg-slate-900/50 border border-slate-800 p-6 rounded-3xl flex flex-col md:flex-row gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
          <input 
            type="text" 
            placeholder="Search users by name, email, or username..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full bg-slate-950 border border-slate-800 rounded-2xl py-3 pl-12 pr-4 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 transition-all"
          />
        </div>
        <div className="flex gap-4">
          <select 
            value={filterRole}
            onChange={(e) => setFilterRole(e.target.value)}
            className="bg-slate-950 border border-slate-800 rounded-2xl px-4 py-3 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 appearance-none"
          >
            <option value="ALL">All Roles</option>
            <option value="USER">User</option>
            <option value="ADMIN">Admin</option>
          </select>
          <select 
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
            className="bg-slate-950 border border-slate-800 rounded-2xl px-4 py-3 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500/50 appearance-none"
          >
            <option value="ALL">All Status</option>
            <option value="ACTIVE">Active</option>
            <option value="SUSPENDED">Suspended</option>
          </select>
        </div>
      </div>

      {}
      {selectedUserIds.length > 0 && (
        <div className="bg-indigo-600 px-6 py-4 rounded-3xl flex items-center justify-between animate-in slide-in-from-top-4 duration-300">
          <div className="flex items-center space-x-4">
            <span className="text-white font-bold">{selectedUserIds.length} users selected</span>
            <button 
              onClick={() => handleBulkStatusUpdate('ACTIVE')}
              className="bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-xl text-xs font-black uppercase tracking-widest transition-colors"
            >
              Bulk Activate
            </button>
            <button 
              onClick={() => handleBulkStatusUpdate('SUSPENDED')}
              className="bg-rose-500 hover:bg-rose-600 text-white px-4 py-2 rounded-xl text-xs font-black uppercase tracking-widest transition-colors shadow-lg shadow-rose-900/40"
            >
              Bulk Suspend
            </button>
          </div>
          <button 
            onClick={() => setSelectedUserIds([])}
            className="text-white/60 hover:text-white transition-colors p-2"
          >
            <XCircle className="w-6 h-6" />
          </button>
        </div>
      )}

      {}
      <div className="bg-slate-900 border border-slate-800 rounded-3xl overflow-hidden shadow-2xl">
        {loading ? (
          <div className="py-20 flex flex-col items-center justify-center space-y-4">
            <Loader2 className="w-12 h-12 text-indigo-500 animate-spin" />
            <p className="text-slate-500 animate-pulse">Retreiving user vault...</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-slate-950/50 text-slate-500 text-[10px] uppercase tracking-widest font-black border-b border-slate-800">
                  <th className="px-8 py-5 w-10">
                    <input 
                      type="checkbox" 
                      onChange={toggleSelectAll}
                      checked={selectedUserIds.length === filteredUsers.length && filteredUsers.length > 0}
                      className="w-4 h-4 rounded border-slate-700 bg-slate-900 text-indigo-600 focus:ring-indigo-500 cursor-pointer"
                    />
                  </th>
                  <th className="px-8 py-5">User Profile</th>
                  <th className="px-8 py-5">Role</th>
                  <th className="px-8 py-5">Location</th>
                  <th className="px-8 py-5">Status</th>
                  <th className="px-8 py-5 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800">
                {filteredUsers.map((user) => (
                  <tr key={user.id} className={`hover:bg-white/[0.02] transition-colors group ${selectedUserIds.includes(user.id) ? 'bg-indigo-500/5' : ''}`}>
                    <td className="px-8 py-6">
                      <input 
                        type="checkbox" 
                        checked={selectedUserIds.includes(user.id)}
                        onChange={() => toggleSelectUser(user.id)}
                        className="w-4 h-4 rounded border-slate-700 bg-slate-900 text-indigo-600 focus:ring-indigo-500 cursor-pointer"
                      />
                    </td>
                    <td className="px-8 py-6">
                      <div className="flex items-center space-x-4">
                        <div className="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl flex items-center justify-center text-white font-black text-xl shadow-lg group-hover:scale-110 transition-transform">
                          {user.firstName ? user.firstName[0] : 'U'}{user.lastName ? user.lastName[0] : 'U'}
                        </div>
                        <div>
                          <p className="text-white font-bold text-lg leading-none">{user.firstName} {user.lastName}</p>
                          <p className="text-slate-500 text-sm mt-1 flex items-center">
                            <Mail className="w-3 h-3 mr-1" />
                            @{user.username}  {user.email}
                          </p>
                        </div>
                      </div>
                    </td>
                    <td className="px-8 py-6">
                      <div className={`inline-flex items-center space-x-1.5 px-3 py-1 rounded-full text-[10px] font-black tracking-widest uppercase
                        ${user.role === 'ADMIN' ? 'bg-purple-500/10 text-purple-400 border border-purple-500/20' : 'bg-slate-800 text-slate-400'}`}>
                        {user.role === 'ADMIN' ? <Shield className="w-3 h-3" /> : <Users className="w-3 h-3" />}
                        <span>{user.role}</span>
                      </div>
                    </td>
                    <td className="px-8 py-6">
                      <div className="flex items-center space-x-2 text-slate-400 text-sm">
                        <MapPin className="w-4 h-4 text-slate-600" />
                        <span>{user.address?.city || 'Not set'}, {user.address?.country || 'India'}</span>
                      </div>
                    </td>
                    <td className="px-8 py-6">
                      <div className={`flex items-center space-x-1.5 font-bold text-sm
                        ${user.status === 'ACTIVE' ? 'text-emerald-500' : 'text-rose-500'}`}>
                        {user.status === 'ACTIVE' ? <CheckCircle2 className="w-4 h-4" /> : <XCircle className="w-4 h-4" />}
                        <span className="uppercase tracking-wider">{user.status}</span>
                      </div>
                    </td>
                    <td className="px-8 py-6">
                      <div className="flex justify-end space-x-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <button 
                          onClick={() => handleToggleRole(user.id, user.role)}
                          className={`p-2 rounded-xl transition-all shadow-lg
                          ${user.role === 'ADMIN' 
                            ? 'bg-purple-500/10 text-purple-400 hover:bg-purple-500 hover:text-white shadow-purple-500/10' 
                            : 'bg-slate-800 text-slate-400 hover:bg-indigo-500 hover:text-white shadow-indigo-500/10'}`}
                          title={user.role === 'ADMIN' ? 'Demote to User' : 'Promote to Admin'}
                        >
                          <Shield className="w-5 h-5" />
                        </button>
                        <button 
                          onClick={() => handleToggleStatus(user.id, user.status)}
                          className={`p-2 rounded-xl transition-all shadow-lg
                          ${user.status === 'ACTIVE' 
                            ? 'bg-rose-500/10 text-rose-500 hover:bg-rose-500 hover:text-white shadow-rose-500/10' 
                            : 'bg-emerald-500/10 text-emerald-500 hover:bg-emerald-500 hover:text-white shadow-emerald-500/10'}`}
                          title={user.status === 'ACTIVE' ? 'Suspend' : 'Activate'}
                        >
                          {user.status === 'ACTIVE' ? <ShieldAlert className="w-5 h-5" /> : <CheckCircle2 className="w-5 h-5" />}
                        </button>
                        <button 
                          onClick={() => handleDeleteUser(user.id)}
                          className="p-2 bg-slate-800 text-slate-400 hover:bg-red-500 hover:text-white rounded-xl transition-all shadow-lg shadow-black/20"
                          title="Delete"
                        >
                          <Trash2 className="w-5 h-5" />
                        </button>
                        <button className="p-2 text-slate-600 hover:text-white transition-colors">
                          <MoreVertical className="w-5 h-5" />
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
                Showing <span className="text-white">{users.length}</span> of <span className="text-white">{totalElements}</span> users
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

            {filteredUsers.length === 0 && (
              <div className="py-20 flex flex-col items-center justify-center text-slate-500 italic space-y-4">
                <Search className="w-16 h-16 text-slate-800" />
                <p>No user souls matched your search criteria.</p>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default AdminUserManagement;
