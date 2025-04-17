<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Unique Notes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            background: linear-gradient(315deg, #e6faf0 3%, #fafae6 38%, #fae6f0 68%, #e6e6fa 98%);
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
        .login-card {
            border-radius: 1rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .login-header {
            background: linear-gradient(135deg, #6a0dad, #0056b3);
            padding: 1.5rem;
            text-align: center;
        }
        .app-logo {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        .btn-login {
            background: linear-gradient(135deg, #6a0dad, #0056b3);
            border: none;
            padding: 0.6rem;
            font-weight: 500;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }
        .form-floating input:focus {
            box-shadow: none;
            border-color: #6a0dad;
        }
        .register-link {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .register-link:hover {
            text-decoration: underline;
        }
        .login-container {
            opacity: 0;
            transition: opacity 0.5s ease-in;
        }
        .login-container.show {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="container login-container" id="loginContainer">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5 col-xl-4">
                <div class="card login-card">
                    <div class="login-header text-white">
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
                                <input type="email" name="username" class="form-control" id="floatingEmail" placeholder="name@example.com" required>
                                <label for="floatingEmail"><i class="fas fa-envelope me-2"></i>Email</label>
                            </div>
                            
                            <div class="form-floating mb-4">
                                <input type="password" name="password" class="form-control" id="floatingPassword" placeholder="Password" required>
                                <label for="floatingPassword"><i class="fas fa-lock me-2"></i>Password</label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-login btn-primary btn-lg">
                                    <i class="fas fa-sign-in-alt me-2"></i>Sign In
                                </button>
                            </div>
                            
                            <div class="mt-4 text-center">
                                <p class="mb-0">Don't have an account? <a href="registration.jsp" class="register-link">Create Account</a></p>
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
        $(document).ready(function() {
            var status = $("#status").val();
            const urlParams = new URLSearchParams(window.location.search);
            
            // Check for logout success parameter
            if (urlParams.get('logout') === 'success') {
                // Show SweetAlert with timer
                swal({
                    title: "Logged Out",
                    text: "You have been successfully logged out.",
                    type: "success",
                    timer: 3000,
                    showConfirmButton: false
                });
                
                // Delay showing the login form
                setTimeout(function() {
                    $("#loginContainer").addClass("show");
                }, 2000);
            } else {
                // For other cases show the login form immediately
                $("#loginContainer").addClass("show");
                
                // Handle other alerts
                if (status === "success") {
                    swal({
                        title: "Login Successful",
                        text: "Redirecting to your notes...",
                        type: "success",
                        timer: 2000,
                        showConfirmButton: false
                    });
                } else if (status === "failed") {
                    swal("Login Failed", "Incorrect email or password", "error");
                } else if (status === "error") {
                    swal("Error", "Something went wrong", "error");
                } else if (urlParams.get('status') === 'success') {
                    swal("Registration Successful", "Your account has been created. Please log in.", "success");
                }
            }
            
            // Clean up URL parameters
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.pathname);
            }
        });
    </script>
</body>
</html>