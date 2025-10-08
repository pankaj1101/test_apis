const users = [
  {
    id: 1,
    name: "Pankaj Ram",
    mobile: "9876543210",
    email: "pankajram1101@gmail.com",
    password: "pass123",
    role: "admin",
    address: {
      street: "123 Main Street",
      city: "Mumbai",
      state: "Maharashtra",
      zip: "401208",
    },
    profileImage:
      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
    createdAt: "2023-06-15T10:20:30Z",
  },
  {
    id: 2,
    name: "Jane Smith",
    mobile: "9999999999",
    email: "jane.smith@example.com",
    password: "secret456",
    role: "user",
    address: {
      street: "456 Market Street",
      city: "San Francisco",
      state: "CA",
      zip: "94103",
    },
    profileImage:
      "https://thumbs.dreamstime.com/b/portrait-handsome-smiling-young-man-folded-arms-smiling-joyful-cheerful-men-crossed-hands-isolated-studio-shot-172869765.jpg",
    createdAt: "2023-07-10T15:45:00Z",
  },
  {
    id: 3,
    name: "Alice Johnson",
    mobile: "8888888888",
    email: "alice.j@example.com",
    password: "aliceSecure789",
    role: "editor",
    address: {
      street: "789 Elm Street",
      city: "Chicago",
      state: "IL",
      zip: "60614",
    },
    profileImage:
      "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
    createdAt: "2023-08-01T08:30:00Z",
  },
];

module.exports = users;
