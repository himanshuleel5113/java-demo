<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% String ctx = request.getContextPath();
   if (request.getAttribute("pageTitle") == null) request.setAttribute("pageTitle", "Dashboard"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin · ${pageTitle} — AceBank</title>
    <link rel="icon" type="image/svg+xml" href="<%= ctx %>/assets/img/favicon.svg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/acebank.css">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/app.css">
</head>
<body>
<div class="app" id="app">
  <aside class="sidebar">
    <a class="side-brand brand" href="<%= ctx %>/admin/dashboard" aria-label="AceBank Admin">
      <span class="brand-mark"><svg viewBox="0 0 44 44" fill="none" aria-hidden="true"><path d="M22 3 41 38H3L22 3Z" fill="#2563eb"/><path d="M22 3 41 38H26L22 3Z" fill="#1e3a8a"/><path d="M22 16 30 31H14l8-15Z" fill="#fff"/></svg></span>
      <span class="brand-name">AceBank</span>
    </a>
    <div class="side-panel-tag"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg> Admin Panel</div>

    <nav class="side-nav" aria-label="Admin">
      <a class="nav-link ${activeNav=='dashboard' ? 'active' : ''}" href="<%= ctx %>/admin/dashboard"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10 12 3l9 7"/><path d="M5 9v11h14V9"/></svg><span>Dashboard</span></a>
      <a class="nav-link ${activeNav=='users' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="8" r="3.5"/><path d="M15 8a3.5 3.5 0 1 0 0-7M3 20c0-3.5 3-5.5 6-5.5s6 2 6 5.5M17 20c0-2.5-1.5-4-3-5"/></svg><span>Users</span></a>
      <a class="nav-link ${activeNav=='accounts' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="3"/><path d="M3 10h18"/></svg><span>Accounts</span></a>
      <a class="nav-link ${activeNav=='transactions' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 7h12l-3-3M20 17H8l3 3M4 12h16"/></svg><span>Transactions</span></a>
      <a class="nav-link ${activeNav=='loans' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10 12 4l9 6M5 10v9h14v-9"/></svg><span>Loans</span></a>
      <a class="nav-link ${activeNav=='cards' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="3"/><path d="M2 10h20"/></svg><span>Cards</span></a>
      <a class="nav-link ${activeNav=='services' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="6" cy="6" r="2.4"/><circle cx="18" cy="6" r="2.4"/><circle cx="6" cy="18" r="2.4"/><circle cx="18" cy="18" r="2.4"/></svg><span>Services</span></a>
      <a class="nav-link ${activeNav=='reports' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19V5M4 19h16M8 16v-5M12 16V8M16 16v-3"/></svg><span>Reports</span></a>
      <a class="nav-link ${activeNav=='audit' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M7 3h10v18H7z"/><path d="M10 8h4M10 12h4M10 16h2"/></svg><span>Audit Logs</span></a>
      <a class="nav-link ${activeNav=='tickets' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/></svg><span>Support Tickets</span></a>
      <a class="nav-link ${activeNav=='sysset' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19 12a7 7 0 0 0-.1-1.2l2-1.6-2-3.4-2.4 1a7 7 0 0 0-2-1.2L14 2h-4l-.5 2.6a7 7 0 0 0-2 1.2l-2.4-1-2 3.4 2 1.6a7 7 0 0 0 0 2.4l-2 1.6 2 3.4 2.4-1a7 7 0 0 0 2 1.2L10 22h4l.5-2.6a7 7 0 0 0 2-1.2l2.4 1 2-3.4-2-1.6c.1-.4.1-.8.1-1.2Z"/></svg><span>System Settings</span></a>
      <a class="nav-link ${activeNav=='notifications' ? 'active' : ''}" href="#"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/></svg><span>Notifications</span></a>
    </nav>

    <div class="side-status">
      <div class="st-row"><span class="dot-live"></span> System Status</div>
      <div class="st-row" style="color:#22c55e;font-weight:600;margin-top:6px">All Systems Operational</div>
      <div class="st-meta">Last Updated<br>31 May 2025, 10:30 AM</div>
      <div class="st-meta" style="color:#60a5fa;margin-top:8px">View System Health</div>
      <svg class="st-spark" width="100%" height="34" viewBox="0 0 180 34" fill="none" preserveAspectRatio="none"><path d="M0 26 20 22 40 27 60 18 80 21 100 12 120 16 140 8 160 12 180 5" stroke="#3b82f6" stroke-width="2" fill="none"/></svg>
    </div>
  </aside>

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <button class="hamburger" id="navToggle" aria-label="Toggle menu"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 6h16M4 12h16M4 18h16"/></svg></button>
        <span class="topbar-title">${pageTitle}</span>
      </div>
      <div class="topbar-right">
        <button class="icon-btn" aria-label="Notifications"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/></svg><span class="badge">5</span></button>
        <button class="icon-btn" aria-label="Messages"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/></svg><span class="badge">3</span></button>
        <button class="profile-chip" aria-label="Admin menu">
          <span class="avatar" style="background:linear-gradient(135deg,#334155,#0f172a)">AU</span>
          <span class="profile-meta"><span class="pm-name">Admin User</span><span class="pm-role">Super Administrator</span></span>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg>
        </button>
      </div>
    </header>
    <main class="content">
