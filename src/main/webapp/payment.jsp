<%@page import="com.luxland.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("currentUser");
    if(user == null) response.sendRedirect("login.jsp");
    String bid = request.getParameter("bid"), total = request.getParameter("total");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Secure Payment - LuxLand</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); align-items: center; justify-content: center; }
        .modal-content { background: #111; padding: 40px; border-radius: 20px; border: 1px solid #ff4d4d; text-align: center; width: 400px; color: white; }
    </style>
</head>
<body style="display:flex; justify-content:center; align-items:center; min-height:100vh; background:#080808;">

    <div id="errorModal" class="modal" <%= "wrong_pass".equals(request.getParameter("error")) ? "style='display:flex;'" : "" %>>
        <div class="modal-content">
            <i class="fa-solid fa-circle-xmark" style="font-size: 60px; color: #ff4d4d; margin-bottom: 20px;"></i>
            <h2 style="color: #ff4d4d;">Password Salah!</h2>
            <p>Konfirmasi pembayaran gagal. Silakan coba lagi.</p>
            <button class="btn-gold" onclick="closeModal()" style="margin-top:25px; background:#ff4d4d; border:none;">OK</button>
        </div>
    </div>

    <div class="glass-panel" style="width: 450px; text-align: center; padding: 40px;">
        <h2 style="color: #ffd700; font-family: serif;">Secure Payment</h2>
        <p style="color: #666; margin-bottom: 25px;">Booking ID: #LUX-<%= bid %></p>
        
        <div style="background: rgba(255,255,255,0.03); padding: 20px; border-radius: 15px; margin-bottom: 20px; border: 1px dashed #444;">
            <p style="color: #888; font-size: 11px;">VIRTUAL ACCOUNT</p>
            <h1 style="color: white; letter-spacing: 5px;">8080 <%= 1000 + Integer.parseInt(bid) %></h1>
            <p style="color: #ffd700; font-weight: bold; margin-top: 10px;">Total: Rp <%= String.format("%,.0f", Double.parseDouble(total)) %></p>
        </div>

        <div style="margin-bottom: 30px;"><i class="fa-solid fa-qrcode" style="font-size: 120px; color: white;"></i><p style="font-size:11px; color:#555; margin-top:10px;">Scan QRIS for faster payment</p></div>

        <form action="PaymentServlet" method="POST">
            <input type="hidden" name="bid" value="<%= bid %>">
            <input type="hidden" name="total" value="<%= total %>">
            <div class="input-group"><label>Password Konfirmasi</label><input type="password" name="confirmPass" class="glass-input" placeholder="••••••••" required style="text-align:center;"></div>
            <button type="submit" class="btn-gold" style="width: 100%; height: 50px;">BAYAR SEKARANG</button>
        </form>
    </div>

    <script>function closeModal(){ document.getElementById('errorModal').style.display='none'; }</script>
</body>
</html>