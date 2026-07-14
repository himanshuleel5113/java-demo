<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "My Accounts"); request.setAttribute("activeNav", "accounts"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">My Accounts</h1></div>
  <div class="page-actions">
    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/deposit">Deposit</a>
    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/withdraw">Withdraw</a>
  </div>
</div>

<div class="content-grid">
  <div>
    <c:choose>
      <c:when test="${empty accountRows}">
        <div class="card card-pad muted">No accounts yet.</div>
      </c:when>
      <c:otherwise>
        <c:forEach var="a" items="${accountRows}">
          <div class="acct ${a.variant}">
            <span class="acct-ic ${a.icon}"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10 12 4l9 6"/><path d="M5 10v9h14v-9"/></svg></span>
            <div><div class="acct-name"><c:out value="${a.name}"/></div><div class="acct-num"><c:out value="${a.number}"/></div></div>
            <div class="k"><div class="k-label">Available Balance</div><div class="k-val">₹<c:out value="${a.balance}"/></div></div>
            <div class="k"><div class="k-label">IFSC Code</div><div class="k-val"><c:out value="${a.ifsc}"/></div></div>
            <div class="acct-side"><a class="card-link" href="${pageContext.request.contextPath}/transactions">View Statement</a></div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>

    <div class="card promo-card" style="margin-top:20px">
      <div style="max-width:52ch">
        <h3 style="font-family:var(--font-head);color:var(--navy-900);font-size:1.3rem;font-weight:700">Bank anytime, anywhere!</h3>
        <p class="muted" style="margin:8px 0 16px">Access your accounts and manage your finances on the go with our mobile app.</p>
        <a class="btn btn-ghost" href="#"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="7" y="2" width="10" height="20" rx="2"/><path d="M11 18h2"/></svg> Download App</a>
      </div>
      <svg width="150" height="120" viewBox="0 0 150 120" fill="none" aria-hidden="true"><rect x="46" y="14" width="70" height="100" rx="12" fill="#1e3a8a"/><rect x="52" y="24" width="58" height="80" rx="6" fill="#fff"/><rect x="60" y="34" width="42" height="8" rx="4" fill="#dbe6f8"/><rect x="60" y="50" width="30" height="6" rx="3" fill="#e8eefb"/><rect x="60" y="62" width="42" height="6" rx="3" fill="#e8eefb"/></svg>
    </div>
  </div>

  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Account Summary</span></div>
      <div style="text-align:center">
        <div class="stat-label">Total Balance across all accounts</div>
        <div style="font-family:var(--font-head);font-weight:700;font-size:2rem;color:var(--navy-900);margin-top:6px">₹${totalBalance}</div>
      </div>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Quick Actions</span></div>
      <div class="qa" style="grid-template-columns:repeat(3,1fr)">
        <a class="qa-item" href="${pageContext.request.contextPath}/deposit"><span class="qa-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 19V5M5 12l7-7 7 7"/></svg></span><span class="qa-label">Deposit</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/withdraw"><span class="qa-ic ic-rose"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 5v14M5 12l7 7 7-7"/></svg></span><span class="qa-label">Withdraw</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/transfer"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 8h13l-3-3M20 16H7l3 3"/></svg></span><span class="qa-label">Transfer</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/transactions"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M7 3h7l4 4v14H7z"/><path d="M14 3v4h4"/></svg></span><span class="qa-label">Statement</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/cards"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="2" y="5" width="20" height="14" rx="3"/><path d="M2 10h20"/></svg></span><span class="qa-label">Cards</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/bills"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 2h12v20l-3-2-3 2-3-2-3 2V2Z"/></svg></span><span class="qa-label">Pay Bills</span></a>
      </div>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Account Limits</span></div>
      <div class="limit"><div class="limit-top"><span class="limit-name">Daily Withdrawal Limit</span><span class="limit-val">₹1,00,000.00</span></div><div class="progress"><span style="width:35%"></span></div></div>
      <div class="limit"><div class="limit-top"><span class="limit-name">Daily Transfer Limit</span><span class="limit-val">₹2,00,000.00</span></div><div class="progress"><span style="width:25%"></span></div></div>
      <div class="limit"><div class="limit-top"><span class="limit-name">Daily UPI Limit</span><span class="limit-val">₹1,00,000.00</span></div><div class="progress"><span style="width:40%"></span></div></div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
