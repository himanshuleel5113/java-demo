<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("pageTitle", "Dashboard"); request.setAttribute("activeNav", "dashboard"); %>
<jsp:include page="/WEB-INF/includes/admin-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">Welcome back, Admin!</h1><p class="page-sub">Here's what's happening with AceBank.</p></div>
  <div class="page-actions">
    <select class="select" style="width:auto"><option>31 May 2025 - 31 May 2025</option></select>
    <a class="btn btn-blue" href="#"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 3v12M8 11l4 4 4-4M5 21h14"/></svg> Download Report</a>
  </div>
</div>

<!-- KPI row -->
<div class="kpi-row">
  <div class="card stat-card"><span class="stat-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="9" cy="8" r="3.5"/><path d="M15 8a3.5 3.5 0 1 0 0-7M3 20c0-3.5 3-5.5 6-5.5s6 2 6 5.5"/></svg></span><div><div class="stat-label">Total Customers</div><div class="stat-value">12,548</div><div class="stat-meta"><span class="up">↑ 8.45%</span> vs last month</div></div></div>
  <div class="card stat-card"><span class="stat-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 10 12 4l9 6M5 10v9h14v-9"/></svg></span><div><div class="stat-label">Total Accounts</div><div class="stat-value">18,756</div><div class="stat-meta"><span class="up">↑ 6.32%</span> vs last month</div></div></div>
  <div class="card stat-card"><span class="stat-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 7h12l-3-3M20 17H8l3 3"/></svg></span><div><div class="stat-label">Total Transactions</div><div class="stat-value">95,842</div><div class="stat-meta"><span class="up">↑ 12.75%</span> vs last month</div></div></div>
  <div class="card stat-card"><span class="stat-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 7h16v10H4z"/><circle cx="12" cy="12" r="2.5"/></svg></span><div><div class="stat-label">Total Deposits</div><div class="stat-value">₹1,248.75 Cr</div><div class="stat-meta"><span class="up">↑ 9.80%</span> vs last month</div></div></div>
  <div class="card stat-card"><span class="stat-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M9 15c0 1.5 1.3 2 3 2s3-.7 3-2-1-1.8-3-2.2S9 11.5 9 10s1.3-2 3-2 3 .5 3 2M12 6v2M12 16v2"/></svg></span><div><div class="stat-label">Total Loans</div><div class="stat-value">₹798.45 Cr</div><div class="stat-meta"><span class="up">↑ 7.21%</span> vs last month</div></div></div>
</div>

