<%@page import="java.util.List"%>
<%@page import="com.luxland.config.DBConnection, java.sql.*, com.luxland.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Validasi Sesi User
    User user = (User) session.getAttribute("currentUser");
    if(user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    // 2. Parameter Filter untuk Guest
    String fLoc = request.getParameter("location");
    String fType = request.getParameter("type");
    String fPrice = request.getParameter("priceRange");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LuxLand Portal - <%= user.getRole() %></title>
    <!-- CSS Luar -->
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- CSS KHUSUS UNTUK MEMAKSA TABEL LEBAR & TENGAH (MENGATASI MASALAH CSS LAMA) -->
    <style>
        body { margin: 0; padding: 0; background: #0a0a0a; }
        
        /* Kontainer Utama Dashboard */
        .main-dashboard-wrapper {
            width: 95%;
            max-width: 1200px;
            margin: 120px auto 50px auto; /* Margin atas 120px agar tidak tertutup navbar */
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* Panel Kaca Versi Lebar */
        .panel-lux-wide {
            background: rgba(20, 20, 20, 0.7);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: 20px;
            padding: 40px;
            width: 100% !important; /* Paksa lebar penuh kontainer */
            box-shadow: 0 20px 50px rgba(0,0,0,0.8);
            margin-bottom: 40px;
        }

        /* Styling Tabel Profesional */
        .table-lux-full {
            width: 100%;
            border-collapse: collapse;
            color: white;
            margin-top: 20px;
        }
        .table-lux-full th {
            padding: 18px;
            background: rgba(255, 215, 0, 0.15);
            color: #ffd700;
            text-align: left;
            border-bottom: 2px solid #ffd700;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .table-lux-full td {
            padding: 18px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 14px;
            vertical-align: middle;
        }
        .table-lux-full tr:hover {
            background: rgba(255, 215, 0, 0.05);
        }

        /* Status & Button */
        .badge { padding: 6px 14px; border-radius: 20px; font-size: 11px; font-weight: bold; text-transform: uppercase; }
        .paid { background: #2ecc71; color: white; }
        .pending { background: #f1c40f; color: black; }
        .cancelled { background: #e74c3c; color: white; }
        .btn-cancel-lux { background: transparent; color: #ff4d4d; border: 1px solid #ff4d4d; padding: 5px 12px; border-radius: 5px; text-decoration: none; font-size: 11px; transition: 0.3s; }
        .btn-cancel-lux:hover { background: #ff4d4d; color: white; }

        /* Modal */
        .modal { display: none; position: fixed; z-index: 10000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.9); align-items: center; justify-content: center; }
        .modal-content { background: #111; padding: 40px; border-radius: 25px; border: 1px solid #ffd700; text-align: center; width: 400px; color: white; }
    </style>
</head>
<body>

    <!-- MODAL NOTIFIKASI -->
    <div id="loginModal" class="modal"><div class="modal-content"><i class="fa-solid fa-circle-check" style="font-size: 50px; color: #2ecc71;"></i><h2>Login Berhasil</h2><p>Selamat datang di LuxLand Portal.</p><button class="btn-gold" onclick="closeModal('loginModal')" style="margin-top:20px;">OK</button></div></div>
    <div id="payModal" class="modal"><div class="modal-content"><i class="fa-solid fa-envelope-circle-check" style="font-size: 50px; color: #2ecc71;"></i><h2>Pembayaran Berhasil</h2><p>Receipt resmi telah dikirim ke email Anda.</p><button class="btn-gold" onclick="closeModal('payModal')" style="margin-top:20px;">OK</button></div></div>
    <div id="cancelModal" class="modal"><div class="modal-content" style="border-color:#ff4d4d;"><i class="fa-solid fa-ban" style="font-size: 50px; color: #ff4d4d;"></i><h2>Booking Dibatalkan</h2><p>Pesanan telah dihapus dan unit tersedia kembali.</p><button class="btn-gold" onclick="closeModal('cancelModal')" style="margin-top:20px; background:#ff4d4d; border:none;">OK</button></div></div>

    <!-- NAVBAR -->
    <div class="navbar">
        <a href="dashboard.jsp" class="brand"><i class="fa-solid fa-hotel"></i> LuxLand Portal</a>
        <div class="user-info">
            <span>Welcome, <strong><%= user.getFullName() %></strong> (<%= user.getRole() %>)</span>
            <a href="login.jsp" class="btn-logout">Logout</a>
        </div>
    </div>

    <!-- MAIN WRAPPER (MEMAKSA LEBAR KE TENGAH) -->
    <div class="main-dashboard-wrapper">
        
        <% if(user.getRole().equalsIgnoreCase("Admin")) { %>
            <!-- ================= VIEW ADMIN: MONITORING KESELURUHAN (LEBAR PENUH) ================= -->
            <div class="panel-lux-wide">
                <h1 style="color: #ffd700; font-family: 'Playfair Display', serif;"><i class="fa-solid fa-crown"></i> Admin Global Monitor</h1>
                <p style="color: #888; margin-bottom: 30px;">Otoritas penuh untuk memantau 5 Manager Wilayah dan seluruh reservasi Indonesia.</p>

                <h3 style="color: #ffd700; border-left: 4px solid #ffd700; padding-left: 15px;">Monitoring Manager Wilayah</h3>
                <table class="table-lux-full">
                    <thead>
                        <tr><th>Nama Manager</th><th>Email Akun</th><th>Lokasi Penempatan</th></tr>
                    </thead>
                    <tbody>
                        <% try(Connection con = DBConnection.getConnection()){
                            ResultSet rs = con.createStatement().executeQuery("SELECT u.fullName, u.email, h.name FROM users u JOIN hotels h ON u.managedHotelID = h.hotelID WHERE u.role = 'HotelStaff'");
                            while(rs.next()){ %>
                            <tr>
                                <td><b><%= rs.getString(1) %></b></td>
                                <td><%= rs.getString(2) %></td>
                                <td style="color: #ffd700;"><i class="fa-solid fa-location-dot"></i> <%= rs.getString(3) %></td>
                            </tr>
                        <% }} catch(Exception e){} %>
                    </tbody>
                </table>
            </div>

            <div class="panel-lux-wide">
                <h3 style="color: #ffd700; border-left: 4px solid #ffd700; padding-left: 15px;">Monitoring Reservasi Nasional</h3>
                <table class="table-lux-full">
                    <thead>
                        <tr><th>Tamu</th><th>Lokasi Hotel</th><th>Unit</th><th>Durasi</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <% try(Connection con = DBConnection.getConnection()){
                            ResultSet rs = con.createStatement().executeQuery("SELECT u.fullName, h.name, r.roomNumber, DATEDIFF(b.checkOutDate, b.checkInDate), b.paymentStatus FROM bookings b JOIN users u ON b.userID = u.userID JOIN rooms r ON b.roomID = r.roomID JOIN hotels h ON r.hotelID = h.hotelID ORDER BY b.bookingID DESC");
                            while(rs.next()){ %>
                            <tr>
                                <td><strong><%= rs.getString(1) %></strong></td>
                                <td><%= rs.getString(2) %></td>
                                <td>#<%= rs.getString(3) %></td>
                                <td><%= rs.getInt(4) %> Malam</td>
                                <td><span class="badge <%= rs.getString(5).equalsIgnoreCase("Paid")?"paid":"pending" %>"><%= rs.getString(5) %></span></td>
                            </tr>
                        <% }} catch(Exception e){} %>
                    </tbody>
                </table>
            </div>

        <% } else if(user.getRole().equalsIgnoreCase("HotelStaff")) { %>
            <!-- ================= VIEW STAFF: DASHBOARD MANAGER CABANG (LEBAR PENUH) ================= -->
            <%
                String hotelAssigned = "Global Management";
                try(Connection con=DBConnection.getConnection()){
                    PreparedStatement ps=con.prepareStatement("SELECT name FROM hotels WHERE hotelID=?");
                    ps.setInt(1, user.getManagedHotelID());
                    ResultSet rs=ps.executeQuery(); if(rs.next()) hotelAssigned=rs.getString(1);
                }catch(Exception e){}
            %>
            <div class="panel-lux-wide">
                <h1 style="color: #ffd700; font-family: 'Playfair Display', serif;"><i class="fa-solid fa-building-user"></i> Dashboard Manager: <%= hotelAssigned %></h1>
                <p style="color: #888; margin-bottom: 30px;">Laporan hunian kamar dan identitas tamu di wilayah tugas Anda.</p>

                <table class="table-lux-full">
                    <thead>
                        <tr><th style="width:30%">Identitas Tamu</th><th>Unit Kamar</th><th>Durasi Tinggal</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <% try(Connection con = DBConnection.getConnection()){
                            PreparedStatement ps = con.prepareStatement("SELECT u.fullName, u.email, r.roomNumber, b.checkInDate, b.checkOutDate, DATEDIFF(b.checkOutDate, b.checkInDate), b.paymentStatus FROM bookings b JOIN users u ON b.userID = u.userID JOIN rooms r ON b.roomID = r.roomID WHERE r.hotelID = ? ORDER BY b.bookingID DESC");
                            ps.setInt(1, user.getManagedHotelID());
                            ResultSet rs = ps.executeQuery();
                            while(rs.next()){ %>
                            <tr>
                                <td><b><%= rs.getString(1) %></b><br><small style="color: #aaa;"><%= rs.getString(2) %></small></td>
                                <td><span style="font-size: 18px; font-weight: bold;">#<%= rs.getString(3) %></span></td>
                                <td><%= rs.getString(4) %> <small>s/d</small> <%= rs.getString(5) %><br><small style="color:#ffd700;"><%= rs.getInt(6) %> Malam</small></td>
                                <td><span class="badge <%= rs.getString(7).equalsIgnoreCase("Paid")?"paid":"pending" %>"><%= rs.getString(7) %></span></td>
                            </tr>
                        <% }} catch(Exception e){} %>
                    </tbody>
                </table>
            </div>

        <% } else { %>
            <!-- ================= VIEW GUEST: FILTER & BOOKING ================= -->
            <div class="panel-lux-wide" style="padding: 25px;">
                <form action="dashboard.jsp" method="GET" style="display: grid; grid-template-columns: 1.5fr 1fr 1.5fr 1fr; gap: 20px; align-items: end;">
                    <div><label style="color:#ffd700; font-size:11px;">Lokasi</label><select name="location" class="glass-input"><option value="">Semua Lokasi</option><option value="Jakarta">Jakarta</option><option value="Bali">Bali</option><option value="Bandung">Bandung</option><option value="Yogyakarta">Yogyakarta</option><option value="Surabaya">Surabaya</option></select></div>
                    <div><label style="color:#ffd700; font-size:11px;">Tipe Kamar</label><select name="type" class="glass-input"><option value="">Semua</option><option value="Standard">Standard</option><option value="Deluxe">Deluxe</option></select></div>
                    <div><label style="color:#ffd700; font-size:11px;">Rentang Budget</label><select name="priceRange" class="glass-input"><option value="">Semua Harga</option><option value="low">Budget (< 750k)</option><option value="mid">Premium (750k - 1.5M)</option><option value="high">Elite (1.5M+)</option></select></div>
                    <button type="submit" class="btn-gold" style="height: 48px; border:none; cursor:pointer;">CARI</button>
                </form>
            </div>

            <div class="rooms-grid" style="width: 100%; display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 30px; margin: 40px 0;">
                <% try(Connection con = DBConnection.getConnection()){
                    String sql = "SELECT r.*, h.name as hName, h.address FROM rooms r JOIN hotels h ON r.hotelID = h.hotelID WHERE r.isAvailable = 1 ";
                    if(fLoc!=null && !fLoc.isEmpty()) sql += " AND h.address LIKE '%"+fLoc+"%' ";
                    if(fType!=null && !fType.isEmpty()) sql += " AND r.type = '"+fType+"' ";
                    if("low".equals(fPrice)) sql += " AND r.pricePerNight < 750000 ";
                    else if("mid".equals(fPrice)) sql += " AND r.pricePerNight BETWEEN 750000 AND 1500000 ";
                    else if("high".equals(fPrice)) sql += " AND r.pricePerNight > 1500000 ";
                    ResultSet rs = con.createStatement().executeQuery(sql);
                    while(rs.next()){
                        boolean isDeluxe = rs.getString("type").equalsIgnoreCase("Deluxe");
                %>
                <div class="room-card" style="background: rgba(20,20,20,0.7); border: 1px solid #333; border-radius: 15px; overflow: hidden;">
                    <img src="<%= isDeluxe ? "https://images.unsplash.com/photo-1591088398332-8a7791972843?q=80&w=400" : "https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=400" %>" style="width: 100%; height: 180px; object-fit: cover;">
                    <div style="padding: 20px;">
                        <span style="color: #ffd700; font-size: 10px; font-weight: bold; text-transform: uppercase;"><%= rs.getString("type") %> Room</span>
                        <h3 style="color: white; margin: 8px 0;">#<%= rs.getString("roomNumber") %> - <%= rs.getString("hName") %></h3>
                        <p style="color: #888; font-size: 11px; margin-bottom: 12px;"><i class="fa-solid fa-location-dot"></i> <%= rs.getString("address") %></p>
                        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #1a1a1a; padding-top: 15px;">
                            <span style="color: #ffd700; font-weight: bold; font-size: 18px;">Rp <%= String.format("%,.0f", rs.getDouble("pricePerNight")) %></span>
                            <a href="booking_confirm.jsp?id=<%=rs.getInt(1)%>&num=<%=rs.getString(3)%>&price=<%=rs.getDouble(5)%>&type=<%=rs.getString(4)%>" 
                               class="btn-gold" style="padding: 8px 20px; font-size: 11px; text-decoration: none; width: auto; margin: 0;">BOOK</a>
                        </div>
                    </div>
                </div>
                <% }} catch(Exception e){} %>
            </div>

            <div class="panel-lux-wide" style="margin-top: 50px; padding: 0; overflow: hidden;">
                <h3 style="color: #ffd700; padding: 20px; border-bottom: 1px solid #333;"><i class="fa-solid fa-clock-rotate-left"></i> My Booking History</h3>
                <table class="table-lux-full">
                    <thead><tr><th style="width: 40%;">Hotel & Unit</th><th>Total Biaya</th><th>Status</th><th style="text-align: center;">Aksi</th></tr></thead>
                    <tbody>
                        <% try(Connection con = DBConnection.getConnection()){
                            PreparedStatement ps = con.prepareStatement("SELECT b.bookingID, b.totalPrice, b.paymentStatus, r.roomNumber, h.name FROM bookings b JOIN rooms r ON b.roomID = r.roomID JOIN hotels h ON r.hotelID = h.hotelID WHERE b.userID = ? ORDER BY b.bookingID DESC");
                            ps.setInt(1, user.getUserID());
                            ResultSet rs = ps.executeQuery();
                            while(rs.next()){
                                String st = rs.getString(3);
                        %>
                        <tr>
                            <td><b><%= rs.getString(5) %></b><br><small>Unit #<%= rs.getString(4) %></small></td>
                            <td style="color: #ffd700; font-weight: bold;">Rp <%= String.format("%,.0f", rs.getDouble(2)) %></td>
                            <td><span class="badge <%= st.toLowerCase() %>"><%= st %></span></td>
                            <td style="text-align: center;">
                                <% if(st.equalsIgnoreCase("Pending")) { %>
                                    <a href="payment.jsp?bid=<%= rs.getInt(1) %>&total=<%= rs.getDouble(2) %>" class="btn-gold" style="padding: 6px 15px; font-size: 10px; text-decoration: none; width: auto;">PAY NOW</a>
                                    <a href="CancelBookingServlet?bid=<%= rs.getInt(1) %>" class="btn-cancel-lux" onclick="return confirm('Batalkan pesanan?')">CANCEL</a>
                                <% } else { %> <span style="color: #555;">No Action</span> <% } %>
                            </td>
                        </tr>
                        <% }} catch(Exception e){} %>
                    </tbody>
                </table>
            </div>
        <% } %>

    </div> <!-- End Dashboard Wrapper -->

    <!-- FOOTER -->
    <div class="footer-lux">
        <div style="display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 60px; max-width: 1200px; margin: auto;">
            <div><h3>LUXLAND HOTEL GROUP</h3><p>Kenyamanan tak tertandingi di destinasi pilihan Indonesia.</p></div>
            <div><h4>LOCATIONS</h4><p>Jakarta • Bali • Bandung • Yogyakarta</p></div>
            <div><h4>CONTACT</h4><p>+62 21 8000 9999<br>help@luxland.com</p></div>
        </div>
        <div style="text-align: center; margin-top: 60px; font-size: 11px;">&copy; 2025 LUXLAND HOTELS. ALL RIGHTS RESERVED.</div>
    </div>

    <script>
        window.onload = function() {
            const p = new URLSearchParams(window.location.search);
            if(p.get('login')==='success') document.getElementById('loginModal').style.display='flex';
            if(p.get('payment')==='success') document.getElementById('payModal').style.display='flex';
            if(p.get('cancel')==='success') document.getElementById('cancelModal').style.display='flex';
        };
        function closeModal(id) { document.getElementById(id).style.display = 'none'; }
    </script>
</body>
</html>