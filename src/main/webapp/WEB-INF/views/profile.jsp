<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "Profile"); request.setAttribute("activeNav", "profile"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">My Profile</h1><p class="page-sub">Manage your personal information and account preferences.</p></div>
</div>

<div class="content-grid">
  <div class="grid">
    <!-- Profile header -->
    <div class="card card-pad">
      <div style="display:flex;gap:22px;align-items:center;flex-wrap:wrap">
        <span class="avatar lg"><c:out value="${sessionScope.initials}" default="U"/></span>
        <div style="flex:1;min-width:220px">
          <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap"><h2 style="font-family:var(--font-head);color:var(--navy-900);font-size:1.5rem"><c:out value="${pName}"/></h2><span class="pill pill-blue">💎 ${pRole}</span></div>
          <div class="grid grid-3" style="gap:14px;margin-top:14px">
            <div><div class="k-label">Customer ID</div><div class="k-val"><c:out value="${pCustomerId}"/></div></div>
            <div><div class="k-label">Email</div><div class="k-val"><c:out value="${pEmail}"/></div></div>
            <div><div class="k-label">Mobile Number</div><div class="k-val"><c:out value="${pPhone}"/></div></div>
          </div>
        </div>
        <a class="btn btn-ghost" href="#">✎ Edit Profile</a>
      </div>
    </div>

    <!-- Personal information -->
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Personal Information</span><a class="btn btn-ghost" href="#" style="padding:.5rem 1rem">✎ Edit</a></div>
      <div class="grid grid-3" style="gap:22px">
        <div><div class="k-label">Full Name</div><div class="k-val"><c:out value="${pName}"/></div></div>
        <div><div class="k-label">Email</div><div class="k-val"><c:out value="${pEmail}"/></div></div>
        <div><div class="k-label">Mobile Number</div><div class="k-val"><c:out value="${pPhone}"/></div></div>
        <div><div class="k-label">Primary Account</div><div class="k-val">${pAccount}</div></div>
        <div><div class="k-label">Father's Name</div><div class="k-val muted">Not provided</div></div>
        <div><div class="k-label">Date of Birth</div><div class="k-val muted">Not provided</div></div>
        <div><div class="k-label">PAN Number</div><div class="k-val muted">Not provided</div></div>
        <div><div class="k-label">Address</div><div class="k-val muted">Not provided</div></div>
      </div>
    </div>

    <!-- Preferences -->
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Account Preferences</span></div>
      <div class="grid grid-2" style="gap:12px 22px">
        <div class="srow"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/></svg></span><div class="srow-body"><div class="srow-title">Theme</div><div class="srow-desc">Choose your preferred theme</div></div><select class="select" style="width:auto"><option>Light</option><option>Dark</option></select></div>
        <div class="srow"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c3 3 3 15 0 18M12 3c-3 3-3 15 0 18"/></svg></span><div class="srow-body"><div class="srow-title">Language</div><div class="srow-desc">Choose your preferred language</div></div><select class="select" style="width:auto"><option>English</option></select></div>
        <div class="srow"><span class="srow-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/></svg></span><div class="srow-body"><div class="srow-title">Login Alerts</div><div class="srow-desc">Get alerts for new logins</div></div><label class="switch"><input type="checkbox" checked><span class="track"></span></label></div>
        <div class="srow"><span class="srow-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="6" width="18" height="12" rx="2"/><path d="m3 8 9 6 9-6"/></svg></span><div class="srow-body"><div class="srow-title">SMS Alerts</div><div class="srow-desc">Receive important updates on SMS</div></div><label class="switch"><input type="checkbox" checked><span class="track"></span></label></div>
        <div class="srow"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/></svg></span><div class="srow-body"><div class="srow-title">Email Alerts</div><div class="srow-desc">Receive updates on your email</div></div><label class="switch"><input type="checkbox" checked><span class="track"></span></label></div>
        <div class="srow"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 11a4 4 0 0 0-4 4v3M12 11a4 4 0 0 1 4 4v3M12 11V7a3 3 0 0 0-6 0"/></svg></span><div class="srow-body"><div class="srow-title">Biometric Login</div><div class="srow-desc">Login using fingerprint/face ID</div></div><label class="switch"><input type="checkbox" checked><span class="track"></span></label></div>
      </div>
    </div>

    <div class="note-card" style="background:#f0fdf4;border-color:#bbf7d0">
      <svg viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/><path d="M9.5 12l1.8 1.8L15 10"/></svg>
      <div style="flex:1"><b style="color:#15803d">Your account is secure</b><div class="muted" style="font-size:.85rem">Last login: 31 May 2025, 08:45 PM IST from New Delhi, India</div></div>
      <a class="btn btn-ghost" href="#">View Login History</a>
    </div>
  </div>

  <!-- Rail -->
  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Account Security</span></div>
      <a class="srow" href="#"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg></span><div class="srow-body"><div class="srow-title">Change Login Password</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="8" cy="12" r="4"/><path d="M12 12h9M17 12v4"/></svg></span><div class="srow-body"><div class="srow-title">Change Transaction PIN</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/><path d="M9.5 12l1.8 1.8L15 10"/></svg></span><div class="srow-body"><div class="srow-title">Two-Factor Authentication</div></div><span class="pill pill-green">Enabled</span></a>
      <a class="srow" href="#"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="7" y="2" width="10" height="20" rx="2"/><path d="M11 18h2"/></svg></span><div class="srow-body"><div class="srow-title">Manage Trusted Devices</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Linked Accounts</span><a class="card-link" href="#">+ Add New</a></div>
      <div class="benef"><span class="avatar" style="background:#fee2e2;color:#dc2626">HD</span><div class="benef-body"><div class="benef-name">HDFC Bank</div><div class="benef-sub">Savings Account · **** 9876</div></div><span class="pill pill-green">Primary</span></div>
      <div class="benef"><span class="avatar" style="background:#e0f2fe;color:#0284c7">PT</span><div class="benef-body"><div class="benef-name">Paytm Wallet</div><div class="benef-sub">Wallet Account · 9876 5432 1098</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="m9 6 6 6-6 6"/></svg></span></div>
      <div class="benef"><span class="avatar" style="background:#f3e8ff;color:#7c3aed">PP</span><div class="benef-body"><div class="benef-name">PhonePe</div><div class="benef-sub">UPI Account · 9876543210@ibl</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="m9 6 6 6-6 6"/></svg></span></div>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/></svg>
      <div><b style="color:var(--navy-900)">Need Help?</b><div class="muted" style="font-size:.85rem">We're here to help you with your account.</div><a class="link" href="${pageContext.request.contextPath}/help" style="font-size:.85rem">Visit Help Center</a></div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
