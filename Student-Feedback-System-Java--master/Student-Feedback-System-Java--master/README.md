# 🎓 Student Feedback System - Complete Beginner's Guide

Welcome to the Student Feedback System! This guide is written to be extremely easy to follow, whether you are a complete beginner or an experienced developer. We will walk you through exactly how to set up, run, and understand this project step-by-step.

---

## 🎯 What is this project?

This is a comprehensive web application that allows students to securely log in and provide feedback on different courses or administrative topics. An administrator can create these feedback forms dynamically (adding various questions like text, ratings, multiple-choice, date selections, and file uploads), and view the responses submitted by students via a rich analytical dashboard.

It is built completely from scratch without heavy external backend frameworks using **Core Java Technologies** (Jakarta Servlets & JSP), a **MySQL Database**, and styled with **Vanilla CSS** featuring a premium, **Apple-inspired dark/light theme** with glassmorphism, micro-animations, and Chart.js integration.

---

## 🛠️ Step 1: Install Required Software (Prerequisites)

Before running the project, you need to have a few basic tools installed on your computer. If you already have these, skip to Step 2!

1. **Java Development Kit (JDK):** Version 17 or newer.
   - *Check if installed:* Open terminal/command prompt and type `java -version`.
2. **Apache Tomcat (Version 10.1.x):** This is the server that will run your Java Web Application locally.
   - *Download:* Go to the [Tomcat 10 download page](https://tomcat.apache.org/download-10.cgi) and download the ZIP file (e.g., `apache-tomcat-10.1.x-windows-x64.zip`). Extract it somewhere easy to find (e.g., `C:\Tomcat10`).
3. **MySQL Server:** This is where all the data (users, forms, responses) will be stored.
   - *Download:* Use the [MySQL Installer for Windows](https://dev.mysql.com/downloads/installer/).
4. **Eclipse IDE for Enterprise Web Developers:** This is the IDE we will use to write, manage, and run the code.
   - *Download:* Ensure you get the "Enterprise Java and Web" version, not the basic Java developer one.

---

## 🗄️ Step 2: Set Up the Database

Your project needs a place to store data. We have prepared an SQL script that automatically creates the database and populates it with sample data for you.

1. Open **MySQL Workbench** (or your preferred MySQL client).
2. Connect to your local MySQL server.
3. Open the file named `schema.sql`. You can find this inside the `sql/` folder of this project.
4. With the file open in MySQL Workbench, click the **Execute** button (the yellow lightning bolt icon) to run the code.
   - *What this just did:* It created a database named `student_feedback_db` and all necessary tables (users, forms, questions, responses, etc.). It also created a default administrator account for you to use.

---

## 🔌 Step 3: Connect the Java Code to the Database

For the Java application to talk to your MySQL database, it needs your MySQL password.

1. Open the project in your IDE and find the file `src/com/studentfeedback/util/DBConnection.java`.
2. Look for these lines of code around line 17:
   ```java
   private static final String USER = "root";
   private static final String PASSWORD = "your_password_here"; // CHANGE THIS
   ```
3. Change the `"your_password_here"` text to your actual MySQL root password (for example, `"akshay@123"`).
4. Save the file.

---

## 📦 Step 4: Verify "JAR" Files (Libraries)

This project relies on a few external libraries inside `WebContent/WEB-INF/lib/` to handle Jakarta EE APIs, database connections, and JSP templating exactly right for Tomcat 10.1:

- **MySQL Connector:** `mysql-connector-j-8.0.33.jar`
- **JSTL Implementation:** `jakarta.servlet.jsp.jstl-2.0.0.jar`
- **JSTL API:** `jakarta.servlet.jsp.jstl-api-2.0.0.jar`

Make sure these JAR files are indeed residing within your `WebContent/WEB-INF/lib` folder. The application is configured to read directly from this directory when launched through Tomcat. 

*Note: Do not include `servlet-api.jar` in your `lib` folder, as Tomcat 10.1 provides this natively via the Jakarta EE specification. Including it can cause deployment conflicts.*

---

## 📁 Step 5: Understanding File Uploads

When students answer questions of type `FILE`, the uploaded files are physically stored on your server within the active Tomcat deployment context.
- **Upload Location:** `[Tomcat_Webapps_Dir]/StudentFeedbackSystem/uploads/`
- **Database Storage:** Only the relative path (e.g., `/uploads/uuid_filename.pdf`) is saved in the MySQL database.
- **Accessing Files:** Administrators can download these files securely directly through the **Analytics** interface in the Admin Dashboard without needing to browse the server's filesystem manually.

---

## 💻 Step 6: Open and Run the Project in Eclipse

1. Open **Eclipse IDE**.
2. **Import the project:** Go to `File` -> `Import...` -> `General` -> `Existing Projects into Workspace`. Click `Next`.
3. Click `Browse` next to "Select root directory" and choose the `StudentFeedbackSystem` folder. Click `Finish`.
4. **Link Tomcat 10 to Eclipse:**
   - At the bottom of Eclipse, look for the **Servers** tab.
   - Click the link that says "No servers are available. Click this link to create a new server..."
   - Expand **Apache**, select **Tomcat v10.1 Server**, and click `Next`.
   - Click `Browse` and select the folder where you extracted Tomcat 10 earlier. Click `Finish`.
5. **Run the Project:**
   - Right-click on the `StudentFeedbackSystem` project folder on the left side of your screen in Eclipse.
   - Select **Run As** -> **Run on Server**.
   - Ensure your Tomcat v10.1 server is selected, and click **Finish**.

Eclipse will now start the server and automatically launch a web browser pointing to your project! The default URL is usually:
`http://localhost:8080/StudentFeedbackSystem/`

---

## 🔑 Step 7: Log In and Test!

Once the page loads, you can log in immediately using the default Administrator account created during the database setup (Step 2).

**Admin Credentials:**
- **Username:** `admin`
- **Password:** `admin123`

### 🛡️ Admin Features:
- **Modern Dashboard:** View high-level metrics with animated Stat Cards and theme toggles.
- **Dynamic Form Builder:** Construct custom feedback forms utilizing text, 1-5 star ratings, Yes/No toggles, Date selectors, and File Upload zones.
- **Analytics Visualization:** Review comprehensive response metrics leveraging integrated `Chart.js` bar and doughnut graphs. Access student submissions and safely download attached files.

### 🎓 Student Features:
Want to test the Student Portal? Click the **Create account** link on the login page to securely register a fresh student account requiring a standard USN (University Seat Number)!
- **Apple-Inspired UI:** Enjoy an ultra-modern aesthetic with glassmorphism elements, micro-animations, and full dark-mode support.
- **Form Interface:** Engage with spring-animated rating buttons, toggle chips, and drag-and-drop style file upload zones.
- **History View:** Review all past submissions easily, featuring smart color-coding for different answer types.

Enjoy using the Student Feedback System! 🚀
