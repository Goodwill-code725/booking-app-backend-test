import express from 'express';
import { PrismaClient } from '@prisma/client';
import dotenv from 'dotenv';
import cors from 'cors';  
import bcryptjs from 'bcryptjs';
import path from 'path';
import multer from 'multer';
import nodemailer from 'nodemailer';
import fs from 'fs';
import { fileURLToPath } from 'url';
import { createClient } from '@supabase/supabase-js';
import ws from 'ws';
dotenv.config();
const app = express();
const prisma = new PrismaClient();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

//helper
async function uploadToSupabase(file) {
  const fileName = `${Date.now()}-${file.originalname}`;

  const { data, error } = await supabase.storage
    .from(BUCKET_NAME)
    .upload(fileName, file.buffer, {
      contentType: file.mimetype,
    });

  if (error) throw error;

  const { data: publicUrlData } = supabase.storage
    .from(BUCKET_NAME)
    .getPublicUrl(fileName);

  return publicUrlData.publicUrl;
}

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SECRET_KEY,
  {
    realtime: {
      transport: ws,
    },
  }
);

const BUCKET_NAME = 'mvcapp-images'; // use your actual bucket name

// Multer now keeps files in memory instead of writing to disk
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });







app.use((req, res, next) => {
    res.setHeader('Cache-Control', 'no-store');
    next();
  });  

// Enable CORS for all origins (this is the simplest option)
app.use(cors());

// Middleware to parse JSON requests
app.use(express.json());

//sample notify

app.post('/send-notification', async (req, res) => {
  const { userId, message } = req.body;

  try {
    // Retrieve the user's Expo push token from the database
    const user = await prismaClient.user.findUnique({
      where: { id: userId },
    });

    if (user?.expoPushToken) {
      const expoPushToken = user.expoPushToken;

      // Create the message payload
      const messagePayload = {
        to: expoPushToken,
        sound: 'default',
        title: 'Booking Status Update',
        body: message,
        data: { customData: 'Booking Status' },
      };

      // Send the notification
      const response = await fetch('https://exp.host/--/api/v2/push/send', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(messagePayload),
      });

      const responseData = await response.json();
      if (response.status === 200) {
        console.log('Notification sent successfully:', responseData);
        res.status(200).json({ success: true, message: 'Notification sent successfully' });
      } else {
        console.error('Failed to send notification:', responseData);
        res.status(400).json({ success: false, message: 'Failed to send notification' });
      }
    } else {
      res.status(404).json({ success: false, message: 'User push token not found' });
    }
  } catch (error) {
    console.error('Error sending notification:', error);
    res.status(500).json({ success: false, message: 'Internal Server Error' });
  }
});


//get all accounts
// GET /api/login - Fetch all login data
app.get('/api/login', async (req, res) => {
  try {
    const loginData = await prisma.login.findMany({
      select: {
        id: true,
        username: true,
        password: true, // Include password field
      },
    });

    res.status(200).json(loginData);
  } catch (error) {
    console.error('Error fetching login data:', error);
    res.status(500).json({ error: 'Failed to fetch login data' });
  }
});

// Basic route to confirm the server is running
app.get('/', (req, res) => res.send('Express server is running!'));

// GET route to fetch all user bookings, with receipts
app.get('/mvcapp/userbooking', async (req, res) => {
    try {
        // Fetch bookings, but remove the 'receipts' relation since it's not in the schema anymore
        const bookings = await prisma.bookingrq.findMany({
            include: {
                // If you still want to include the Requestresponse, you can do it like this:
                requestResponse: true,
                user: true,  // If you want user data along with the booking
            },
        });

        res.status(200).json(bookings);
    } catch (error) {
        console.error('Error fetching bookings:', error);
        res.status(500).json({ error: 'Error fetching bookings' });
    }
});


// GET route to fetch all request responses (for admin view)
app.get('/mvcapp/requestresponse', async (req, res) => {
  
    try {
        const responses = await prisma.requestresponse.findMany({
            include: { user: true }, // Including user details if needed
        });
        res.status(200).json(responses);
    } catch (error) {
        console.error('Error fetching request responses:', error);
        res.status(500).json({ error: 'Failed to fetch request responses' });
    }
});

