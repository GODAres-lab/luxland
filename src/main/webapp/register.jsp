<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Daftar - LuxLand</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="glass-panel" style="max-width: 450px;">
        <div class="form-title">Bergabunglah</div>
        <div class="form-subtitle">Daftarkan diri Anda di LuxLand Hotel</div>
        <form action="RegisterServlet" method="POST">
            <div class="input-group">
                <label>Nama Lengkap</label>
                <input type="text" name="fullName" class="glass-input" required>
            </div>
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" class="glass-input" required>
            </div>
            <div class="input-group">
                <label>Email</label>
                <input type="email" name="email" class="glass-input" required>
            </div>
            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" class="glass-input" required>
            </div>
            <button type="submit" class="btn-gold">DAFTAR SEKARANG</button>
        </form>
        <div style="margin-top:20px; font-size:13px; color:#ccc;">Sudah punya akun? <a href="login.jsp">Login</a></div>
    </div>
</body>
</html>