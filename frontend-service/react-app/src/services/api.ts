import axios from 'axios';

// Use current origin for API calls to support both localhost and public tunnels
const GATEWAY_URL = window.location.origin;
export const AUTH_SERVICE_URL = GATEWAY_URL;
export const BOOKING_SERVICE_URL = GATEWAY_URL;

// Auth service (port 8081)
const authAxios = axios.create({
  baseURL: AUTH_SERVICE_URL,
});

// Booking/Events/Transport/Support service (port 8082)
const api = axios.create({
  baseURL: BOOKING_SERVICE_URL,
});

// Add JWT token to all requests
const addAuthInterceptor = (instance: ReturnType<typeof axios.create>) => {
  instance.interceptors.request.use((config) => {
    const token = localStorage.getItem('token');
    if (token && config.headers) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  }, (error) => Promise.reject(error));
};

addAuthInterceptor(authAxios);
addAuthInterceptor(api);

export const authApi = {
  login: (credentials: any) => authAxios.post('/api/v1/auth/login', credentials),
  register: (userData: any) => authAxios.post('/api/v1/auth/register', userData),
};

export const bookingApi = {
  getEvents: () => api.get('/api/v1/events'),
  getEventsPaged: (page: number, size: number, category?: string) => {
    let url = `/api/v1/events/paged?page=${page}&size=${size}`;
    if (category) url += `&category=${category}`;
    return api.get(url);
  },
  getEventById: (id: string) => api.get(`/api/v1/events/${id}`),
  createBooking: (bookingData: any) => api.post('/api/v1/bookings', bookingData),
  getUserBookings: (userId: string) => api.get(`/api/v1/bookings/user/${userId}`),
  getDashboardStats: () => api.get('/api/v1/admin/dashboard/stats'),
  createEvent: (eventData: any) => api.post('/api/v1/admin/events', eventData),
  updateEvent: (id: string, eventData: any) => api.put(`/api/v1/admin/events/${id}`, eventData),
  deleteEvent: (id: string) => api.delete(`/api/v1/admin/events/${id}`),
  getAdminEventsPaged: (page: number, size: number) => api.get(`/api/v1/admin/events/paged?page=${page}&size=${size}`),
  getBookingsPaged: (page: number, size: number) => api.get(`/api/v1/bookings/paged?page=${page}&size=${size}`),
  updateBookingStatus: (pnr: string, status: string) => api.put(`/api/v1/bookings/status/${pnr}`, { status }),
  downloadBill: (pnr: string) => api.get(`/api/v1/bookings/bill/${pnr}`, { responseType: 'blob' }),
};

export const organizerApi = {
  getEvents: (organizerId: string) => api.get(`/api/v1/organizer/events?organizerId=${organizerId}`),
  getBookings: (organizerId: string) => api.get(`/api/v1/organizer/bookings?organizerId=${organizerId}`),
  getDashboardStats: (organizerId: string) => api.get(`/api/v1/organizer/dashboard-stats?organizerId=${organizerId}`),
};

export const adminApi = {
  getUsers: () => api.get('/api/v1/admin/users'),
  getUsersPaged: (page: number, size: number, sortBy: string = 'id', sortDir: string = 'asc') => 
    api.get(`/api/v1/admin/users/paged?page=${page}&size=${size}&sortBy=${sortBy}&sortDir=${sortDir}`),
  updateUserStatus: (userId: string, status: string) => api.put(`/api/v1/admin/users/${userId}/status`, { status }),
  updateUserRole: (userId: string, role: string) => api.put(`/api/v1/admin/users/${userId}/role`, { role }),
  deleteUser: (userId: string) => api.delete(`/api/v1/admin/users/${userId}`),
  searchUsers: (query: string) => api.get(`/api/v1/admin/users/search?query=${query}`),
  getStatistics: () => api.get('/api/v1/admin/statistics'),
  bulkUpdateStatus: (userIds: string[], status: string) => api.put('/api/v1/admin/users/bulk-status', { userIds, status }),
};

export const userApi = {
  deleteAccount: (userId: string) => api.delete(`/api/v1/auth/${userId}`),
};

export const transportApi = {
  searchSchedules: (type?: string, source?: string, destination?: string) => {
    let url = '/api/v1/transport/schedules?';
    if (type) url += `type=${type}&`;
    if (source) url += `source=${source}&`;
    if (destination) url += `destination=${destination}`;
    return api.get(url);
  },
  getAllSchedules: () => api.get('/api/v1/transport/schedules'),
  createSchedule: (scheduleData: any) => api.post('/api/v1/transport/schedules', scheduleData),
  deleteSchedule: (id: string) => api.delete(`/api/v1/transport/schedules/${id}`),
  createBooking: (bookingData: any) => api.post('/api/v1/transport/bookings', bookingData),

  getUserBookings: (userId: string) => api.get(`/api/v1/transport/bookings/user/${userId}`),
  getAllBookings: () => api.get('/api/v1/transport/admin/bookings/all'),
  updateBookingStatus: (pnr: string, status: string) => api.put(`/api/v1/transport/bookings/status/${pnr}`, { status })
};

export const supportApi = {
  createTicket: (ticketData: any) => api.post('/api/v1/support', ticketData),
  getUserTickets: (userId: string) => api.get(`/api/v1/support/user/${userId}`),
  getAllTickets: () => api.get('/api/v1/support/admin/all'),
  resolveTicket: (ticketId: string, resolutionNotes: string) => api.put(`/api/v1/support/admin/resolve/${ticketId}`, { resolutionNotes })
};

export default api;