// Single route for fetching specific booking by ID
  app.get('/mvcapp/Bookingrq/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const booking = await prisma.bookingrq.findUnique({ where: { id: parseInt(id) } });
        if (!booking) return res.status(404).json({ error: 'Booking not found' });
        res.json(booking);
    } catch (error) {
        console.error('Error fetching booking data:', error);
        res.status(500).json({ error: 'Failed to fetch booking data' });
    }
});

// Fetch requests based on userId
app.get('/mvcapp/Requestsresponse/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const requests = await prisma.requestresponse.findMany({
            where: { userId: parseInt(userId) },
            include: { booking: true },
        });
        if (requests.length === 0) {
            return res.status(404).json({ message: "No requests found for this user." });
        }
        res.json(requests);
    } catch (error) {
        res.status(500).json({ error: 'Failed to fetch requests' });
    }
});


//./User/profile
app.get('/profile/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
      const user = await prisma.login.findUnique({
          where: { id: parseInt(userId) },
          select: {
              id: true,
              username: true,
              password: true, // Include the password field
              createdAt: true,
          },
      });

      if (!user) {
          return res.status(404).json({ message: 'User not found' });
      }

      res.status(200).json(user);
  } catch (error) {
      console.error('Error fetching user profile:', error);
      res.status(500).json({ error: 'Failed to fetch user profile' });
  }
});

//generate report
app.post('/send-email', async (req, res) => {
  console.log(req.body); // Log the request body to debug

  const { subject, text, attachment } = req.body;

  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.EMAIL_USER, 
      pass: process.env.EMAIL_PASS,
    },
  });

  try {
    await transporter.sendMail({
      from: process.env.EMAIL_USER,  // Sender's email
      to: process.env.EMAIL_USER,    // Recipient's email (could be different)
      subject: 'Monthly Report',
      text,
      attachments: [
        {
          filename: 'MonthlyReport.csv',
          content: attachment,  // The CSV content passed from frontend
        },
      ],
    });

    res.status(200).json({ message: 'Email sent successfully!' });
  } catch (error) {
    console.error('Error sending email:', error);
    res.status(500).json({ error: 'Failed to send email.' });
  }
});







app.post('/createacc', async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ message: 'Username and password are required' });
    }

    try {
        const existingUser = await prisma.login.findUnique({ where: { username } });
        if (existingUser) {
            return res.status(409).json({ message: 'Username already exists' });
        }

        // Hash the password before saving it
        const hashedPassword = await bcryptjs.hash(password, 10); // 10 is the salt rounds

        const newUser = await prisma.login.create({
            data: { username, password },
        });

        res.status(201).json({ message: 'Account created successfully', user: newUser });
    } catch (error) {
        console.error('Error creating account:', error);
        res.status(500).json({ error: 'Failed to create account' });
    }
});

// POST route for user login
app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        const user = await prisma.login.findUnique({
            where: { username: username },
        });

        if (!user || user.password !== password) {
            return res.status(401).json({ message: 'Invalid username or password' });
        }

        res.status(200).json({ userId: user.id });
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ error: 'Login failed' });
    }
});

// POST route to create a user booking
app.post('/mvcapp/userbooking/:houseType', upload.array('receiptImages', 10), async (req, res) => {
  const { 
    firstname, 
    lastname, 
    checkin, 
    checkout, 
    phonenumber, 
    amount, 
    houseName, 
    userId, 
    roomType, 
    roomNumber 
  } = req.body;

  const pictureUrls = req.files && req.files.length > 0
    ? await Promise.all(req.files.map(file => uploadToSupabase(file)))
    : [];

  try {
    // Create a new booking
    const booking = await prisma.bookingrq.create({
      data: {
        firstname,
        lastname,
        checkin: new Date(checkin),
        checkout: new Date(checkout),
        phonenumber: phonenumber.trim(),
        amount: parseInt(amount, 10),
        houseName,
        roomType, // Include roomType
        roomNumber: parseInt(roomNumber, 10), // Include roomNumber (ensure it's an integer)
        user: {
          connect: {
            id: parseInt(userId, 10), // Ensure the ID is an integer
          },
        },
        pictureUrls, // Ensure this matches your schema if it's an array
      },
    });

    // Create a request response
    const requestResponse = await prisma.requestresponse.create({
      data: {
        firstname,
        lastname,
        checkin: new Date(checkin),
        checkout: new Date(checkout),
        phonenumber: phonenumber.trim(),
        amount: parseInt(amount, 10),
        houseName,
        userId: parseInt(userId, 10),
        bookingId: booking.id,
        status: 'Pending',
        pictureUrls, // Store file paths here as well
      },
    });

    // Respond with the created booking and request response
    res.status(201).json({ booking, requestResponse });
  } catch (error) {
    console.error('Error creating booking:', error);
    res.status(500).json({ error: 'Error creating booking' });
  }
});



