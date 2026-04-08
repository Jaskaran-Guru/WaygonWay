package com.waygonway.config;

import com.waygonway.entities.Event;
import com.waygonway.repositories.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Component
public class DataSeeder implements CommandLineRunner {

    @Autowired
    private EventRepository eventRepository;

    @Override
    public void run(String... args) throws Exception {
        try {
            System.out.println("DataSeeder: Checking database for events...");
            long count = eventRepository.count();
            
            // Only seed if database is empty
            if (count == 0) {
                System.out.println("DataSeeder: Database is empty. Seeding initial event data...");

                List<Event> events = Arrays.asList(
                    createEvent("Avengers: Secret Wars", "MOVIE", "PVR IMAX Cinemas", "Mumbai", 
                        "The ultimate Avengers showdown - all timelines collide!", 350.0, 120, 120,
                        LocalDateTime.now().plusDays(3), LocalDateTime.now().plusDays(3).plusHours(3)),

                    createEvent("Pathaan 2", "MOVIE", "INOX Megaplex", "Delhi", 
                        "Shah Rukh Khan returns in the biggest action blockbuster of 2026.", 299.0, 85, 100,
                        LocalDateTime.now().plusDays(5), LocalDateTime.now().plusDays(5).plusHours(2)),

                    createEvent("Coldplay World Tour - India", "CONCERT", "DY Patil Stadium", "Mumbai", 
                        "Coldplay's legendary Music of the Spheres world tour hits India!", 4500.0, 15000, 20000,
                        LocalDateTime.now().plusDays(10), LocalDateTime.now().plusDays(10).plusHours(4)),

                    createEvent("Arijit Singh Live in Concert", "CONCERT", "Jawaharlal Nehru Stadium", "Delhi", 
                        "An evening of soul-stirring melodies with Bollywood's most loved singer.", 2000.0, 8500, 10000,
                        LocalDateTime.now().plusDays(7), LocalDateTime.now().plusDays(7).plusHours(3)),

                    createEvent("The Weekend Live India Tour", "CONCERT", "MMRDA Grounds", "Mumbai", 
                        "After Dawn and Starboy - The Weekend brings his Nights tour to India!", 5500.0, 12000, 15000,
                        LocalDateTime.now().plusDays(14), LocalDateTime.now().plusDays(14).plusHours(3)),

                    createEvent("Zakir Khan: Kuch Bhi Ho Sakta Hai", "COMEDY", "Siri Fort Auditorium", "Delhi", 
                        "Zakir Khan's brand new stand-up special featuring stories from life.", 799.0, 200, 500,
                        LocalDateTime.now().plusDays(4), LocalDateTime.now().plusDays(4).plusHours(2)),

                    createEvent("Vir Das: Fool For Life", "COMEDY", "NCPA Tata Theatre", "Mumbai", 
                        "Vir Das returns with his most personal and hilarious show yet!", 1200.0, 350, 500,
                        LocalDateTime.now().plusDays(6), LocalDateTime.now().plusDays(6).plusHours(2)),

                    createEvent("Kapil Sharma Live", "COMEDY", "Royal Opera House", "Mumbai", 
                        "An evening of unlimited laughs with India's comedy king Kapil Sharma.", 1500.0, 450, 600,
                        LocalDateTime.now().plusDays(8), LocalDateTime.now().plusDays(8).plusHours(2)),

                    createEvent("Biswa Kalyan Rath: Sushi Show", "COMEDY", "Chowdiah Memorial Hall", "Bengaluru", 
                        "Engineer-turned-comedian Biswa is back with his most absurd show yet!", 999.0, 280, 400,
                        LocalDateTime.now().plusDays(9), LocalDateTime.now().plusDays(9).plusHours(2)),

                    createEvent("Dune: Messiah", "MOVIE", "Cinepolis GVK One", "Hyderabad", 
                        "The epic conclusion to the Dune saga - stunning IMAX visuals await.", 400.0, 95, 150,
                        LocalDateTime.now().plusDays(2), LocalDateTime.now().plusDays(2).plusHours(3)),

                    createEvent("Sunburn Festival 2026", "CONCERT", "Vagator, Goa", "Goa", 
                        "Asia's biggest EDM festival returns to the beaches of Goa!", 3500.0, 7000, 10000,
                        LocalDateTime.now().plusDays(20), LocalDateTime.now().plusDays(22)),

                    createEvent("AR Rahman: Symphony Tour", "CONCERT", "Lal Bahadur Shastri Stadium", "Hyderabad", 
                        "A Jai Ho night with India's maestro - symphony orchestra and classics.", 2500.0, 5000, 8000,
                        LocalDateTime.now().plusDays(12), LocalDateTime.now().plusDays(12).plusHours(4)),

                    createEvent("The Great Gatsby - Theatre", "EVERGREEN", "Royal Opera House", "Mumbai", 
                        "A timeless classic play that never grows old.", 1500.0, 100, 200,
                        LocalDateTime.now().plusDays(30), LocalDateTime.now().plusDays(30).plusHours(3)),

                    createEvent("Classic Piano Night", "EVERGREEN", "NCPA Tata Theatre", "Mumbai", 
                        "Experience the masterpieces of Mozart and Beethoven.", 1200.0, 150, 300,
                        LocalDateTime.now().plusDays(35), LocalDateTime.now().plusDays(35).plusHours(2)),

                    createEvent("Traditional Art Exhibition", "EVERGREEN", "Jehangir Art Gallery", "Mumbai", 
                        "A curated collection of Indian classical art.", 500.0, 500, 500,
                        LocalDateTime.now().plusDays(40), LocalDateTime.now().plusDays(40).plusHours(10))
                );

                eventRepository.saveAll(events);
                System.out.println("DataSeeder: Successfully seeded " + events.size() + " events into MongoDB Atlas!");
            } else {
                System.out.println("DataSeeder: Database already has " + count + " events, skipping seed.");
            }
        } catch (Exception e) {
            System.err.println("DataSeeder: Error during seeding process: " + e.getMessage());
            // We don't rethrow to avoid blocking startup
        }
    }

    private Event createEvent(String name, String category, String venue, String location,
                               String description, Double price, Integer available, Integer total,
                               LocalDateTime start, LocalDateTime end) {
        Event event = new Event();
        event.setEventName(name);
        event.setCategory(category);
        event.setVenue(venue);
        event.setLocation(location);
        event.setDescription(description);
        event.setBasePrice(price);
        event.setAvailableSeats(available);
        event.setTotalSeats(total);
        event.setStartDateTime(start);
        event.setEndDateTime(end);
        event.setOrganizerId("system");
        return event;
    }
}
