<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — AceBank</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/favicon.svg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/acebank.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card">
    <div class="auth-left">
      <a class="brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="AceBank home">
        <span class="brand-mark"><svg viewBox="0 0 44 44" fill="none" aria-hidden="true"><path d="M22 3 41 38H3L22 3Z" fill="#2563eb"/><path d="M22 3 41 38H26L22 3Z" fill="#1e3a8a"/><path d="M22 16 30 31H14l8-15Z" fill="#fff"/></svg></span>
        <span class="brand-name">AceBank</span>
      </a>
      <h2 class="auth-welcome">Open your <span class="lite">Account</span></h2>
      <p class="lead">Join AceBank in minutes — zero balance, instant activation, and bank-grade security.</p>
      <div class="auth-shield" aria-hidden="true">
        <svg viewBox="0 0 200 210" fill="none" xmlns="http://www.w3.org/2000/svg">
          <ellipse cx="100" cy="180" rx="86" ry="16" fill="#1d4ed8" opacity=".25"/>
          <path d="M100 14l64 24v54c0 46-30 72-64 90-34-18-64-44-64-90V38l64-24Z" fill="url(#g2)"/>
          <path d="M100 14l64 24v54c0 46-30 72-64 90V14Z" fill="#1e40af" opacity=".55"/>
          <path d="M78 104l16 16 30-32" stroke="#fff" stroke-width="9" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
          <defs><linearGradient id="g2" x1="36" y1="14" x2="164" y2="182" gradientUnits="userSpaceOnUse"><stop stop-color="#3b82f6"/><stop offset="1" stop-color="#1e40af"/></linearGradient></defs>
        </svg>
      </div>
      <div class="auth-features">
        <div class="auth-feature"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg><h5>Zero Balance</h5><p>No minimum required</p></div>
        <div class="auth-feature"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M13 2 4 14h7l-1 8 9-12h-7l1-8Z"/></svg><h5>Instant</h5><p>Activate immediately</p></div>
        <div class="auth-feature"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/></svg><h5>24/7 Support</h5><p>Always here for you</p></div>
      </div>
    </div>

    <div class="auth-right">
      <h1>Create Account</h1>
      <p class="sub">It only takes a minute</p>

      <c:if test="${not empty error}">
        <div class="alert-banner alert-error"><c:out value="${error}"/></div>
      </c:if>

      <form action="${pageContext.request.contextPath}/signup" method="post" novalidate>
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:0 16px">
          <div class="field"><label for="firstName">First Name</label><input class="input" id="firstName" name="firstName" value="<c:out value='${param.firstName}'/>" placeholder="John" required></div>
          <div class="field"><label for="lastName">Last Name</label><input class="input" id="lastName" name="lastName" value="<c:out value='${param.lastName}'/>" placeholder="Doe" required></div>
        </div>
        <div class="field"><label for="email">Email Address</label>
          <div class="input-group"><span class="lead-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/></svg></span><input class="input" type="email" id="email" name="email" value="<c:out value='${param.email}'/>" placeholder="john@example.com" required></div>
        </div>
        <div class="field"><label for="phone">Phone (optional)</label>
          <div class="input-group"><span class="lead-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 5c0 9 6 15 15 15l1-4-5-2-2 2a11 11 0 0 1-5-5l2-2-2-5-4 1Z"/></svg></span><input class="input" id="phone" name="phone" value="<c:out value='${param.phone}'/>" placeholder="+91 98765 43210"></div>
        </div>
        <div class="field"><label for="password">Password</label>
          <div class="input-group"><span class="lead-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg></span>
            <input class="input" type="password" id="password" name="password" placeholder="Min 8 chars, 1 upper, 1 number" autocomplete="new-password" required>
            <button type="button" class="trail-btn" data-toggle-password aria-label="Show password"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg></button>
          </div>
        </div>
        <button type="submit" class="btn btn-blue btn-lg btn-block" style="margin-top:6px">Create Account</button>
      </form>
      <p class="auth-foot">Already have an account? <a class="link" href="${pageContext.request.contextPath}/login">Sign In</a></p>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/acebank.js"></script>
</body>
</html>
