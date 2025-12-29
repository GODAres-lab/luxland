<%@page import="java.sql.*, java.util.*"%>
<%@page import="com.luxland.config.DBConnection"%>
<%@page import="com.luxland.model.*"%>
<%
    User user = (User) session.getAttribute("currentUser");
    if(user == null) response.sendRedirect("login.jsp");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Profil Saya - LuxLand</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="navbar">
        <a href="dashboard.jsp" class="brand"><i class="fa-solid fa-hotel"></i> LuxLand Portal</a>
        <div class="user-info">
            <a href="dashboard.jsp" style="color: #ffd700; text-decoration: none; margin-right: 15px;"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
            <a href="login.jsp" class="btn-logout">Logout</a>
        </div>
    </div>

    <div class="main-content" style="display: flex; justify-content: center;">
        <div class="glass-panel" style="width: 500px; text-align: left;">
            <h2 style="color: #ffd700; border-bottom: 1px solid #444; padding-bottom: 10px; margin-bottom: 20px;">
                <i class="fa-solid fa-id-card"></i> Profil Pengguna
            </h2>

            <%-- Pesan Sukses/Gagal --%>
            <% if("success".equals(request.getParameter("msg"))) { %>
                <div style="background: rgba(46, 204, 113, 0.2); color: #2ecc71; padding: 10px; border-radius: 5px; margin-bottom: 15px;">Password berhasil diperbarui!</div>
            <% } %>

            <div style="margin-bottom: 15px;">
                <label style="color: #888; font-size: 12px;">Nama Lengkap</label>
                <div style="color: white; font-size: 18px; font-weight: bold;"><%= user.getFullName() %></div>
            </div>
            <%-- Pastikan bagian ini benar di profile.jsp --%>
            <div style="margin-bottom: 15px;">
                <label style="color: #888; font-size: 12px;">Email Terdaftar</label>
                <div style="color: white;"><%= user.getEmail() %></div>
            </div>
            <div style="margin-bottom: 15px;">
                <label style="color: #888; font-size: 12px;">Username</label>
                <div style="color: white;"><%= user.getUsername() %></div>
            </div>
            <div style="margin-bottom: 15px;">
                <label style="color: #888; font-size: 12px;">Email Terdaftar</label>
                <div style="color: white;"><%= user.getEmail() %></div>
            </div>
            <div style="margin-bottom: 30px;">
                <label style="color: #888; font-size: 12px;">Role Akses</label>
                <div style="color: #ffd700; font-weight: bold;"><%= user.getRole() %></div>
            </div>

            <h3 style="color: #ffd700; border-top: 1px solid #444; padding-top: 20px; margin-bottom: 15px;">Ganti Password</h3>
            <form action="ProfileServlet" method="POST">
                <div class="input-group">
                    <label>Password Baru</label>
                    <input type="password" name="newPassword" class="glass-input" placeholder="Masukkan password baru..." required>
                </div>
                <button type="submit" class="btn-gold" style="width: 100%;">SIMPAN PERUBAHAN</button>
            </form>
        </div>
    </div>
</body>
</html>