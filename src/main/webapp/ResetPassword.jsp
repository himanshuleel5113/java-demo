<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String email = (String) session.getAttribute("resetEmail");
    Boolean verified = (Boolean) session.getAttribute("otpVerified");

    if (email == null) {
        response.sendRedirect("ForgotPassword.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="relative min-h-[85vh] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div class="absolute top-0 right-1/4 w-96 h-96 bg-emerald-400/10 rounded-full blur-3xl animate-pulse-slow"></div>
    </div>

    <div class="relative z-10 w-full max-w-md page-enter">
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-br from-emerald-100 to-teal-100 dark:from-emerald-900/40 dark:to-teal-900/40 text-emerald-600 dark:text-emerald-400 shadow-inner mb-4">
                <i class="fas fa-shield-check text-2xl"></i>
            </div>
            <h2 class="text-3xl font-brand font-bold text-gray-900 dark:text-white mb-2">Create New Password</h2>
            <p class="text-emerald-600 dark:text-emerald-400 font-medium">OTP verified successfully!</p>
        </div>

        <% if(request.getParameter("error") != null) { %>
            <div class="mb-6 p-4 rounded-xl bg-red-50/80 dark:bg-red-900/20 border border-red-200 dark:border-red-800/30 flex items-start gap-3">
                <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
                <p class="text-sm font-medium text-red-700 dark:text-red-400"><%= request.getParameter("error").replace("+", " ") %></p>
            </div>
        <% } %>

        <div class="glass-panel rounded-3xl p-8 shadow-2xl relative overflow-hidden">
            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-400 to-teal-600"></div>

            <form action="ResetPassword" method="POST" class="space-y-6" onsubmit="return validateForm()">
                <div x-data="{ show: false }">
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">New Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                            <i class="fas fa-lock"></i>
                        </div>
                        <input :type="show ? 'text' : 'password'" name="newPassword" id="newPassword" required
                               class="input-field pl-11 pr-11"
                               placeholder="Create a strong password">
                        <button type="button" @click="show = !show" class="absolute inset-y-0 right-0 pr-4 flex items-center text-slate-400 hover:text-slate-600 focus:outline-none">
                            <i class="fas" :class="show ? 'fa-eye-slash' : 'fa-eye'"></i>
                        </button>
                    </div>
                </div>

                <div x-data="{ show: false }">
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Confirm Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                            <i class="fas fa-check-double"></i>
                        </div>
                        <input :type="show ? 'text' : 'password'" name="confirmPassword" id="confirmPassword" required
                               class="input-field pl-11 pr-11"
                               placeholder="Confirm your new password">
                        <button type="button" @click="show = !show" class="absolute inset-y-0 right-0 pr-4 flex items-center text-slate-400 hover:text-slate-600 focus:outline-none">
                            <i class="fas" :class="show ? 'fa-eye-slash' : 'fa-eye'"></i>
                        </button>
                    </div>
                </div>

                <div class="bg-slate-50 dark:bg-slate-800/50 p-4 rounded-xl border border-slate-100 dark:border-slate-700/50 space-y-3">
                    <p class="text-sm font-semibold text-slate-700 dark:text-slate-300">Password Requirements:</p>
                    <div class="space-y-2">
                        <div class="flex items-center text-xs text-slate-500 dark:text-slate-400" id="req-length">
                            <i class="fas fa-circle mr-2 text-[6px]"></i><span>At least 8 characters</span>
                        </div>
                        <div class="flex items-center text-xs text-slate-500 dark:text-slate-400" id="req-uppercase">
                            <i class="fas fa-circle mr-2 text-[6px]"></i><span>At least one uppercase letter</span>
                        </div>
                        <div class="flex items-center text-xs text-slate-500 dark:text-slate-400" id="req-lowercase">
                            <i class="fas fa-circle mr-2 text-[6px]"></i><span>At least one lowercase letter</span>
                        </div>
                        <div class="flex items-center text-xs text-slate-500 dark:text-slate-400" id="req-number">
                            <i class="fas fa-circle mr-2 text-[6px]"></i><span>At least one number</span>
                        </div>
                    </div>
                </div>

                <button type="submit" class="w-full py-3.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl font-semibold text-lg transition-colors flex items-center justify-center gap-2 shadow-lg shadow-emerald-600/30">
                    Update Password <i class="fas fa-save text-sm"></i>
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    document.getElementById('newPassword').addEventListener('input', function() {
        const password = this.value;

        const setReq = (id, isValid, text) => {
            const el = document.getElementById(id);
            if (isValid) {
                el.innerHTML = '<i class="fas fa-check-circle text-emerald-500 mr-2 text-xs"></i><span class="text-emerald-600 dark:text-emerald-400 font-medium">' + text + '</span>';
            } else {
                el.innerHTML = '<i class="fas fa-circle mr-2 text-[6px] text-slate-300 dark:text-slate-600"></i><span>' + text + '</span>';
            }
        };

        setReq('req-length', password.length >= 8, 'At least 8 characters');
        setReq('req-uppercase', /[A-Z]/.test(password), 'At least one uppercase letter');
        setReq('req-lowercase', /[a-z]/.test(password), 'At least one lowercase letter');
        setReq('req-number', /[0-9]/.test(password), 'At least one number');
    });

    function validateForm() {
        const newPass = document.getElementById('newPassword').value;
        const confirmPass = document.getElementById('confirmPassword').value;

        if(newPass !== confirmPass) {
            if(window.AceBank) AceBank.showToast('Passwords do not match!', 'error');
            else alert('Passwords do not match!');
            return false;
        }

        if(newPass.length < 8 || !/[A-Z]/.test(newPass) || !/[a-z]/.test(newPass) || !/[0-9]/.test(newPass)) {
            if(window.AceBank) AceBank.showToast('Password does not meet the requirements!', 'error');
            else alert('Password does not meet the requirements!');
            return false;
        }

        return true;
    }
</script>

<jsp:include page="/includes/footer.jsp" />