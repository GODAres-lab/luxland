<%@page import="com.luxland.model.User"%>
<%@page import="java.time.LocalDate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if(currentUser == null) response.sendRedirect("login.jsp");
    
    String roomId = request.getParameter("id");
    String roomNum = request.getParameter("num");
    String price = request.getParameter("price");
    String type = request.getParameter("type");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Konfirmasi Reservasi - LuxLand</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body style="display:flex; justify-content:center; align-items:center; min-height:100vh; background: #0a0a0a;">
    <div class="glass-panel" style="width:450px; border: 1px solid #333;">
        <div style="text-align:left; margin-bottom:20px;">
            <a href="dashboard.jsp" style="color:#ffd700; text-decoration:none; font-size: 14px;">
                <i class="fa-solid fa-arrow-left"></i> Kembali ke Dashboard
            </a>
        </div>
        
        <h2 class="form-title" style="font-family: serif;">Konfirmasi Reservasi</h2>
        
        <div style="background:rgba(255,215,0,0.05); padding:20px; border-radius:15px; margin-bottom:25px; color:white; text-align:left; border: 1px solid #222;">
            <p style="margin-bottom: 10px; color: #aaa; font-size: 12px;">DETAIL PILIHAN:</p>
            <p style="font-size: 18px;">Kamar <strong>#<%= roomNum %></strong></p>
            <p style="color: #ffd700;"><%= type %></p>
            <p style="margin-top: 10px; font-weight: bold;">Rp <%= String.format("%,.0f", Double.parseDouble(price)) %> <small style="font-weight: normal; color: #888;">/ malam</small></p>
        </div>

        <form action="BookingServlet" method="POST">
            <input type="hidden" name="room_id" value="<%= roomId %>">
            
            <div style="text-align: left; margin-bottom: 15px;">
                <label style="color:#ffd700; font-size:12px; display: block; margin-bottom: 5px;">Tanggal Check-In</label>
                <input type="date" name="check_in" id="check_in" class="glass-input" 
                       min="<%= LocalDate.now() %>" required onchange="updateCheckOutLimit()">
            </div>
            
            <div style="text-align: left; margin-bottom: 25px;">
                <label style="color:#ffd700; font-size:12px; display: block; margin-bottom: 5px;">Tanggal Check-Out</label>
                <input type="date" name="check_out" id="check_out" class="glass-input" 
                       min="<%= LocalDate.now().plusDays(1) %>" required>
            </div>
            
            <button type="submit" class="btn-gold" style="width: 100%; height: 50px; font-weight: bold; border:none; cursor:pointer;">
                LANJUT KE PEMBAYARAN <i class="fa-solid fa-chevron-right"></i>
            </button>
        </form>
    </div>

    <script>
        function updateCheckOutLimit() {
            var cin = document.getElementById('check_in').value;
            var coutInput = document.getElementById('check_out');
            // Check-out minimal H+1 dari Check-in
            if(cin) {
                var nextDay = new Date(cin);
                nextDay.setDate(nextDay.getDate() + 1);
                coutInput.min = nextDay.toISOString().split('T')[0];
                if(coutInput.value <= cin) {
                    coutInput.value = coutInput.min;
                }
            }
        }
    </script>
</body>
</html>