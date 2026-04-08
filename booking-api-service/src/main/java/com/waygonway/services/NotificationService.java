package com.waygonway.services;

import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;
import com.waygonway.entities.Booking;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;

@Service
public class NotificationService {

    @Async
    public void sendTicketEmail(Booking booking) {
        try {
            byte[] pdfBytes = generateTicketPdf(booking);
            String recipientEmail = booking.getCustomerEmail();
            
            // Email simulation - log the ticket would be sent
            System.out.println("[TICKET] Booking confirmed for " + booking.getCustomerName() +
                " | PNR: " + booking.getPnr() +
                " | Email: " + (recipientEmail != null ? recipientEmail : "N/A") +
                " | PDF Size: " + pdfBytes.length + " bytes");

        } catch (Exception e) {
            System.err.println("Failed to generate ticket: " + e.getMessage());
        }
    }

    private byte[] generateTicketPdf(Booking booking) throws Exception {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, out);
        
        document.open();
        
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24);
        Font subFont = FontFactory.getFont(FontFactory.HELVETICA, 16);
        Font textFont = FontFactory.getFont(FontFactory.HELVETICA, 12);
        
        Paragraph title = new Paragraph("WAYGONWAY ADMISSION PASS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Event: " + booking.getEventName(), subFont));
        document.add(new Paragraph("Date: " + booking.getEventDateTime(), textFont));
        document.add(new Paragraph("Venue: " + booking.getVenue(), textFont));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Booking Reference (PNR): " + booking.getPnr(), subFont));
        document.add(new Paragraph("Customer Name: " + booking.getCustomerName(), textFont));
        document.add(new Paragraph("Seats: " + booking.getSeats(), textFont));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Please bring this digital pass and a valid ID to the gate.", textFont));
        
        document.close();
        
        return out.toByteArray();
    }
}
