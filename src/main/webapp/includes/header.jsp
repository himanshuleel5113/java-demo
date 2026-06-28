<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.acebank.lite.service.NotificationService" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");

    int unreadCount = 0;
    if(accountNumber != null) {
        unreadCount = NotificationService.getUnreadCount(accountNumber);
    }

    String currentPage = request.getRequestURI();
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AceBank - Premium Internet Banking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: '#0f2b4b',
                        secondary: '#eab308',
                        accent: '#3b82f6',
                    },
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                        brand: ['Outfit', 'sans-serif'],
                    }
                }
            }
        }
    </script>
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- AlpineJS -->
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <!-- AceBank Global CSS -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/acebank.css">
</head>
<body x-data="{
    darkMode: localStorage.getItem('darkMode') === 'true',
    notifications: [],
    showNotifications: false,
    unreadCount: <%= unreadCount %>,
    showProfileMenu: false,
    showMobileMenu: false,
    toggleDark() {
        this.darkMode = !this.darkMode;
        if(this.darkMode) {
            document.documentElement.classList.add('dark');
            localStorage.setItem('darkMode', 'true');
        } else {
            document.documentElement.classList.remove('dark');
            localStorage.setItem('darkMode', 'false');
        }
    }
}" x-init="
    if (darkMode) document.documentElement.classList.add('dark');
    if (<%= accountNumber != null %>) {
        loadNotifications();
        setInterval(loadNotifications, 30000);
    }
