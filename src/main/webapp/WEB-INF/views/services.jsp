<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("pageTitle", "Services"); request.setAttribute("activeNav", "services"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">Services</h1><p class="page-sub">Explore our wide range of banking services designed for you.</p></div>
</div>

<div class="content-grid">
  <div class="grid">
    <div class="input-group">
      <span class="lead-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="m21 21-4-4"/></svg></span>
      <input class="input" placeholder="Search services...">
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Quick Access</span></div>
      <div class="qa" style="grid-template-columns:repeat(6,1fr)">
        <a class="qa-item" href="${pageContext.request.contextPath}/transactions"><span class="qa-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M7 3h7l4 4v14H7z"/><path d="M14 3v4h4"/></svg></span><span class="qa-label">Account Statement</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/help"><span class="qa-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="6" width="18" height="12" rx="2"/><path d="m7 12 3 3 5-6"/></svg></span><span class="qa-label">Cheque Book Request</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/help"><span class="qa-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3c-3 3-3 6 0 9s3 6 0 9"/><ellipse cx="12" cy="7" rx="7" ry="3"/></svg></span><span class="qa-label">Fixed Deposit</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/help"><span class="qa-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 12a8 8 0 0 1 14-5M20 12a8 8 0 0 1-14 5"/><path d="M18 3v4h-4M6 21v-4h4"/></svg></span><span class="qa-label">Recurring Deposit</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/bills"><span class="qa-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="5" y="3" width="14" height="18" rx="2"/><path d="M9 8h6M9 12h6M9 16h4"/></svg></span><span class="qa-label">Tax Payments</span></a>
        <a class="qa-item" href="${pageContext.request.contextPath}/transfer"><span class="qa-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="9" cy="8" r="3"/><path d="M15 11a3 3 0 1 0 0-6"/><path d="M3 20c0-3 3-5 6-5s6 2 6 5M17 20c0-2-1-3.5-3-4.5"/></svg></span><span class="qa-label">Manage Beneficiaries</span></a>
      </div>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">All Services</span></div>
      <div class="tabs"><span class="tab active">Account Services</span><span class="tab">Payments</span><span class="tab">Investments</span><span class="tab">Insurance</span><span class="tab">Other Services</span></div>
      <div class="grid grid-2" style="gap:12px 16px">
        <a class="srow" href="${pageContext.request.contextPath}/transactions"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M7 3h7l4 4v14H7z"/><path d="M14 3v4h4"/></svg></span><div class="srow-body"><div class="srow-title">Account Statement</div><div class="srow-desc">View and download your account statements</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="${pageContext.request.contextPath}/accounts"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M7 3h10v18H7z"/><path d="M10 8h4M10 12h4"/></svg></span><div class="srow-body"><div class="srow-title">Account Details</div><div class="srow-desc">View your account details and balance</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="#"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="6" width="18" height="12" rx="2"/><path d="m7 12 3 3 5-6"/></svg></span><div class="srow-body"><div class="srow-title">Cheque Book Request</div><div class="srow-desc">Request new cheque book online</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="#"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="6" width="18" height="12" rx="2"/><path d="M8 12h8"/></svg></span><div class="srow-body"><div class="srow-title">Cheque Status</div><div class="srow-desc">Check status of issued cheques</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="#"><span class="srow-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M9 9l6 6M15 9l-6 6"/></svg></span><div class="srow-body"><div class="srow-title">Stop Cheque</div><div class="srow-desc">Stop a cheque payment</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="#"><span class="srow-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/></svg></span><div class="srow-body"><div class="srow-title">Manage Alerts</div><div class="srow-desc">Manage SMS and Email alerts</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="#"><span class="srow-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M9 9l6 6M15 9l-6 6"/></svg></span><div class="srow-body"><div class="srow-title">Update KYC</div><div class="srow-desc">Update your KYC information</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="#"><span class="srow-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 21s7-5 7-11a7 7 0 0 0-14 0c0 6 7 11 7 11Z"/><circle cx="12" cy="10" r="2.5"/></svg></span><div class="srow-body"><div class="srow-title">Branch &amp; ATM Locator</div><div class="srow-desc">Find nearest branches and ATMs</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="#"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="9" cy="8" r="3"/><path d="M3 20c0-3 3-5 6-5s6 2 6 5"/><path d="M17 4v6M20 7h-6"/></svg></span><div class="srow-body"><div class="srow-title">Nominee Management</div><div class="srow-desc">Add or update account nominees</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
        <a class="srow" href="#"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M7 3h10v18H7z"/><circle cx="12" cy="10" r="2"/><path d="M9 21l3-2 3 2"/></svg></span><div class="srow-body"><div class="srow-title">View Interest Certificate</div><div class="srow-desc">Download your interest certificates</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      </div>
    </div>
  </div>

  <!-- Rail -->
  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Service Shortcuts</span></div>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title">Download Account Statement</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title">Request Cheque Book</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title">Manage Beneficiaries</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title">Update Mobile Number</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
    </div>

    <div class="card card-pad" style="background:linear-gradient(120deg,#eef4ff,#f6f9ff);border-color:#e2ebff">
      <h3 style="font-family:var(--font-head);color:var(--navy-900);font-size:1.1rem;font-weight:700">Invest for your future</h3>
      <p class="muted" style="margin:6px 0 14px;font-size:.88rem">Explore our investment options and grow your wealth securely.</p>
      <a class="btn btn-blue" href="#">Explore Investments</a>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/></svg>
      <div><b style="color:var(--navy-900)">Need Help?</b><div class="muted" style="font-size:.85rem">We're here to assist you 24/7.</div><a class="link" href="${pageContext.request.contextPath}/help" style="font-size:.85rem">Contact Support</a></div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
