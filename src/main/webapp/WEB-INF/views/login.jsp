<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In — AceBank</title>
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
      <h2 class="auth-welcome">Welcome <span class="lite">Back!</span></h2>
      <p class="lead">Login to access your AceBank account and manage your finances securely.</p>
      <div class="auth-shield" aria-hidden="true">
        <svg viewBox="0 0 200 210" fill="none" xmlns="http://www.w3.org/2000/svg">
          <ellipse cx="100" cy="180" rx="86" ry="16" fill="#1d4ed8" opacity=".25"/>
          <path d="M100 14l64 24v54c0 46-30 72-64 90-34-18-64-44-64-90V38l64-24Z" fill="url(#g)"/>
          <path d="M100 14l64 24v54c0 46-30 72-64 90V14Z" fill="#1e40af" opacity=".55"/>
          <rect x="82" y="96" width="36" height="34" rx="7" fill="#fff"/>
          <path d="M88 96v-8a12 12 0 0 1 24 0v8" stroke="#fff" stroke-width="6" fill="none"/>
          <circle cx="100" cy="110" r="5" fill="#1d4ed8"/><rect x="97" y="112" width="6" height="10" rx="3" fill="#1d4ed8"/>
          <defs><linearGradient id="g" x1="36" y1="14" x2="164" y2="182" gradientUnits="userSpaceOnUse"><stop stop-color="#3b82f6"/><stop offset="1" stop-color="#1e40af"/></linearGradient></defs>
        </svg>
      </div>
      <div class="auth-features">
        <div class="auth-feature"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg><h5>Secure Banking</h5><p>256-bit SSL Encryption</p></div>
        <div class="auth-feature"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2 4 14h7l-1 8 9-12h-7l1-8Z"/></svg><h5>Instant Transfers</h5><p>Send money in seconds</p></div>
        <div class="auth-feature"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/></svg><h5>24/7 Support</h5><p>We're here to help you</p></div>
      </div>
    </div>

    <div class="auth-right">
      <h1>Log In</h1>
      <p class="sub">Enter your credentials to continue</p>

      <c:if test="${not empty error}">
        <div class="alert-banner alert-error"><c:out value="${error}"/></div>
      </c:if>
      <c:if test="${param.msg == 'logout'}">
        <div class="alert-banner alert-ok">You have been signed out.</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
        <div class="field">
          <label for="username">Username / Email</label>
          <div class="input-group">
            <span class="lead-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/></svg></span>
            <input class="input" type="text" id="username" name="username" value="<c:out value='${email}'/>" placeholder="Enter your username or email" autocomplete="username" required>
          </div>
        </div>
        <div class="field">
          <label for="password">Password</label>
          <div class="input-group">
            <span class="lead-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg></span>
            <input class="input" type="password" id="password" name="password" placeholder="Enter your password" autocomplete="current-password" required>
            <button type="button" class="trail-btn" data-toggle-password aria-label="Show password"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg></button>
          </div>
        </div>
        <div class="form-row">
          <label class="check"><input type="checkbox" name="remember"> Remember Me</label>
          <a class="link" href="${pageContext.request.contextPath}/forgot-password">Forgot Password?</a>
        </div>
        <button type="submit" class="btn btn-navy btn-lg btn-block">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg>
          Log In
        </button>
      </form>

      <div class="or-sep">or</div>
      <a class="btn btn-ghost btn-lg btn-block" href="${pageContext.request.contextPath}/signup">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="8" r="4"/><path d="M3 20c0-3.5 3-5.5 6-5.5"/><path d="M17 8v6M20 11h-6"/></svg>
        Create New Account
      </a>
      <p class="auth-foot">Don't have an account? <a class="link" href="${pageContext.request.contextPath}/signup">Sign Up</a></p>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/acebank.js"></script>
</body>
</html>