" class="antialiased text-gray-900 dark:text-gray-100 bg-slate-50 dark:bg-slate-900 transition-colors duration-300 min-h-screen flex flex-col">

    <!-- Header Navigation -->
    <header class="sticky top-0 z-50 glass-panel border-b border-white/20 dark:border-gray-800/50 bg-white/70 dark:bg-slate-900/70 backdrop-blur-md">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-20 items-center">
                <!-- Logo -->
                <a href="<%= contextPath %>/index.jsp" class="flex items-center gap-2 group">
                    <div class="h-10 w-10 rounded-xl bg-gradient-to-br from-primary to-blue-800 flex items-center justify-center text-white shadow-lg group-hover:scale-105 transition-transform duration-300">
                        <i class="fas fa-university text-xl"></i>
                    </div>
                    <div class="font-brand text-2xl font-bold tracking-tight text-primary dark:text-white">
                        Ace<span class="text-secondary">Bank</span>
                    </div>
                </a>

                <% if(accountNumber != null) { %>
                <!-- Desktop Navigation -->
                <nav class="hidden md:flex space-x-1 lg:space-x-2">
                    <a href="<%= contextPath %>/home" class="px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 flex items-center gap-2 <%= currentPage.contains("home") ? "bg-primary/10 text-primary dark:bg-blue-500/20 dark:text-blue-400" : "text-slate-600 hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800" %>">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                    <a href="<%= contextPath %>/Statement.jsp" class="px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 flex items-center gap-2 <%= currentPage.contains("Statement") ? "bg-primary/10 text-primary dark:bg-blue-500/20 dark:text-blue-400" : "text-slate-600 hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800" %>">
                        <i class="fas fa-file-invoice-dollar"></i> Statements
                    </a>
                    <a href="<%= contextPath %>/Transfer.jsp" class="px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 flex items-center gap-2 <%= currentPage.contains("Transfer") ? "bg-primary/10 text-primary dark:bg-blue-500/20 dark:text-blue-400" : "text-slate-600 hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800" %>">
                        <i class="fas fa-exchange-alt"></i> Transfer
                    </a>
                    <a href="<%= contextPath %>/Loan.jsp" class="px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 flex items-center gap-2 <%= currentPage.contains("Loan") ? "bg-primary/10 text-primary dark:bg-blue-500/20 dark:text-blue-400" : "text-slate-600 hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800" %>">
                        <i class="fas fa-hand-holding-usd"></i> Loans
                    </a>
                    <% if("ADMIN".equals(role)) { %>
                    <a href="<%= contextPath %>/admin/admin-dashboard.jsp" class="px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 flex items-center gap-2 text-purple-600 hover:bg-purple-50 dark:text-purple-400 dark:hover:bg-purple-900/20">
                        <i class="fas fa-shield-alt"></i> Admin
                    </a>
                    <% } %>
                </nav>
                <% } %>

                <!-- Right Controls -->
                <div class="flex items-center gap-2 sm:gap-4">
                    <!-- Dark Mode Toggle -->
                    <button @click="toggleDark()" class="h-10 w-10 rounded-full flex items-center justify-center text-slate-500 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800 transition-colors focus:outline-none">
                        <i class="fas" :class="darkMode ? 'fa-sun text-yellow-400' : 'fa-moon'"></i>
                    </button>

                    <% if(accountNumber != null) { %>
                    <!-- Notifications -->
                    <div class="relative">
                        <button @click="showNotifications = !showNotifications; if(showNotifications) loadNotifications()" class="h-10 w-10 rounded-full flex items-center justify-center text-slate-500 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800 transition-colors relative focus:outline-none">
                            <i class="fas fa-bell"></i>
                            <span x-show="unreadCount > 0" x-text="unreadCount" class="absolute top-1 right-1 h-4 w-4 bg-red-500 text-white text-[10px] font-bold flex items-center justify-center rounded-full border-2 border-white dark:border-slate-900 animate-pulse-slow" style="display: none;"></span>
                        </button>

                        <!-- Notification Dropdown -->
                        <div x-show="showNotifications" @click.away="showNotifications = false" x-transition class="absolute right-0 mt-2 w-80 sm:w-96 glass-panel rounded-2xl shadow-xl overflow-hidden z-50 border border-slate-200 dark:border-slate-700 bg-white/95 dark:bg-slate-800/95" style="display: none;">
                            <div class="p-4 border-b border-slate-100 dark:border-slate-700 flex justify-between items-center bg-slate-50/50 dark:bg-slate-800/50">
                                <h3 class="font-semibold text-slate-800 dark:text-white">Notifications</h3>
                                <button @click="markAllAsRead()" class="text-xs text-blue-600 dark:text-blue-400 hover:underline font-medium focus:outline-none">Mark all read</button>
                            </div>
                            <div class="max-h-80 overflow-y-auto">
                                <template x-for="notification in notifications" :key="notification.id">
                                    <div class="p-4 border-b border-slate-50 dark:border-slate-700/50 hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors cursor-pointer flex gap-4 items-start" @click="markAsRead(notification.id); window.location.href=notification.actionLink">
                                        <div class="h-10 w-10 rounded-full bg-slate-100 dark:bg-slate-700 flex items-center justify-center flex-shrink-0">
                                            <i :class="'fas ' + notification.icon"></i>
                                        </div>
                                        <div class="flex-1">
                                            <p class="text-sm text-slate-700 dark:text-slate-200 leading-snug" x-text="notification.message"></p>
                                            <p class="text-xs text-slate-400 dark:text-slate-500 mt-1" x-text="notification.formattedTime || 'Just now'"></p>
                                        </div>
                                        <div x-show="!notification.read" class="w-2 h-2 rounded-full bg-blue-500 mt-2 flex-shrink-0"></div>
                                    </div>
                                </template>
                                <div x-show="notifications.length === 0" class="p-8 text-center text-slate-500 dark:text-slate-400">
                                    <div class="h-16 w-16 bg-slate-100 dark:bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-3">
                                        <i class="fas fa-bell-slash text-2xl"></i>
                                    </div>
                                    <p class="text-sm">You're all caught up!</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Menu -->
                    <div class="relative">
                        <button @click="showProfileMenu = !showProfileMenu" class="flex items-center gap-2 p-1.5 pl-2 pr-3 rounded-full hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors border border-transparent hover:border-slate-200 dark:hover:border-slate-700 focus:outline-none">
                            <div class="h-8 w-8 rounded-full bg-gradient-to-r from-secondary to-orange-400 flex items-center justify-center text-white font-bold shadow-sm">
                                <%= firstName != null && !firstName.isEmpty() ? firstName.substring(0,1).toUpperCase() : "U" %>
                            </div>
                            <span class="hidden sm:block text-sm font-medium text-slate-700 dark:text-slate-200"><%= firstName %></span>
                            <i class="fas fa-chevron-down text-[10px] text-slate-400 transition-transform duration-200" :class="showProfileMenu ? 'rotate-180' : ''"></i>
                        </button>

                        <!-- Profile Dropdown -->
                        <div x-show="showProfileMenu" @click.away="showProfileMenu = false" x-transition class="absolute right-0 mt-2 w-64 glass-panel rounded-2xl shadow-xl overflow-hidden z-50 border border-slate-200 dark:border-slate-700 bg-white/95 dark:bg-slate-800/95" style="display: none;">
                            <div class="p-4 border-b border-slate-100 dark:border-slate-700 bg-slate-50/50 dark:bg-slate-800/50">
                                <p class="font-semibold text-slate-800 dark:text-white truncate"><%= firstName %> <%= lastName %></p>
                                <p class="text-xs text-slate-500 dark:text-slate-400 truncate"><%= email %></p>
                                <p class="text-[10px] uppercase font-bold tracking-wider text-slate-400 mt-2">A/C: <%= accountNumber %></p>
                            </div>

                            <div class="p-2">
                                <a href="<%= contextPath %>/ChangePassword.jsp" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-700/50 transition-colors">
                                    <i class="fas fa-shield-alt text-slate-400 w-5"></i> Security Settings
                                </a>
                                <div class="h-px bg-slate-100 dark:bg-slate-700 my-2 mx-3"></div>
                                <a href="<%= contextPath %>/Logout" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">
                                    <i class="fas fa-sign-out-alt w-5"></i> Sign Out
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Mobile Menu Button -->
                    <button @click="showMobileMenu = !showMobileMenu" class="md:hidden h-10 w-10 rounded-xl flex items-center justify-center text-slate-500 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800 transition-colors focus:outline-none">
                        <i class="fas fa-bars text-lg"></i>
                    </button>
                    <% } else { %>
                        <div class="flex items-center gap-3">
                            <a href="<%= contextPath %>/Login.jsp" class="hidden sm:flex text-sm font-medium text-slate-600 hover:text-primary dark:text-slate-300 dark:hover:text-white transition-colors">Sign In</a>
                            <a href="<%= contextPath %>/SignUp.jsp" class="btn-primary py-2 px-5 text-sm">Open Account</a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

        <% if(accountNumber != null) { %>
        <!-- Mobile Navigation Menu -->
        <div x-show="showMobileMenu" x-collapse class="md:hidden bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800" style="display: none;">
            <div class="px-4 py-3 space-y-1">
                <a href="<%= contextPath %>/home" class="block px-3 py-2.5 rounded-xl text-base font-medium <%= currentPage.contains("home") ? "bg-primary/10 text-primary dark:bg-blue-500/20 dark:text-blue-400" : "text-slate-600 hover:bg-slate-50 dark:text-slate-300 dark:hover:bg-slate-800" %>">
                    <i class="fas fa-home w-6 text-center mr-2"></i> Dashboard
                </a>
                <a href="<%= contextPath %>/Statement.jsp" class="block px-3 py-2.5 rounded-xl text-base font-medium <%= currentPage.contains("Statement") ? "bg-primary/10 text-primary dark:bg-blue-500/20 dark:text-blue-400" : "text-slate-600 hover:bg-slate-50 dark:text-slate-300 dark:hover:bg-slate-800" %>">
                    <i class="fas fa-file-invoice-dollar w-6 text-center mr-2"></i> Statements
                </a>
                <a href="<%= contextPath %>/Transfer.jsp" class="block px-3 py-2.5 rounded-xl text-base font-medium <%= currentPage.contains("Transfer") ? "bg-primary/10 text-primary dark:bg-blue-500/20 dark:text-blue-400" : "text-slate-600 hover:bg-slate-50 dark:text-slate-300 dark:hover:bg-slate-800" %>">
                    <i class="fas fa-exchange-alt w-6 text-center mr-2"></i> Transfer
                </a>
                <a href="<%= contextPath %>/Loan.jsp" class="block px-3 py-2.5 rounded-xl text-base font-medium <%= currentPage.contains("Loan") ? "bg-primary/10 text-primary dark:bg-blue-500/20 dark:text-blue-400" : "text-slate-600 hover:bg-slate-50 dark:text-slate-300 dark:hover:bg-slate-800" %>">
                    <i class="fas fa-hand-holding-usd w-6 text-center mr-2"></i> Loans
                </a>
            </div>
        </div>
        <% } %>
    </header>

    <!-- Main Content Container -->
    <main class="flex-grow w-full">