<!-- Chart + alerts -->
<div class="grid" style="grid-template-columns:1.9fr 1fr;margin-top:20px">
  <div class="card card-pad">
    <div class="card-head"><div><span class="card-title">Transaction Overview</span><div style="display:flex;gap:16px;margin-top:8px;font-size:.8rem"><span style="color:var(--blue-600)">— Transactions</span><span class="muted">- - Previous Period</span></div></div><select class="select" style="width:auto"><option>This Month</option></select></div>
    <svg width="100%" height="250" viewBox="0 0 720 250" preserveAspectRatio="none" fill="none">
      <g stroke="#eef1f6" stroke-width="1"><path d="M0 40h720M0 90h720M0 140h720M0 190h720M0 240h720"/></g>
      <path d="M0 200 C40 190 60 150 90 165 C130 185 150 120 190 150 C230 175 250 205 290 195 C330 185 350 140 390 160 C430 178 450 150 490 155 C540 160 560 120 600 130 C650 142 680 95 720 100 L720 250 L0 250 Z" fill="url(#ag)" opacity=".5"/>
      <path d="M0 200 C40 190 60 150 90 165 C130 185 150 120 190 150 C230 175 250 205 290 195 C330 185 350 140 390 160 C430 178 450 150 490 155 C540 160 560 120 600 130 C650 142 680 95 720 100" stroke="#2563eb" stroke-width="2.5" fill="none"/>
      <path d="M0 210 C60 205 120 190 190 195 C260 200 320 185 390 185 C470 185 540 175 600 168 C660 162 690 150 720 148" stroke="#cbd5e1" stroke-width="2" stroke-dasharray="5 5" fill="none"/>
      <circle cx="290" cy="195" r="5" fill="#2563eb" stroke="#fff" stroke-width="2"/>
      <defs><linearGradient id="ag" x1="0" y1="90" x2="0" y2="250"><stop stop-color="#2563eb" stop-opacity=".35"/><stop offset="1" stop-color="#2563eb" stop-opacity="0"/></linearGradient></defs>
    </svg>
    <div style="display:flex;justify-content:space-between;color:var(--muted);font-size:.76rem;margin-top:4px"><span>01 May</span><span>06 May</span><span>11 May</span><span>16 May</span><span>21 May</span><span>26 May</span><span>31 May</span></div>
  </div>

  <div class="card card-pad">
    <div class="card-head"><span class="card-title">Recent System Alerts</span><a class="card-link" href="#">View All</a></div>
    <div class="alert"><span class="alert-ic ic-rose"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3 2 20h20L12 3ZM12 10v4M12 17v.5"/></svg></span><div class="alert-body"><div class="alert-title">High Failed Transactions</div><div class="alert-desc">152 failed transactions in the last 1 hour.</div></div><span class="alert-time">10:15 AM</span></div>
    <div class="alert"><span class="alert-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3 2 20h20L12 3ZM12 10v4M12 17v.5"/></svg></span><div class="alert-body"><div class="alert-title">Server CPU Usage High</div><div class="alert-desc">CPU usage is above 85%.</div></div><span class="alert-time">09:45 AM</span></div>
    <div class="alert"><span class="alert-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M12 8v.5M12 11v5"/></svg></span><div class="alert-body"><div class="alert-title">Scheduled Maintenance</div><div class="alert-desc">System maintenance on 02 Jun 2025.</div></div><span class="alert-time">09:00 AM</span></div>
    <div class="alert"><span class="alert-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="m8 12 3 3 5-6"/></svg></span><div class="alert-body"><div class="alert-title">Database Backup Completed</div><div class="alert-desc">Daily backup completed successfully.</div></div><span class="alert-time">08:30 AM</span></div>
  </div>
</div>

<!-- Overviews + quick actions -->
<div class="grid grid-3" style="margin-top:20px">
  <div class="card card-pad">
    <div class="card-head"><span class="card-title">User Overview</span></div>
    <div style="display:flex;align-items:center;gap:20px;flex-wrap:wrap">
      <div class="donut" style="width:150px;height:150px;background:conic-gradient(#2563eb 0 73.6%, #7c3aed 73.6% 90.7%, #10b981 90.7% 98.9%, #f59e0b 98.9% 100%)"><div class="donut-center"><div style="font-family:var(--font-head);font-weight:700;font-size:1.1rem;color:var(--navy-900)">12,548</div><div class="muted" style="font-size:.68rem">Total Users</div></div></div>
      <ul class="legend" style="flex:1;min-width:150px">
        <li><span><span class="dot" style="background:#2563eb"></span>Active Users</span><span>9,245 (73.6%)</span></li>
        <li><span><span class="dot" style="background:#7c3aed"></span>Inactive Users</span><span>2,153 (17.1%)</span></li>
        <li><span><span class="dot" style="background:#10b981"></span>New This Month</span><span>1,024 (8.2%)</span></li>
        <li><span><span class="dot" style="background:#f59e0b"></span>Blocked Users</span><span>126 (1.1%)</span></li>
      </ul>
    </div>
  </div>

  <div class="card card-pad">
    <div class="card-head"><span class="card-title">Account Overview</span></div>
    <div style="display:flex;align-items:center;gap:20px;flex-wrap:wrap">
      <div class="donut" style="width:150px;height:150px;background:conic-gradient(#2563eb 0 59.9%, #7c3aed 59.9% 81.9%, #10b981 81.9% 97.8%, #f59e0b 97.8% 100%)"><div class="donut-center"><div style="font-family:var(--font-head);font-weight:700;font-size:1.1rem;color:var(--navy-900)">18,756</div><div class="muted" style="font-size:.68rem">Total Accounts</div></div></div>
      <ul class="legend" style="flex:1;min-width:150px">
        <li><span><span class="dot" style="background:#2563eb"></span>Savings</span><span>11,245 (59.9%)</span></li>
        <li><span><span class="dot" style="background:#7c3aed"></span>Current</span><span>4,125 (22.0%)</span></li>
        <li><span><span class="dot" style="background:#10b981"></span>Fixed Deposit</span><span>2,986 (15.9%)</span></li>
        <li><span><span class="dot" style="background:#f59e0b"></span>Others</span><span>400 (2.2%)</span></li>
      </ul>
    </div>
  </div>

  <div class="card card-pad">
    <div class="card-head"><span class="card-title">Quick Actions</span></div>
    <div class="qa" style="grid-template-columns:repeat(3,1fr)">
      <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="9" cy="8" r="4"/><path d="M3 20c0-3.5 3-5.5 6-5.5M17 8v6M20 11h-6"/></svg></span><span class="qa-label">Add New User</span></a>
      <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 10 12 4l9 6M5 10v9h14v-9"/></svg></span><span class="qa-label">Open New Account</span></a>
      <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 7h12l-3-3M20 17H8l3 3"/></svg></span><span class="qa-label">View Transactions</span></a>
      <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M7 3h7l4 4v14H7z"/><path d="M14 3v4h4"/></svg></span><span class="qa-label">Generate Report</span></a>
      <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="3"/><path d="M19 12a7 7 0 0 0-.1-1.2l2-1.6-2-3.4-2.4 1a7 7 0 0 0-2-1.2L14 2h-4l-.5 2.6a7 7 0 0 0-2 1.2l-2.4-1-2 3.4 2 1.6a7 7 0 0 0 0 2.4l-2 1.6 2 3.4 2.4-1a7 7 0 0 0 2 1.2L10 22h4l.5-2.6a7 7 0 0 0 2-1.2l2.4 1 2-3.4-2-1.6Z"/></svg></span><span class="qa-label">System Settings</span></a>
      <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8" cy="12" r="2"/><path d="M13 10h5M13 14h5"/></svg></span><span class="qa-label">Manage KYC</span></a>
    </div>
  </div>
