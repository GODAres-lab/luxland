<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login Portal - LuxLand</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .portal-tabs { display: flex; margin-bottom: 20px; border-bottom: 1px solid #444; }
        .tab { flex: 1; padding: 15px; text-align: center; cursor: pointer; color: #888; font-weight: bold; transition: 0.3s; }
        .tab.active { color: #ffd700; border-bottom: 2px solid #ffd700; background: rgba(255, 215, 0, 0.05); }
        .msg-error { background: rgba(255, 0, 0, 0.2); color: #ff6b6b; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 13px; border: 1px solid #ff6b6b; }
    </style>
</head>
<body>
    <div class="glass-panel" style="width: 400px;">
        <div class="form-title"><i class="fa-solid fa-hotel"></i> LuxLand</div>
        
        <!-- Tab Seleksi Portal -->
        <div class="portal-tabs">
            <div id="tabGuest" class="tab active" onclick="setPortal('Guest')"><i class="fa-solid fa-user"></i> GUEST</div>
            <div id="tabStaff" class="tab" onclick="setPortal('Staff')"><i class="fa-solid fa-user-tie"></i> STAFF</div>
        </div>

        <p id="portalDesc" style="color: #aaa; font-size: 12px; margin-bottom: 20px; text-align: center;">Masuk sebagai Tamu untuk memesan kamar.</p>

        <%-- Menampilkan Pesan Error Spesifik --%>
        <% 
            String err = request.getParameter("error");
            if("wrong_portal".equals(err)) { %>
                <div class="msg-error"><i class="fa-solid fa-ban"></i> Akses Ditolak: Gunakan portal yang sesuai dengan akun Anda!</div>
            <% } else if("invalid".equals(err)) { %>
                <div class="msg-error"><i class="fa-solid fa-circle-xmark"></i> Username atau Password salah!</div>
            <% }
        %>

        <form action="LoginServlet" method="POST">
            <!-- INPUT HIDDEN INI SANGAT PENTING -->
            <input type="hidden" name="loginPortal" id="loginPortal" value="Guest">

            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" class="glass-input" required>
            </div>
            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" class="glass-input" required>
            </div>
            
            <button type="submit" class="btn-gold" style="width: 100%;">LOGIN PORTAL <i class="fa-solid fa-right-to-bracket"></i></button>
        </form>

        <div id="regArea" style="margin-top: 20px; font-size: 13px; text-align: center; color: #ccc;">
            Belum punya akun? <a href="register.jsp" style="color: #ffd700;">Daftar Guest</a>
        </div>
    </div>

    <script>
        function setPortal(p) {
            document.getElementById('loginPortal').value = p;
            document.getElementById('tabGuest').className = (p === 'Guest' ? 'tab active' : 'tab');
            document.getElementById('tabStaff').className = (p === 'Staff' ? 'tab active' : 'tab');
            
            if(p === 'Guest') {
                document.getElementById('portalDesc').innerText = "Masuk sebagai Tamu untuk memesan kamar.";
                document.getElementById('regArea').style.visibility = "visible";
            } else {
                document.getElementById('portalDesc').innerText = "Portal khusus Staff dan Admin Management.";
                document.getElementById('regArea').style.visibility = "hidden";
            }
        }
    </script>
</body>
</html>