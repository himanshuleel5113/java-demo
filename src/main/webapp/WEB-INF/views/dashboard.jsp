<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "Dashboard"); request.setAttribute("activeNav", "dashboard"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div>
    <h1 class="page-title">Welcome back, <c:out value="${sessionScope.firstName}" default="there"/>! 👋</h1>
    <p class="page-sub">Here's what's happening with your accounts today.</p>
  </div>
  <div class="page-actions">
    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/accounts">View All Accounts
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
    </a>
  </div>
</div>

<!-- Stat cards -->
<div class="grid grid-4">
  <div class="card stat-card">
    <span class="stat-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="3"/><path d="M2 10h20"/></svg></span>
    <div><div class="stat-label">Total Balance</div><div class="stat-value">₹${totalBalance}</div><div class="stat-meta">Available across all accounts</div></div>
  </div>
  <div class="card stat-card">
    <span class="stat-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10 12 4l9 6"/><path d="M5 10v9h14v-9"/></svg></span>
    <div><div class="stat-label">Savings Account</div><div class="stat-value">₹${primaryBalance}</div><div class="stat-meta">${primaryMasked}</div></div>
  </div>
  <div class="card stat-card">
    <span class="stat-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="3"/><path d="M2 10h20"/></svg></span>
    <div><div class="stat-label">Account Number</div><div class="stat-value" style="font-size:1.2rem">${sessionScope.accountNo}</div><div class="stat-meta">Primary savings account</div></div>
  </div>
  <div class="card stat-card">
    <span class="stat-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="3"/><path d="M9 12h6M12 9v6"/></svg></span>
    <div><div class="stat-label">Account Type</div><div class="stat-value" style="font-size:1.2rem">Savings</div><div class="stat-meta">Status: Active</div></div>
  </div>
</div>

<!-- Recent transactions + Quick actions -->
<div class="grid grid-2" style="margin-top:20px">
  <div class="card card-pad">
    <div class="card-head"><span class="card-title">Recent Transactions</span><a class="card-link" href="${pageContext.request.contextPath}/transactions">View All</a></div>
    <c:choose>
      <c:when test="${empty recentTx}">
        <div class="muted" style="padding:18px 0;text-align:center">No transactions yet. Make a transfer to see activity here.</div>
      </c:when>
      <c:otherwise>
        <c:forEach var="t" items="${recentTx}">
          <div class="tx-item">
            <span class="tx-ic ${t.credit ? 'ic-green' : 'ic-blue'}"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 8h13l-3-3M20 16H7l3 3"/></svg></span>
            <div class="tx-body"><div class="tx-title"><c:out value="${t.title}"/></div><div class="tx-date"><c:out value="${t.date}"/></div></div>
            <span class="${t.credit ? 'amt-pos' : 'amt-neg'}"><c:out value="${t.amount}"/></span>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="card card-pad">
    <div class="card-head"><span class="card-title">Quick Actions</span></div>
    <div class="qa">
      <a class="qa-item" href="${pageContext.request.contextPath}/transfer"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="m22 2-7 20-4-9-9-4 20-7Z"/></svg></span><span class="qa-label">Send Money</span></a>
      <a class="qa-item" href="${pageContext.request.contextPath}/transfer"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="8" r="4"/><path d="M3 20c0-3.5 3-5.5 6-5.5"/><path d="M17 8v6M20 11h-6"/></svg></span><span class="qa-label">Add Beneficiary</span></a>
      <a class="qa-item" href="${pageContext.request.contextPath}/bills"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2h12v20l-3-2-3 2-3-2-3 2V2Z"/><path d="M9 7h6M9 11h6"/></svg></span><span class="qa-label">Pay Bills</span></a>
      <a class="qa-item" href="${pageContext.request.contextPath}/bills"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="7" y="2" width="10" height="20" rx="2"/><path d="M11 18h2"/></svg></span><span class="qa-label">Recharge</span></a>
      <a class="qa-item" href="${pageContext.request.contextPath}/transactions"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M7 3h7l4 4v14H7z"/><path d="M14 3v4h4M9 13h6M9 17h4"/></svg></span><span class="qa-label">Account Statement</span></a>
      <a class="qa-item" href="${pageContext.request.contextPath}/services"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3c-3 3-3 6 0 9s3 6 0 9"/><ellipse cx="12" cy="7" rx="7" ry="3"/></svg></span><span class="qa-label">Open FD</span></a>
      <a class="qa-item" href="${pageContext.request.contextPath}/loans"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 10h16M6 14h2m3 0h5"/><rect x="3" y="6" width="18" height="12" rx="3"/></svg></span><span class="qa-label">Request Loan</span></a>
      <a class="qa-item" href="${pageContext.request.contextPath}/services"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="6" cy="6" r="2.4"/><circle cx="18" cy="6" r="2.4"/><circle cx="6" cy="18" r="2.4"/><circle cx="18" cy="18" r="2.4"/></svg></span><span class="qa-label">More Services</span></a>
    </div>
  </div>
</div>

<!-- Spending overview + offers -->
<div class="grid grid-2" style="margin-top:20px">
  <div class="card card-pad">
    <div class="card-head"><div><span class="card-title">Spending Overview</span><div class="page-sub" style="font-size:.82rem">This Month</div></div><a class="card-link" href="#">View Report</a></div>
    <div style="display:flex;align-items:center;gap:28px;flex-wrap:wrap">
      <div class="donut" style="background:conic-gradient(#2563eb 0 35%, #ef4444 35% 58%, #f59e0b 58% 75%, #10b981 75% 91%, #cbd5e1 91% 100%)">
        <div class="donut-center"><div style="font-family:var(--font-head);font-weight:700;font-size:1.4rem;color:var(--navy-900)">₹18,399</div><div class="muted" style="font-size:.78rem">Total Spent</div></div>
      </div>
      <ul class="legend" style="flex:1;min-width:200px;margin:0;padding:0">
        <li><span><span class="dot" style="background:#2563eb"></span>Shopping</span><span>₹6,499 (35%)</span></li>
        <li><span><span class="dot" style="background:#ef4444"></span>Bills &amp; Utilities</span><span>₹4,250 (23%)</span></li>
        <li><span><span class="dot" style="background:#f59e0b"></span>Food &amp; Dining</span><span>₹3,210 (17%)</span></li>
        <li><span><span class="dot" style="background:#10b981"></span>Transfer &amp; Payments</span><span>₹2,940 (16%)</span></li>
        <li><span><span class="dot" style="background:#cbd5e1"></span>Others</span><span>₹1,500 (9%)</span></li>
      </ul>
    </div>
  </div>

  <div class="card card-pad">
    <div class="card-head"><div><span class="card-title">Offers For You</span><div class="page-sub" style="font-size:.82rem">Exclusive offers for our valued customers</div></div></div>
    <div style="background:linear-gradient(120deg,#3730a3,#6d28d9);border-radius:16px;padding:26px;color:#fff;display:flex;align-items:center;justify-content:space-between;gap:20px;flex-wrap:wrap">
      <div style="width:150px;height:92px;border-radius:12px;background:linear-gradient(135deg,#1e3a8a,#312e81);padding:14px;color:#fff;position:relative">
        <div style="font-weight:700;font-size:.8rem">AceBank</div>
        <div style="margin-top:18px;font-family:var(--font-head);letter-spacing:.06em;font-size:.78rem">1234 5678 9012 3456</div>
        <div style="margin-top:8px;font-size:.62rem;opacity:.8">HIMANSHU LEEL</div>
      </div>
      <div style="flex:1;min-width:180px">
        <div style="font-family:var(--font-head);font-weight:700;font-size:1.3rem;line-height:1.2">Get 5X Reward Points</div>
        <div style="opacity:.85;font-size:.9rem;margin:6px 0 14px">on all online transactions</div>
        <a class="btn" style="background:#fff;color:#4f46e5" href="#">Explore Offer</a>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