</div>

<!-- Latest transactions + system summary -->
<div class="grid" style="grid-template-columns:1.9fr 1fr;margin-top:20px">
  <div class="card card-pad">
    <div class="card-head"><span class="card-title">Latest Transactions</span><a class="card-link" href="#">View All Transactions</a></div>
    <div style="overflow-x:auto"><table class="table">
      <thead><tr><th>Transaction ID</th><th>Customer</th><th>Type</th><th>Amount</th><th>Status</th><th>Date &amp; Time</th></tr></thead>
      <tbody>
        <tr><td>TXN125842</td><td>Rahul Sharma</td><td>Fund Transfer</td><td>₹25,000.00</td><td><span class="pill pill-green">Success</span></td><td>31 May 2025, 10:25 AM</td></tr>
        <tr><td>TXN125841</td><td>Priya Verma</td><td>Bill Payment</td><td>₹1,250.00</td><td><span class="pill pill-green">Success</span></td><td>31 May 2025, 10:22 AM</td></tr>
        <tr><td>TXN125840</td><td>Amit Kumar</td><td>Cash Deposit</td><td>₹10,000.00</td><td><span class="pill pill-green">Success</span></td><td>31 May 2025, 10:18 AM</td></tr>
        <tr><td>TXN125839</td><td>Neha Singh</td><td>ATM Withdrawal</td><td>₹5,000.00</td><td><span class="pill pill-rose">Failed</span></td><td>31 May 2025, 10:15 AM</td></tr>
        <tr><td>TXN125838</td><td>Vikram Patel</td><td>UPI Payment</td><td>₹2,450.00</td><td><span class="pill pill-green">Success</span></td><td>31 May 2025, 10:12 AM</td></tr>
      </tbody>
    </table></div>
  </div>

  <div class="card card-pad">
    <div class="card-head"><span class="card-title">System Summary</span></div>
    <div class="benef"><div class="benef-body"><div class="benef-name" style="font-weight:500">Uptime</div></div><span class="up">99.98%</span></div>
    <div class="benef"><div class="benef-body"><div class="benef-name" style="font-weight:500">Active Sessions</div></div><b style="color:var(--navy-900)">245</b></div>
    <div class="benef"><div class="benef-body"><div class="benef-name" style="font-weight:500">Database Status</div></div><span class="up">Healthy</span></div>
    <div class="benef"><div class="benef-body"><div class="benef-name" style="font-weight:500">Server Status</div></div><span class="up">Healthy</span></div>
    <div class="benef"><div class="benef-body"><div class="benef-name" style="font-weight:500">Last Backup</div></div><span class="muted">31 May 2025, 08:30 AM</span></div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
