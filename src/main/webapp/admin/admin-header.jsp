<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer _adminAcc = (Integer) session.getAttribute("accountNumber");
    String _adminRole = (String) session.getAttribute("role");
    if (_adminAcc == null || !"ADMIN".equals(_adminRole)) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    String active = (String) request.getAttribute("active");
    if (active == null) active = "";
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Dashboard";
    String adminName = (String) session.getAttribute("firstName");
    if (adminName == null) adminName = "Admin";
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> &middot; AceBank Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: { extend: {
                colors: { primary: '#0f2b4b', secondary: '#eab308', accent: '#3b82f6' },
                fontFamily: { sans: ['Inter','sans-serif'], brand: ['Outfit','sans-serif'] }
            }}
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/acebank.css">
</head>
<body x-data="{ darkMode: localStorage.getItem('darkMode') === 'true', sidebar: true,
        toggleDark(){ this.darkMode=!this.darkMode; document.documentElement.classList.toggle('dark', this.darkMode); localStorage.setItem('darkMode', this.darkMode); } }"
      x-init="if(darkMode) document.documentElement.classList.add('dark')"
      class="h-full antialiased font-sans bg-slate-100 dark:bg-slate-950 text-slate-900 dark:text-slate-100">

<div class="flex h-screen overflow-hidden">
    <!-- Sidebar -->
    <aside class="w-64 shrink-0 hidden lg:flex flex-col bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800">
        <div class="h-20 flex items-center gap-3 px-6 border-b border-slate-200 dark:border-slate-800">
            <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-primary to-blue-800 flex items-center justify-center text-white shadow-lg">
                <i class="fas fa-university"></i>
            </div>
            <span class="text-xl font-brand font-bold tracking-tight">
                <span class="text-slate-900 dark:text-white">Ace</span><span class="text-secondary">Admin</span>
            </span>
        </div>
        <nav class="flex-1 overflow-y-auto py-5 px-3 space-y-1">
            <p class="px-3 pb-2 text-[10px] font-bold uppercase tracking-widest text-slate-400">Management</p>
            <a href="<%= ctx %>/admin/admin-dashboard.jsp" class="<%= "overview".equals(active) ? "nav-active" : "nav-item" %>"><i class="fas fa-chart-pie w-5 text-center"></i> Overview</a>
            <a href="<%= ctx %>/admin/admin-customers.jsp" class="<%= "customers".equals(active) ? "nav-active" : "nav-item" %>"><i class="fas fa-users w-5 text-center"></i> Customers</a>
            <a href="<%= ctx %>/admin/admin-transactions.jsp" class="<%= "transactions".equals(active) ? "nav-active" : "nav-item" %>"><i class="fas fa-exchange-alt w-5 text-center"></i> Transactions</a>
            <a href="<%= ctx %>/admin/admin-loans.jsp" class="<%= "loans".equals(active) ? "nav-active" : "nav-item" %>"><i class="fas fa-hand-holding-usd w-5 text-center"></i> Loan Approvals</a>
            <div class="pt-4 mt-4 border-t border-slate-200 dark:border-slate-800">
                <a href="<%= ctx %>/home" class="nav-item"><i class="fas fa-arrow-left w-5 text-center"></i> Back to Banking</a>
                <a href="<%= ctx %>/Logout" class="nav-item text-red-600 dark:text-red-400 hover:!bg-red-50 dark:hover:!bg-red-900/20"><i class="fas fa-sign-out-alt w-5 text-center"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <!-- Main column -->
    <div class="flex-1 flex flex-col overflow-hidden">
        <header class="h-20 shrink-0 bg-white/80 dark:bg-slate-900/80 backdrop-blur border-b border-slate-200 dark:border-slate-800 flex items-center justify-between px-5 sm:px-8">
            <div>
                <p class="text-[11px] font-semibold uppercase tracking-widest text-slate-400">Admin Console</p>
                <h1 class="text-xl font-brand font-bold text-slate-900 dark:text-white leading-tight"><%= pageTitle %></h1>
            </div>
            <div class="flex items-center gap-3">
                <button @click="toggleDark()" class="h-10 w-10 rounded-full flex items-center justify-center text-slate-500 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800 transition-colors">
                    <i class="fas" :class="darkMode ? 'fa-sun text-yellow-400' : 'fa-moon'"></i>
                </button>
                <div class="flex items-center gap-2 pl-3 border-l border-slate-200 dark:border-slate-700">
                    <div class="w-9 h-9 rounded-full bg-gradient-to-br from-rose-500 to-orange-500 flex items-center justify-center text-white text-sm font-bold shadow"><%= adminName.substring(0,1).toUpperCase() %></div>
                    <div class="hidden sm:block leading-tight">
                        <p class="text-sm font-semibold text-slate-800 dark:text-slate-100"><%= adminName %></p>
                        <p class="text-[11px] text-slate-400">Administrator</p>
                    </div>
                </div>
            </div>
        </header>
        <div class="flex-1 overflow-y-auto p-5 sm:p-8 page-enter">
