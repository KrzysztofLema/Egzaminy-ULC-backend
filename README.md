
# Egzaminy ULC Backend

👋 Krzysztof Lema

This is the backend for the "Egzaminy ULC" application, which helps users prepare for exams from the Polish Civil Aviation Authority (ULC). The backend provides a service for managing exam questions and answers, and is hosted on [Fly.io](https://fly.io) for easy deployment.

## 🌐 About

The backend application is built using **Vapor**, a popular Swift-based web framework. It is designed to serve as a RESTful API for managing exam questions, providing endpoints that the mobile app uses to retrieve data.

### Key Features
- REST API for managing exam questions and answers
- Automatic deployment using **GitHub Actions** to **Fly.io**
- Data is fetched dynamically from the backend to support the iOS app

## 🚀 Technologies Used

- **Vapor** (Backend Framework)
- **Swift 6**
- **GitHub Actions** (for CI/CD)
- **Fly.io** (for hosting the app)
- **PostgreSQL** (Database, via Fly.io)
- **LaunchDarkly** (Feature Flags)
- **JWT** (Authentication)

## 🔧 Installation

To run the backend locally, follow the steps below:

1. Clone the repository:
   ```bash
   git clone https://github.com/KrzysztofLema/Egzaminy-ULC-backend.git
   ```

2. Navigate to the project directory:
   ```bash
   cd Egzaminy-ULC-backend
   ```

3. Install dependencies using **Swift**:
   ```bash
   swift package resolve
   ```

4. Create a `.env` file for environment variables (e.g., database configuration, JWT secrets).

5. Run the Vapor application:
   ```bash
   vapor run
   ```

Your backend should now be running locally on [http://localhost:8080](http://localhost:8080).

## 🛠 How It Works

The backend exposes a set of REST API endpoints for managing questions for various exams, such as:

- **PPL(A)**
- **PPL(H)**
- **PPL(B)**
- **PPL(H) ENG**
- **SPL**

It retrieves and stores the data dynamically to sync with the iOS app, and features a modular structure to ensure maintainability and scalability.

## 🚨 Repository Status  

🚨 **Important Notice** 🚨  
This project has been moved to a **private repository** for further development and maintenance.  


## 📦 CI/CD with GitHub Actions

This project is set up with **GitHub Actions** to automatically deploy changes to **Fly.io**. Whenever a change is pushed to the `main` branch, the backend is automatically built and deployed.

## 💡 Resources & Learning

I have learned a lot from the following resources while working on this project:
- [Fly.io Documentation](https://fly.io/docs/)
- [Vapor Documentation](https://vapor.codes)

## 🧑‍💻 Professional Experience

I built this backend as part of my learning process while working on the companion iOS app, which is for users preparing for various exams administered by the Polish Civil Aviation Authority (ULC).

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

🏆 Created by Krzysztof Lema | [GitHub](https://github.com/KrzysztofLema) | [LinkedIn](https://www.linkedin.com/in/krzysztoflema/)
