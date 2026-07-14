<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "Settings"); request.setAttribute("activeNav", "settings"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">Settings</h1><p class="page-sub">Manage your account settings and preferences.</p></div>
</div>

<div class="content-grid">
  <div class="grid">
    <c:if test="${not empty success}"><div class="alert-banner alert-ok"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert-banner alert-error"><c:out value="${error}"/></div></c:if>

    <!-- Change password -->
    <div class="card card-pad" id="change-password">
      <div class="card-head"><span class="card-title">Change Password</span></div>
      <form action="${pageContext.request.contextPath}/settings" method="post">
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
        <div class="field"><label for="currentPassword">Current Password</label>
          <input class="input" type="password" id="currentPassword" name="currentPassword" autocomplete="current-password" required></div>
        <div class="grid grid-2" style="gap:0 20px">
          <div class="field"><label for="newPassword">New Password</label>
            <input class="input" type="password" id="newPassword" name="newPassword" autocomplete="new-password" minlength="8" required></div>
          <div class="field"><label for="confirmPassword">Confirm New Password</label>
            <input class="input" type="password" id="confirmPassword" name="confirmPassword" autocomplete="new-password" minlength="8" required></div>
        </div>
        <p class="muted" style="font-size:.8rem;margin:0 0 12px">At least 8 characters with an uppercase letter, a lowercase letter and a number.</p>
        <button type="submit" class="btn btn-blue btn-lg">Update Password</button>
      </form>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Account Settings</span></div>
      <a class="srow" href="${pageContext.request.contextPath}/profile"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/></svg></span><div class="srow-body"><div class="srow-title">Personal Information</div><div class="srow-desc">Update your personal details and contact information</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg></span><div class="srow-body"><div class="srow-title">Account Preferences</div><div class="srow-desc">Manage your account preferences and display settings</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/></svg></span><div class="srow-body"><div class="srow-title">Notifications</div><div class="srow-desc">Manage email, SMS and push notification settings</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 10 12 4l9 6M5 10v9h14v-9"/></svg></span><div class="srow-body"><div class="srow-title">Linked Accounts</div><div class="srow-desc">View and manage your linked bank accounts and wallets</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">App Settings</span></div>
      <a class="srow" href="#"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="7" y="2" width="10" height="20" rx="2"/><path d="M11 18h2"/></svg></span><div class="srow-body"><div class="srow-title">App Preferences</div><div class="srow-desc">Manage app appearance and behavior</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c3 3 3 15 0 18M12 3c-3 3-3 15 0 18"/></svg></span><div class="srow-body"><div class="srow-title">Language</div><div class="srow-desc">Choose your preferred language</div></div><button class="btn btn-ghost" style="padding:.4rem .9rem">English ›</button></a>
      <a class="srow" href="#"><span class="srow-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg></span><div class="srow-body"><div class="srow-title">Privacy Settings</div><div class="srow-desc">Manage your privacy and data sharing preferences</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3v12M8 11l4 4 4-4M5 21h14"/></svg></span><div class="srow-body"><div class="srow-title">Download Center</div><div class="srow-desc">Download statements, reports and certificates</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg>
      <div style="flex:1"><b style="color:var(--blue-600)">Keep your account secure!</b><div class="muted" style="font-size:.85rem">Regularly update your password and enable 2FA for enhanced security.</div></div>
      <a class="btn btn-ghost" href="#">Security Tips</a>
    </div>
  </div>

  <!-- Rail -->
  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Security Settings</span></div>
      <a class="srow" href="#change-password"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg></span><div class="srow-body"><div class="srow-title">Change Password</div><div class="srow-desc">Update your login password</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="8" cy="12" r="4"/><path d="M12 12h9M17 12v4"/></svg></span><div class="srow-body"><div class="srow-title">Change Transaction PIN</div><div class="srow-desc">Update your transaction PIN</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/><path d="M9.5 12l1.8 1.8L15 10"/></svg></span><div class="srow-body"><div class="srow-title">Two-Factor Authentication</div><div class="srow-desc">Add an extra layer of security</div></div><span class="pill pill-green">Enabled</span></a>
      <a class="srow" href="#"><span class="srow-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="7" y="2" width="10" height="20" rx="2"/><path d="M11 18h2"/></svg></span><div class="srow-body"><div class="srow-title">Manage Trusted Devices</div><div class="srow-desc">View and manage trusted devices</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><span class="srow-ic ic-rose"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M15 4h3a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-3"/><path d="M10 17 5 12l5-5M5 12h11"/></svg></span><div class="srow-body"><div class="srow-title">Active Sessions</div><div class="srow-desc">Manage your active login sessions</div></div><span class="pill pill-blue">2 Active</span></a>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Preferences</span></div>
      <div class="srow"><span class="srow-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/></svg></span><div class="srow-body"><div class="srow-title">Dark Mode</div><div class="srow-desc">Switch between light and dark theme</div></div><label class="switch"><input type="checkbox"><span class="track"></span></label></div>
      <div class="srow"><span class="srow-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 11a4 4 0 0 0-4 4v3M12 11a4 4 0 0 1 4 4v3M12 11V7a3 3 0 0 0-6 0"/></svg></span><div class="srow-body"><div class="srow-title">Biometric Login</div><div class="srow-desc">Login using fingerprint or face ID</div></div><label class="switch"><input type="checkbox" checked><span class="track"></span></label></div>
      <div class="srow"><span class="srow-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg></span><div class="srow-body"><div class="srow-title">Quick Balance</div><div class="srow-desc">Show quick balance on login screen</div></div><label class="switch"><input type="checkbox" checked><span class="track"></span></label></div>
      <div class="srow"><span class="srow-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 11l18-6-6 18-3-7-9-5Z"/></svg></span><div class="srow-body"><div class="srow-title">Marketing Communications</div><div class="srow-desc">Receive offers and updates via email/SMS</div></div><label class="switch"><input type="checkbox"><span class="track"></span></label></div>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/></svg>
      <div><b style="color:var(--navy-900)">Need Help?</b><div class="muted" style="font-size:.85rem">Can't find what you're looking for? Contact our support team.</div><a class="link" href="${pageContext.request.contextPath}/help" style="font-size:.85rem">Contact Support</a></div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
