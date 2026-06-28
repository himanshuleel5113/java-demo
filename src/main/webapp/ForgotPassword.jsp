<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="/includes/header.jsp" />

<div class="relative min-h-[85vh] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <!-- Animated background elements -->
    <div class="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div class="absolute top-0 left-1/4 w-96 h-96 bg-blue-400/10 rounded-full blur-3xl animate-pulse-slow"></div>
        <div class="absolute bottom-0 right-1/4 w-96 h-96 bg-indigo-500/10 rounded-full blur-3xl animate-float"></div>
    </div>

    <div class="relative z-10 w-full max-w-md page-enter">
        
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-br from-blue-100 to-indigo-100 dark:from-blue-900/40 dark:to-indigo-900/40 text-blue-600 dark:text-blue-400 shadow-inner mb-4">
                <i class="fas fa-key text-2xl"></i>
            </div>
            <h2 class="text-3xl font-brand font-bold text-gray-900 dark:text-white mb-2">Forgot Password?</h2>
            <p class="text-gray-500 dark:text-gray-400">Enter your email to receive an OTP</p>
        </div>

        <!-- Messages -->
        <% if(request.getParameter("error") != null) { %>
            <div class="mb-6 p-4 rounded-xl bg-red-50/80 dark:bg-red-900/20 border border-red-200 dark:border-red-800/30 flex items-start gap-3">
                <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
                <p class="text-sm font-medium text-red-700 dark:text-red-400"><%= request.getParameter("error").replace("+", " ") %></p>
            </div>
        <% } %>

        <div class="glass-panel rounded-3xl p-8 shadow-2xl relative overflow-hidden">
            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-blue-400 to-indigo-600"></div>

            <form action="Forgot" method="POST" class="space-y-6" onsubmit="return validateForm()">
                <div>
                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Email Address
                    </label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <input type="email" name="email" id="email" required
                               class="input-field pl-11"
                               placeholder="john.doe@example.com">
                    </div>
                </div>

                <div class="bg-blue-50 dark:bg-blue-900/20 p-4 rounded-xl border border-blue-100 dark:border-blue-800/30">
                    <p class="text-sm text-blue-800 dark:text-blue-300 flex items-start gap-3">
                        <i class="fas fa-info-circle mt-0.5"></i>
                        We'll send a 6-digit OTP to your registered email for verification.
                    </p>
                </div>

                <button type="submit" class="btn-primary w-full flex items-center justify-center gap-2 py-3.5 text-lg">
                    Send OTP <i class="fas fa-paper-plane text-sm"></i>
                </button>
            </form>
            
            <div class="mt-8 pt-6 border-t border-slate-200 dark:border-slate-700/50 text-center flex flex-col gap-3">
                <a href="Login.jsp" class="text-sm font-semibold text-slate-600 dark:text-slate-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors inline-flex items-center justify-center gap-2">
                    <i class="fas fa-arrow-left"></i> Back to Login
                </a>
                <p class="text-sm text-slate-600 dark:text-slate-400">
                    Don't have an account?
                    <a href="SignUp.jsp" class="font-semibold text-blue-600 dark:text-blue-400 hover:underline">Sign Up</a>
                </p>
            </div>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        const email = document.getElementById('email').value;
        if(!email || !email.includes('@') || !email.includes('.')) {
            if(window.AceBank) AceBank.showToast('Please enter a valid email address', 'error');
            else alert('Please enter a valid email address');
            return false;
        }
        return true;
    }
</script>

<jsp:include page="/includes/footer.jsp" />