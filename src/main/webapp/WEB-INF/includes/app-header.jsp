<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Sample identity for the frontend preview; replaced by session data when auth is wired.
    if (request.getAttribute("pageTitle") == null) request.setAttribute("pageTitle", "Dashboard");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} — AceBank</title>
    <link rel="icon" type="image/svg+xml" href="<%= ctx %>/assets/img/favicon.svg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/acebank.css">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/app.css">
</head>
<body>
<div class="app" id="app">

  <!-- ============================= Sidebar ============================= -->
  <aside class="sidebar">
    <a class="side-brand brand" href="<%= ctx %>/dashboard" aria-label="AceBank">
      <span class="brand-mark">
        <svg viewBox="0 0 44 44" fill="none" aria-hidden="true"><path d="M22 3 41 38H3L22 3Z" fill="#2563eb"/><path d="M22 3 41 38H26L22 3Z" fill="#1e3a8a"/><path d="M22 16 30 31H14l8-15Z" fill="#fff"/></svg>
      </span>
      <span class="brand-name">AceBank</span>
    </a>

    <nav class="side-nav" aria-label="Main">
      <a class="nav-link ${activeNav=='dashboard' ? 'active' : ''}" href="<%= ctx %>/dashboard">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10 12 3l9 7"/><path d="M5 9v11h14V9"/><path d="M9 20v-6h6v6"/></svg><span>Dashboard</span>
      </a>
      <a class="nav-link ${activeNav=='accounts' ? 'active' : ''}" href="<%= ctx %>/accounts">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="3"/><path d="M3 10h18"/><path d="M7 15h4"/></svg><span>Accounts</span>
      </a>
      <a class="nav-link ${activeNav=='transfer' ? 'active' : ''}" href="<%= ctx %>/transfer">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 8h13l-3-3"/><path d="M20 16H7l3 3"/></svg><span>Transfer Money</span>
      </a>
      <a class="nav-link ${activeNav=='bills' ? 'active' : ''}" href="<%= ctx %>/bills">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2h12v20l-3-2-3 2-3-2-3 2V2Z"/><path d="M9 7h6M9 11h6M9 15h4"/></svg><span>Pay Bills</span>
      </a>
      <a class="nav-link ${activeNav=='cards' ? 'active' : ''}" href="<%= ctx %>/cards">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="3"/><path d="M2 10h20"/><path d="M6 15h4"/></svg><span>Cards</span>
      </a>
      <a class="nav-link ${activeNav=='transactions' ? 'active' : ''}" href="<%= ctx %>/transactions">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 7h12l-3-3"/><path d="M20 17H8l3 3"/><path d="M4 12h16"/></svg><span>Transactions</span>
      </a>
      <a class="nav-link ${activeNav=='loans' ? 'active' : ''}" href="<%= ctx %>/loans">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10 12 4l9 6"/><path d="M5 10v9h14v-9"/><path d="M9 19v-5h6v5"/></svg><span>Loans</span>
      </a>
      <a class="nav-link ${activeNav=='services' ? 'active' : ''}" href="<%= ctx %>/services">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="6" cy="6" r="2.4"/><circle cx="18" cy="6" r="2.4"/><circle cx="6" cy="18" r="2.4"/><circle cx="18" cy="18" r="2.4"/></svg><span>Services</span>
      </a>
      <a class="nav-link ${activeNav=='profile' ? 'active' : ''}" href="<%= ctx %>/profile">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/></svg><span>Profile</span>
      </a>
      <a class="nav-link ${activeNav=='settings' ? 'active' : ''}" href="<%= ctx %>/settings">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19 12a7 7 0 0 0-.1-1.2l2-1.6-2-3.4-2.4 1a7 7 0 0 0-2-1.2L14 2h-4l-.5 2.6a7 7 0 0 0-2 1.2l-2.4-1-2 3.4 2 1.6A7 7 0 0 0 5 12c0 .4 0 .8.1 1.2l-2 1.6 2 3.4 2.4-1a7 7 0 0 0 2 1.2L10 22h4l.5-2.6a7 7 0 0 0 2-1.2l2.4 1 2-3.4-2-1.6c.1-.4.1-.8.1-1.2Z"/></svg><span>Settings</span>
      </a>
      <a class="nav-link ${activeNav=='help' ? 'active' : ''}" href="<%= ctx %>/help">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/><path d="M20 19a3 3 0 0 1-3 3h-3"/></svg><span>Help &amp; Support</span>
      </a>
      <a class="nav-link" href="<%= ctx %>/logout">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M15 4h3a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-3"/><path d="M10 17 5 12l5-5"/><path d="M5 12h11"/></svg><span>Logout</span>
      </a>
    </nav>

    <div class="side-promo">
      <span class="crown" aria-hidden="true">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M3 8l4 4 5-7 5 7 4-4-2 11H5L3 8Z"/></svg>
      </span>
      <h4>Upgrade to <span class="promo-gold">Premium Banking</span></h4>
      <p>Unlock exclusive benefits and higher limits.</p>
      <a class="btn btn-blue btn-block" href="#">Upgrade Now</a>
    </div>
  </aside>

  <!-- ============================= Main ============================= -->
  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <button class="hamburger" id="navToggle" aria-label="Toggle menu">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="M4 6h16M4 12h16M4 18h16"/></svg>
        </button>
        <span class="topbar-title">${pageTitle}</span>
      </div>
      <div class="topbar-right">
        <button class="icon-btn" aria-label="Notifications">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/></svg>
          <span class="badge">3</span>
        </button>
        <button class="icon-btn" aria-label="Messages">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/></svg>
        </button>
        <button class="profile-chip" aria-label="Account menu">
          <span class="avatar"><c:out value="${sessionScope.initials}" default="U"/></span>
          <span class="profile-meta">
            <span class="pm-name"><c:out value="${sessionScope.userName}" default="Customer"/></span>
            <span class="pm-role">${sessionScope.role == 'ADMIN' ? 'Administrator' : 'Premium Customer'}</span>
          </span>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg>
        </button>
      </div>
    </header>

    <main class="content">
