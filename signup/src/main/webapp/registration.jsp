<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Unique Notes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
       		background: linear-gradient(315deg, #e6e6e6 3%, #dbffee 38%, #dcdbff 68%, #efefef 98%);
    		animation: gradient 15s ease infinite;
    		background-size: 400% 400%;
    		background-attachment: fixed;
        }
		        @keyframes gradient {
		    0% {
		        background-position: 0% 0%;
		    }
		    50% {
		        background-position: 100% 100%;
		    }
		    100% {
		        background-position: 0% 0%;
		    }
		}
        .register-card {
            border-radius: 1rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .register-header {
            background: linear-gradient(135deg, #6a0dad, #0056b3);
            padding: 1.5rem;
            text-align: center;
        }
        .app-logo {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        .btn-register {
            background: linear-gradient(135deg, #6a0dad, #0056b3);
            border: none;
            padding: 0.6rem;
            font-weight: 500;
            letter-spacing: 0.5px;
            transition: all 0.3s;
            
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }
        .form-floating input:focus {
            box-shadow: none;
            border-color: #007bff;
        }
        .login-link {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .login-link:hover {
            text-decoration: underline;
        }
        .register-container {
            opacity: 0;
            transition: opacity 0.5s ease-in;
        }
        .register-container.show {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="container register-container" id="registerContainer">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6 col-xl-5">
                <div class="card register-card">
                    <div class="register-header text-white">
                        <div class="app-logo">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h4>Unique Notes</h4>
                        <p class="mb-0">Create your account</p>
                    </div>
                    <div class="card-body p-4">
                        <form action="RegistrationServlet" method="post" onsubmit="return validateForm()">
                            <input type="hidden" id="status" value="<%= request.getParameter("status") %>">
                            
                            <div class="form-floating mb-3">
                                <input type="text" name="name" class="form-control" id="floatingName" placeholder="Full Name" required>
                                <label for="floatingName"><i class="fas fa-user me-2"></i>Full Name</label>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <input type="email" name="email" class="form-control" id="floatingEmail" placeholder="name@example.com" required>
                                <label for="floatingEmail"><i class="fas fa-envelope me-2"></i>Email</label>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <input type="password" name="pass" id="pass" class="form-control" placeholder="Password" required>
                                <label for="pass"><i class="fas fa-lock me-2"></i>Password</label>
                            </div>
                            
                            <div class="form-floating mb-3">
                                <input type="password" name="re_pass" id="re_pass" class="form-control" placeholder="Confirm Password" required>
                                <label for="re_pass"><i class="fas fa-key me-2"></i>Confirm Password</label>
                            </div>
                            
                            <div class="form-floating mb-4">
                                <input type="text" name="contact" class="form-control" id="floatingContact" placeholder="Mobile Number">
                                <label for="floatingContact"><i class="fas fa-phone me-2"></i>Mobile (Optional)</label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-register btn-primary btn-lg">
                                    <i class="fas fa-user-plus me-2"></i>Create Account
                                </button>
                            </div>
                            
                            <div class="mt-4 text-center">
                                <p class="mb-0">Already have an account? <a href="login.jsp" class="login-link">Sign In</a></p>
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
        function validateForm() {
            const pass = document.getElementById('pass').value;
            const rePass = document.getElementById('re_pass').value;
            if (pass !== rePass) {
                swal("Error!", "Passwords do not match!", "error");
                return false;
            }
            return true;
        }

        $(document).ready(function() {
            // Show the registration form with animation
            $("#registerContainer").addClass("show");
            
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            
            if (status === 'email_exists') {
                swal("Error!", "Email already exists. Please use a different email.", "error");
            } else if (status === 'password_mismatch') {
                swal("Error!", "Passwords do not match.", "error");
            } else if (status === 'error') {
                swal("Error!", "An unexpected error occurred. Please try again.", "error");
            }
            
            // Clean up URL parameters
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.pathname);
            }
        });
    </script>
</body>
</html>