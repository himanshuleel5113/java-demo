<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%
    String savedAccount = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("rememberedAccount".equals(c.getName())) {
                savedAccount = c.getValue();
            }
        }
    }
%>
<jsp:include page="includes/header.jsp" />

<div class="relative min-h-[85vh] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <!-- Animated background elements -->
    <div class="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div class="absolute top-0 right-1/4 w-96 h-96 bg-blue-400/20 rounded-full blur-3xl animate-pulse-slow"></div>
        <div class="absolute bottom-0 left-1/4 w-96 h-96 bg-indigo-500/10 rounded-full blur-3xl animate-float"></div>
    </div>

    <div class="relative z-10 w-full max-w-md page-enter">
        
        <!-- Header Text -->
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-br from-primary to-blue-800 text-white shadow-xl mb-4 transform hover:rotate-12 transition-transform duration-300">
                <i class="fas fa-lock text-2xl"></i>
            </div>
            <h2 class="text-3xl md:text-4xl font-brand font-bold text-gray-900 dark:text-white mb-2">Welcome Back</h2>
            <p class="text-gray-500 dark:text-gray-400">Securely access your AceBank account</p>
        </div>

        <!-- Messages -->
        <% if(request.getParameter("error") != null) { %>
            <div class="mb-6 p-4 rounded-xl bg-red-50/80 dark:bg-red-900/20 border border-red-200 dark:border-red-800/30 flex items-start gap-3 animate-float" style="animation-duration: 4s;">
                <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
                <p class="text-sm font-medium text-red-700 dark:text-red-400"><%= request.getParameter("error").replace("+", " ") %></p>
            </div>
        <% } %>
        <% if(request.getParameter("msg") != null) { %>
            <div class="mb-6 p-4 rounded-xl bg-green-50/80 dark:bg-green-900/20 border border-green-200 dark:border-green-800/30 flex items-start gap-3">
                <i class="fas fa-check-circle text-green-500 mt-0.5"></i>
                <p class="text-sm font-medium text-green-700 dark:text-green-400"><%= request.getParameter("msg").replace("+", " ") %></p>
            </div>
        <% } %>

        <!-- Login Card -->
        <div class="glass-panel rounded-3xl p-8 shadow-2xl relative overflow-hidden">
            <!-- decorative line -->
            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-blue-400 to-indigo-600"></div>

            <form action="Login" method="POST" class="space-y-6" id="loginForm">
                <div>
                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Account Number
                    </label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                            <i class="fas fa-hashtag"></i>
                        </div>
                        <input type="text" name="accountNumber" value="<%= savedAccount %>" required
                               class="input-field pl-11"
                               placeholder="Enter your 8-digit account number"
                               pattern="[0-9]{8,}" title="Please enter valid account number">
                    </div>
                </div>

                <div>
                    <div class="flex items-center justify-between mb-2">
                        <label class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                            Password
                        </label>
                        <a href="ForgotPassword.jsp" class="text-xs font-semibold text-blue-600 dark:text-blue-400 hover:underline">
                            Forgot Password?
                        </a>
                    </div>
                    <div class="relative" x-data="{ show: false }">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                            <i class="fas fa-key"></i>
                        </div>
                        <input :type="show ? 'text' : 'password'" name="password" required
                               class="input-field pl-11 pr-11"
                               placeholder="••••••••">
                        <button type="button" @click="show = !show" class="absolute inset-y-0 right-0 pr-4 flex items-center text-slate-400 hover:text-slate-600 focus:outline-none">
                            <i class="fas" :class="show ? 'fa-eye-slash' : 'fa-eye'"></i>
                        </button>
                    </div>
                </div>

                <div class="flex items-center">
                    <label class="flex items-center cursor-pointer group">
                        <div class="relative flex items-center justify-center w-5 h-5 mr-3">
                            <input type="checkbox" name="rememberMe" class="peer appearance-none w-5 h-5 rounded border border-slate-300 dark:border-slate-600 checked:bg-blue-600 checked:border-blue-600 transition-colors cursor-pointer"
                                   <%= !savedAccount.isEmpty() ? "checked" : "" %>>
                            <i class="fas fa-check absolute text-white text-xs opacity-0 peer-checked:opacity-100 pointer-events-none transition-opacity"></i>
                        </div>
                        <span class="text-sm font-medium text-slate-600 dark:text-slate-400 group-hover:text-slate-900 dark:group-hover:text-slate-200 transition-colors">Remember me</span>
                    </label>
                </div>

                <button type="submit" class="btn-primary w-full flex items-center justify-center gap-2 py-3.5 text-lg">
                    Sign In <i class="fas fa-arrow-right text-sm"></i>
                </button>
            </form>
            
            <div class="mt-8 pt-6 border-t border-slate-200 dark:border-slate-700/50 text-center">
                <p class="text-sm text-slate-600 dark:text-slate-400">
                    New to AceBank?
                    <a href="SignUp.jsp" class="font-semibold text-blue-600 dark:text-blue-400 hover:underline inline-flex items-center gap-1">
                        Open an Account <i class="fas fa-chevron-right text-[10px]"></i>
                    </a>
                </p>
            </div>
        </div>

        <div class="mt-8 text-center text-xs text-slate-500 flex items-center justify-center gap-2">
            <i class="fas fa-shield-check text-green-500"></i>
            Secured by 256-bit banking-grade encryption
        </div>
    </div>
</div>

<script>
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const account = document.querySelector('input[name="accountNumber"]').value;
        const password = document.querySelector('input[name="password"]').value;

        if(!account || !password) {
            e.preventDefault();
            if(window.AceBank) AceBank.showToast('Please enter both account number and password', 'error');
            else alert('Please enter both account number and password');
        }
    });
</script>

<jsp:include page="includes/footer.jsp" />