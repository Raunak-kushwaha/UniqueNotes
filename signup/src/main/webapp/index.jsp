<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%
    if(session.getAttribute("email") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String email = (String) session.getAttribute("email");
    List<Map<String,String>> notes = new ArrayList<>();
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/uniquenotes?useSSL=false", 
            "root", 
            "");
        
        PreparedStatement pst = con.prepareStatement(
            "SELECT id, title, content, created_at, updated_at FROM notes WHERE user_email = ? ORDER BY created_at DESC");
        pst.setString(1, email);
        ResultSet rs = pst.executeQuery();
        
        while(rs.next()) {
            Map<String,String> note = new HashMap<>();
            note.put("id", rs.getString("id"));
            note.put("title", rs.getString("title"));
            note.put("content", rs.getString("content"));
            note.put("created", rs.getString("created_at"));
            note.put("updated", rs.getString("updated_at"));
            notes.add(note);
        }
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Notes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
    <style>
    body {
        background-color: #f8f9fa; /* Off-white background */
    background: linear-gradient(315deg, #f3fdf8 3%, #fdfdf3 38%, #fdf3f8 68%, #f3f3fd 98%);
    animation: gradient 15s ease infinite;
    background-size: 400% 400%;
    background-attachment: fixed;
    color: #0c0c02;
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
    
    .navbar {
        background-color: #6a0dad !important; /* Deep purple */
    }
    
    .note-card {
        cursor: pointer;
        transition: transform 0.2s;
        background-color: rgba( 255, 255, 255, 0.65 ); /* White cards */
    }
    
    .note-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 8px rgba(106, 13, 173, 0.1); /* Purple shadow */
    }
    
    .btn-primary {
        background-color: #6a0dad; /* Deep purple */
        border-color: #6a0dad;
    }
    
    .btn-primary:hover {
        background-color: #5a0b9e; /* Darker purple */
        border-color: #5a0b9e;
    }
    
    .empty-state i {
        color: #6a0dad; /* Purple icon */
    }
    
    .modal-header {
        background-color: #6a0dad; /* Purple header */
        color: white;
    }
    
    .form-control:focus {
        border-color: #6a0dad;
        box-shadow: 0 0 0 0.25rem rgba(106, 13, 173, 0.25); /* Purple focus */
    }
    
    .card-footer {
        background-color: rgba(248, 249, 250, 0.5); /* Off-white footer */
    }
    .btn-close {
        filter: invert(1) brightness(100%);
        opacity: 1;
    }
    
    .btn-close:hover {
        filter: invert(1) brightness(100%);
        opacity: 0.75;
    }
    .modal-body {
    background-color: rgba( 255, 255, 255, 0.65 );
    }
</style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-book-open me-2"></i>Notes App
            </a>
            <div class="d-flex">
                <span class="text-light me-3"><i class="fas fa-user me-2"></i><%= session.getAttribute("name") %></span>
                <a href="logout" class="btn btn-sm btn-outline-light">
                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container my-4">
        <div class="d-flex justify-content-between mb-4 align-items-center">
            <h3><i class="fas fa-sticky-note me-2"></i>My Notes</h3>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newNoteModal">
                <i class="fas fa-plus me-1"></i>New Note
            </button>
        </div>

        <% if(notes.isEmpty()) { %>
            <div class="empty-state">
                
                <h4>No Notes Yet...</h4>
                <p>Create your first note by clicking the "New Note" button</p>
            </div>
        <% } else { %>
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <% for(Map<String,String> note : notes) { %>
                <div class="col">
                    <div class="card h-100 note-card" onclick="loadNote('<%= note.get("id") %>')">
                        <div class="card-body">
                            <h5 class="card-title text-truncate"><%= note.get("title") %></h5>
                            <div class="card-text note-content">
                                <%= note.get("content").length() > 100 ? 
                                    note.get("content").substring(0, 100) + "..." : note.get("content") %>
                            </div>
                        </div>
                        <div class="card-footer text-muted">
                            <small><i class="far fa-clock me-1"></i>Created: <%= note.get("created") %></small>
                            <br><small><i class="far fa-clock me-1"></i>Updated: <%= note.get("updated") %></small>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- New Note Modal -->
    <div class="modal fade" id="newNoteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="createNoteForm" action="NoteServlet" method="post">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-plus-circle me-2"></i>New Note</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Title</label>
                            <input type="text" class="form-control" name="title" placeholder="Note title" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Content</label>
                            <textarea class="form-control" name="content" rows="10" placeholder="Write your note here..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Save Note
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit/Delete Note Modal -->
    <div class="modal fade" id="editNoteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="editNoteForm" action="NoteServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="noteId" id="editNoteId">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Note</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Title</label>
                            <input type="text" class="form-control" id="editNoteTitle" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Content</label>
                            <textarea class="form-control" id="editNoteContent" name="content" rows="10" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger me-auto" onclick="deleteNote()">
                            <i class="fas fa-trash-alt me-1"></i>Delete
                        </button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
    <script>
        $(document).ready(function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            const error = urlParams.get('error');
            
            if (status === 'note_created') {
                swal("Success!", "Your note was created successfully!", "success");
            } else if (status === 'note_updated') {
                swal("Success!", "Your note was updated successfully!", "success");
            }
            
            if (error === 'empty_fields') {
                swal("Error!", "Title and content cannot be empty!", "error");
            } else if (error === 'note_not_found') {
                swal("Error!", "Note not found or you don't have permission to edit it!", "error");
            } else if (error === 'database_error') {
                swal("Error!", "A database error occurred. Please try again.", "error");
            } else if (error === 'invalid_id') {
                swal("Error!", "Invalid note ID format", "error");
            }
            
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.pathname);
            }
            
            $("#createNoteForm, #editNoteForm").on('submit', function(e) {
                e.preventDefault();
                const form = $(this);
                const formData = form.serialize();
                const url = form.attr('action');
                
                $.post(url, formData)
                    .done(function() {
                        window.location.href = "index.jsp?status=note_" + (form.attr('id') === 'createNoteForm' ? 'created' : 'updated');
                    })
                    .fail(function(xhr) {
                        swal("Error!", xhr.responseText || "An error occurred", "error");
                    });
            });
        });

        function loadNote(noteId) {
            console.log("Loading note with ID:", noteId); // Debug log
            fetch('NoteServlet?action=get&id=' + noteId)
                .then(response => {
                    console.log("Response status:", response.status); // Debug log
                    if (!response.ok) {
                        return response.text().then(text => { throw new Error(text || 'Note not found: HTTP ' + response.status); });
                    }
                    return response.json();
                })
                .then(note => {
                    console.log("Received note:", note); // Debug log
                    document.getElementById('editNoteId').value = note.id;
                    document.getElementById('editNoteTitle').value = note.title;
                    document.getElementById('editNoteContent').value = note.content;
                    new bootstrap.Modal(document.getElementById('editNoteModal')).show();
                })
                .catch(error => {
                    console.error("Fetch error:", error); // Debug log
                    swal("Error!", "Failed to load note: " + error.message, "error");
                });
        }
        
        function deleteNote() {
            const noteId = document.getElementById('editNoteId').value;
            
            swal({
                title: "Are you sure?",
                text: "This note will be permanently deleted!",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes, delete it!",
                cancelButtonText: "No, keep it",
                closeOnConfirm: false,
                showLoaderOnConfirm: true
            }, function() {
                fetch('NoteServlet?action=delete&id=' + noteId, {
                    method: 'POST'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to delete note');
                    }
                    return response.json();
                })
                .then(data => {
                    swal({
                        title: "Deleted!",
                        text: "Your note has been deleted.",
                        type: "success",
                        timer: 1500,
                        showConfirmButton: false
                    });
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                })
                .catch(error => {
                    swal("Error!", error.message, "error");
                });
            });
        }
    </script>
</body>
</html>