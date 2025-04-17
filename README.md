# 📒 UniqueNotes

A simple and elegant **note-making portal** built using **Java Servlets**, **JSP**, and **MySQL**.  
This project allows users to register, log in, create notes, and manage sessions in a lightweight web interface.

---

## 🚀 Features

- ✅ User Registration & Login (Session-based authentication)
- ✅ Secure Logout
- ✅ Create and View Notes
- ✅ Java Servlet + JSP powered backend
- ✅ Clean front-end with folder structure for assets, CSS, JS
- ✅ Gson integration for JSON handling

---

## 🛠️ Tech Stack

| Layer        | Technology            |
|--------------|------------------------|
| Backend      | Java Servlets, JSP     |
| Frontend     | HTML, CSS, JS          |
| Database     | MySQL                  |
| Library Used | Gson (for JSON parsing)|
| Build Tool   | Manual / IDE-based     |
| Server       | Apache Tomcat          |


---

## 💻 Getting Started

### Prerequisites

- Java (JDK 8 or later)
- Apache Tomcat (9+ recommended)
- MySQL Server
- IDE like Eclipse or IntelliJ IDEA
- Git (optional)

### Database Setup

1. Create a MySQL database (e.g., `uniquenotes`)
2. Add a `users` table with necessary fields (e.g., `id`, `username`, `email`, `password`)
3. Update your DB credentials in the servlet/database utility class if required

### Run the Project

1. Import the project into your Java IDE
2. Configure your Tomcat server
3. Deploy and run the application
4. Visit `http://localhost:8080/signup/`

---

## 📦 Dependencies

- [Gson](https://github.com/google/gson) – for JSON parsing
- Servlet API – Provided by the server (e.g., Tomcat)

---

## 🙌 Author

Made with ❤️ by Raunak Kushwaha 
Feel free to contribute, fork, and ⭐ this repo!

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
