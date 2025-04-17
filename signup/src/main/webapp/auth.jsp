<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unique Notes - Authentication</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
    <style>
        :root {
            --primary-color: #6a0dad;
            --primary-dark: #5a0b9e;
            --secondary-color: #8b5cf6;
            --light-bg: #f8f9fa;
            --card-bg: #ffffff;
            --text-color: #334155;
            --text-light: #64748b;
        }
        
        body {
            background: linear-gradient(315deg, #f0f6fa 3%, #fafae6 38%, #fae6f0 68%, #e6e6fa 98%);
            animation: gradient 15s ease infinite;
            background-size: 400% 400%;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            color: var(--text-color);
        }
        
        @keyframes gradient {
            0% { background-position: 0% 0%; }
            50% { background-position: 100% 100%; }
            100% { background-position: 0% 0%; }
        }
        
        .auth-card {
            border-radius: 1rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            background-color: var(--card-bg);
            transition: all 0.3s ease;
        }
        
        .auth-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            padding: 1.5rem;
            text-align: center;
            color: white;
        }
        
        .app-logo {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .btn-auth {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
            padding: 0.75rem;
            font-weight: 500;
            letter-spacing: 0.5px;
            transition: all 0.3s;
            border-radius: 8px;
            color: white;
        }
        
        .btn-auth:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(106, 13, 173, 0.3);
            color: white;
        }
        
        .auth-link {
            color: var(--primary-color);
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
        }
        
        .auth-link:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }
        
        .form-floating input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(106, 13, 173, 0.25);
        }
        
        .auth-container {
            opacity: 0;
            transition: opacity 0.5s ease-in;
        }
        
        .auth-container.show {
            opacity: 1;
        }
        
        #registerForm {
            display: none;
        }
        
        .form-switch {
            text-align: center;
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <div class="container auth-container" id="authContainer">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6 col-xl-5">
                <!-- Login Form -->
                <div class="card auth-card" id="loginForm">
                    <div class="auth-header">
                        <div class="app-logo">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h4>Unique Notes</h4>
                        <p class="mb-0">Access your notes</p>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <form method="post" action="login">
                            <input type="hidden" id="status" value="<%= request.getAttribute("status") %>">
                            
                            <div class="form-floating mb-4">
                                <input type="email" name="username" class="form-control" id="loginEmail" placeholder="name@example.com" required>
                                <label for="loginEmail"><i class="fas fa-envelope me-2"></i>Email</label>
                            </div>
                            
                            <div class="form-floating mb-4">
                                <input type="password" name="password" class="form-control" id="loginPassword" placeholder="Password" required>
                                <label for="loginPassword"><i class="fas fa-lock me-2"></i>Password</label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-auth btn-lg">
                                    <i class="fas fa-sign-in-alt me-2"></i>Sign In
                                </button>
                            </div>
                            
                            <div class="form-switch mt-4 text-center">
                                <p class="mb-0">Don't have an account? <span class="auth-link" onclick="showRegisterForm()">Create Account</span></p>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Registration Form -->
                <div class="card auth-card" id="registerForm">
                    <div class="auth-header">
                        <div class="app-logo">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h4>Unique Notes</h4>
                        <p class="mb-0">Create your account</p>
                    </div>
                    <div class="card-body p-4">
                        <form action="RegistrationServlet" method="post" onsubmit="return validateForm()">
                            <input type="hidden" id="regStatus" value="<%= request.getParameter("status") %>">
                            
                            <div class="form-floating mb-3">
                                <input type="text" name="name" class="form-control" id="regName" placeholder="Full Name" required>
                                <label for="regName"><i class="fas fa-user me-2"></i>Full Name</label>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <input type="email" name="email" class="form-control" id="regEmail" placeholder="name@example.com" required>
                                <label for="regEmail"><i class="fas fa-envelope me-2"></i>Email</label>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <input type="password" name="pass" id="regPass" class="form-control" placeholder="Password" required>
                                <label for="regPass"><i class="fas fa-lock me-2"></i>Password</label>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <input type="password" name="re_pass" id="regRePass" class="form-control" placeholder="Confirm Password" required>
                                <label for="regRePass"><i class="fas fa-key me-2"></i>Confirm Password</label>
                            </div>
                            
                            <div class="form-floating mb-4">
                                <input type="text" name="contact" class="form-control" id="regContact" placeholder="Mobile Number">
                                <label for="regContact"><i class="fas fa-phone me-2"></i>Mobile (Optional)</label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-auth btn-lg">
                                    <i class="fas fa-user-plus me-2"></i>Create Account
                                </button>
                            </div>
                            
                            <div class="form-switch mt-4 text-center">
                                <p class="mb-0">Already have an account? <span class="auth-link" onclick="showLoginForm()">Sign In</span></p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
    <script>
        function checkInitialForm() {
            const urlParams = new URLSearchParams(window.location.search);
            const action = urlParams.get('action');
            
            if (action === 'register') {
                showRegisterForm();
            } else {
                showLoginForm();
            }
        }
        
        function showLoginForm() {
            $('#registerForm').hide();
            $('#loginForm').show();
            window.history.replaceState(null, null, window.location.pathname);
        }
        
        function showRegisterForm() {
            $('#loginForm').hide();
            $('#registerForm').show();
            window.history.replaceState(null, null, window.location.pathname + '?action=register');
        }
        
        function validateForm() {
            const pass = document.getElementById('regPass').value;
            const rePass = document.getElementById('regRePass').value;
            if (pass !== rePass) {
                swal("Error!", "Passwords do not match!", "error");
                return false;
            }
            return true;
        }

        $(document).ready(function() {
            $("#authContainer").addClass("show");
            checkInitialForm();
            
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            
            if (status === 'email_exists') {
                showRegisterForm();
                swal("Error!", "Email already exists. Please use a different email.", "error");
            } else if (status === 'password_mismatch') {
                showRegisterForm();
                swal("Error!", "Passwords do not match.", "error");
            } else if (status === 'error') {
                showRegisterForm();
                swal("Error!", "An unexpected error occurred. Please try again.", "error");
            } else if (status === 'success') {
                showLoginForm();
                swal("Registration Successful", "Your account has been created. Please log in.", "success");
            } else if ($("#status").val() === "failed") {
                swal("Login Failed", "Incorrect email or password", "error");
            } else if ($("#status").val() === "error") {
                swal("Error", "Something went wrong", "error");
            }
            
            if (urlParams.get('logout') === 'success') {
                swal({
                    title: "Logged Out",
                    text: "You have been successfully logged out.",
                    type: "success",
                    timer: 3000,
                    showConfirmButton: false
                });
            }
            
            if (window.history.replaceState) {
                const cleanUrl = window.location.pathname + 
                    (urlParams.get('action') === 'register' ? '?action=register' : '');
                window.history.replaceState(null, null, cleanUrl);
            }
        });
    </script>
</body>
</html>