// POST route to handle booking request responses
app.post('/mvcapp/Requestresponse', async (req, res) => {
    const {
        bookingId,
        firstname,
        lastname,
        checkin,
        checkout,
        amount,
        houseName,
        phonenumber,
        roomType,
        roomNumber,
        status
    } = req.body;

    const parsedBookingId = parseInt(bookingId);

    if (isNaN(parsedBookingId)) {
        return res.status(400).json({ error: 'Invalid bookingId' });
    }

    try {
        const existingResponse = await prisma.requestresponse.findUnique({
            where: {
                bookingId: parsedBookingId
            }
        });

        if (existingResponse) {
            return res.status(400).json({ error: 'A response already exists for this booking' });
        }

        const booking = await prisma.bookingrq.findUnique({
            where: {
                id: parsedBookingId
            },
            select: {
                userId: true
            }
        });

        if (!booking) {
            return res.status(404).json({ error: 'Booking not found' });
        }

        const userId = booking.userId;

        const response = await prisma.requestresponse.create({
            data: {
                bookingId: parsedBookingId,
                firstname,
                lastname,
                checkin: new Date(checkin),
                checkout: new Date(checkout),
                amount: parseFloat(amount),
                houseName,
                phonenumber,
                roomType,
                roomNumber,
                status,
                userId,
            },
        });

        res.status(201).json(response);
    } catch (error) {
        console.error('Error creating Requestresponse entry:', error);
        res.status(500).json({ error: 'Error creating Requestresponse entry' });
    }
});






// POST route for creating a booking in the AdminBooking table
app.post('/mvcapp/adminbooking/create', upload.array('receiptImages', 10), async (req, res) => {
  const { firstname, lastname, checkInDate, checkOutDate, phonenumber, amount, houseName, roomType, roomNumber, adminId } = req.body;
   const amountInt = parseInt(amount, 10);
  console.log('Files uploaded:', req.files); // Log the uploaded files
  
  // If no files uploaded, return an error
  if (!req.files || req.files.length === 0) {
    return res.status(400).json({ error: 'No files uploaded' });
  }

  // Extract the file paths
  const pictureUrls = await Promise.all(req.files.map(file => uploadToSupabase(file)));

  try {
    // Create the booking
    const newBooking = await prisma.adminBooking.create({
      data: {
        firstname,
        lastname,
        checkin: new Date(checkInDate),
        checkout: new Date(checkOutDate),
        phonenumber,
        amount: amountInt,
        houseName,
        roomType,
        roomNumber,
        adminId: parseInt(adminId),
        pictureUrl: pictureUrls, // Store the URLs of uploaded images
      },
    });

    res.status(201).json({ message: 'Booking created successfully', booking: newBooking });
  } catch (error) {
    console.error('Error during booking creation:', error);
    res.status(500).json({ error: 'Failed to create booking' });
  }
});




  



// GET route for fetching all admin bookings
app.get('/mvcapp/adminbooking', async (req, res) => {
    console.log('GET /mvcapp/adminbooking called');
    try {
      const adminBookings = await prisma.adminBooking.findMany();
      res.status(200).json(adminBookings);
    } catch (error) {
      console.error('Error fetching admin bookings:', error);
      res.status(500).json({ error: 'Failed to fetch admin bookings' });
    }
  });
  


app.get('/user/:id', async (req, res) => {
    const { id } = req.params;
  
    try {
      const user = await prisma.login.findUnique({
        where: { id: parseInt(id) },
        select: { firstname: true, lastname: true },
      });
  
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: 'An error occurred while fetching user data' });
    }
  });
  

// POST route for admin login
app.post('/adminlogin', async (req, res) => {
    const { username, password } = req.body;

    try {
        const admin = await prisma.adminLogin.findUnique({
            where: { username: username },
        });

        if (!admin || admin.password !== password) {
            return res.status(401).json({ message: 'Invalid username or password' });
        }

        res.status(200).json({ adminId: admin.id });
    } catch (error) {
        console.error('Error during admin login:', error);
        res.status(500).json({ error: 'Admin login failed' });
    }
});

//sample
app.get('/mvcapp/userbooking/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const booking = await prisma.bookingrq.findUnique({
            where: { id: parseInt(id) },
        });
        if (!booking) {
            return res.status(404).json({ message: "Booking not found." });
        }
        res.json(booking);
    } catch (error) {
        console.error('Error fetching booking request:', error);
        res.status(500).json({ error: 'Failed to fetch booking request' });
    }
});

// Update the status of a request in Requestresponse table
app.put('/mvcapp/requestresponse/:id', async (req, res) => {
    const bookingId = parseInt(req.params.id, 10); // Use bookingId from the URL.
  
    try {
      const updatedRecord = await prisma.requestresponse.update({
        where: { bookingId }, // Match by bookingId instead of id.
        data: {
          status: req.body.status,
          roomType: req.body.roomType,
          roomNumber: req.body.roomNumber,
        },
      });
  
      res.json(updatedRecord);
    } catch (error) {
      console.error('Error updating Requestresponse:', error);
      res.status(500).json({ error: 'Failed to update Requestresponse' });
    }
  });
  
  app.put('/update-password/:id', async (req, res) => {
    const { id } = req.params; // Get the user ID from the URL parameter
    const { password } = req.body; // Get the new password from the request body
  
    try {
      // Find the user by their ID
      const user = await prisma.login.findUnique({
        where: { id: parseInt(id) },
      });
  
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }
  
      // Update the user's password
      const updatedUser = await prisma.login.update({
        where: { id: parseInt(id) },
        data: {
          password: password, // Update the password
        },
      });
  
      res.status(200).json({ message: 'Password updated successfully', user: updatedUser });
    } catch (error) {
      console.error('Error updating password:', error);
      res.status(500).json({ message: 'Error updating password' });
    }
  });
  
// Update room status
app.put('/api/rooms/:id', async (req, res) => {
  const { id } = req.params;
  const { status, roomType, roomNumber, date } = req.body; // Added "date" to the destructured fields

  console.log(`Received PUT request to update room with ID: ${id}`);
  console.log(`Request body: `, { status, roomType, roomNumber, date });

  try {
    const updatedRoom = await prisma.roomAvailability.update({
      where: { id: parseInt(id) },
      data: { status, roomType, roomNumber, date }, // Include "date" in the data object
    });
    console.log(`Room updated successfully: `, updatedRoom);
    res.json(updatedRoom);
  } catch (error) {
    console.error(`Error updating room with ID: ${id}`, error);
    res.status(500).send('Error updating room details');
  }
});

// Delete a booking request by ID
app.delete('/mvcapp/userbooking/:id', async (req, res) => {
  const id = parseInt(req.params.id);
  try {
    await prisma.bookingrq.delete({
      where: { id },
    });
    res.status(204).send(); // No content on successful deletion
  } catch (error) {
    console.error('Error deleting Bookingrq:', error);
    res.status(500).json({ error: 'Failed to delete Bookingrq' });
  }
});


// get all rooms for editing
app.get('/api/rooms', async (req, res) => {
  try {
    const rooms = await prisma.roomAvailability.findMany();  // Fetch all rooms
    res.json(rooms);  // Send the rooms data as JSON
  } catch (error) {
    console.error('Error fetching rooms:', error);
    res.status(500).json({ error: 'Failed to fetch rooms' });  // Handle errors
  }
});



// GET Request to Retrieve Room by ID
app.get('/rooms/:id', async (req, res) => {
  const roomId = parseInt(req.params.id); // Get the room ID from the URL

  try {
    // Fetch the room data from the database
    const room = await prisma.roomAvailability.findUnique({
      where: { id: roomId },
    });

    if (room) {
      // If the room is found, return it as a response
      res.status(200).json(room);
    } else {
      // If the room is not found, send a 404 error
      res.status(404).json({ message: 'Room not found' });
    }
  } catch (error) {
    // Catch any errors during database query
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});


// Start the server
const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Server is running on port ${PORT}`));
