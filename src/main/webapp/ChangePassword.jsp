<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");

    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-2xl mx-auto px-4 py-8 page-enter">
    <div class="mb-8">
        <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Change Password</h1>
        <p class="text-slate-500 dark:text-slate-400 mt-1">Update your account password securely</p>
    </div>

    <div class="glass-panel rounded-3xl p-8 shadow-xl relative overflow-hidden">
        <!-- Background accents -->
        <div class="absolute top-0 right-0 w-64 h-64 bg-blue-500/10 rounded-full blur-3xl transform translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>
        
        <div class="relative z-10">
            <!-- Security Banner -->
            <div class="bg-blue-50 dark:bg-blue-900/20 p-5 rounded-2xl mb-8 border border-blue-100 dark:border-blue-800/30 flex items-start gap-4">
                <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-400 flex items-center justify-center flex-shrink-0">
                    <i class="fas fa-shield-alt text-lg"></i>
                </div>
                <div>
                    <p class="font-semibold text-blue-900 dark:text-blue-100 mb-1">Security Best Practices</p>
                    <ul class="text-sm text-blue-700 dark:text-blue-300 space-y-1">
                        <li class="flex items-center gap-2"><i class="fas fa-check text-[10px]"></i> Use a strong password with a mix of characters</li>
                        <li class="flex items-center gap-2"><i class="fas fa-check text-[10px]"></i> Never share your password with anyone</li>
                        <li class="flex items-center gap-2"><i class="fas fa-check text-[10px]"></i> Change your password regularly</li>
                    </ul>
                </div>
            </div>

            <% if(request.getParameter("error") != null) { %>
                <div class="mb-6 p-4 rounded-xl bg-red-50/80 dark:bg-red-900/20 border border-red-200 dark:border-red-800/30 flex items-start gap-3">
                    <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
                    <p class="text-sm font-medium text-red-700 dark:text-red-400"><%= request.getParameter("error").replace("+", " ") %></p>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/ChangePassword" method="POST" id="passwordForm" class="space-y-6">
                <div x-data="{ show: false }">
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Current Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                            <i class="fas fa-key"></i>
                        </div>
                        <input :type="show ? 'text' : 'password'" name="currentPassword" required
                               class="input-field pl-11 pr-11"
                               placeholder="Enter your current password">
                        <button type="button" @click="show = !show" class="absolute inset-y-0 right-0 pr-4 flex items-center text-slate-400 hover:text-slate-600 focus:outline-none">
                            <i class="fas" :class="show ? 'fa-eye-slash' : 'fa-eye'"></i>
                        </button>
                    </div>
                </div>

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
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Confirm New Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                            <i class="fas fa-check-double"></i>
                        </div>
                        <input :type="show ? 'text' : 'password'" name="confirmNewPassword" id="confirmPassword" required
                               class="input-field pl-11 pr-11"
                               placeholder="Confirm your new password">
                        <button type="button" @click="show = !show" class="absolute inset-y-0 right-0 pr-4 flex items-center text-slate-400 hover:text-slate-600 focus:outline-none">
                            <i class="fas" :class="show ? 'fa-eye-slash' : 'fa-eye'"></i>
                        </button>
                    </div>
                </div>

                <!-- Password Requirements -->
                <div class="bg-slate-50 dark:bg-slate-800/50 p-5 rounded-xl border border-slate-100 dark:border-slate-700/50">
                    <p class="text-sm font-semibold text-slate-700 dark:text-slate-300 mb-3">Password Requirements:</p>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
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

                <div class="pt-2">
                    <button type="submit" class="btn-primary w-full py-4 text-lg flex items-center justify-center gap-2 shadow-lg shadow-blue-600/30">
                        Update Password <i class="fas fa-arrow-right text-sm"></i>
                    </button>
                </div>
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

    document.getElementById('passwordForm').addEventListener('submit', function(e) {
        const newPass = document.getElementById('newPassword').value;
        const confirmPass = document.getElementById('confirmPassword').value;

        if(newPass !== confirmPass) {
            e.preventDefault();
            if(window.AceBank) AceBank.showToast('New password and confirm password do not match!', 'error');
            else alert('New password and confirm password do not match!');
            return;
        }

        if(newPass.length < 8 || !/[A-Z]/.test(newPass) || !/[a-z]/.test(newPass) || !/[0-9]/.test(newPass)) {
            e.preventDefault();
            if(window.AceBank) AceBank.showToast('Password does not meet the requirements!', 'error');
            else alert('Password does not meet the requirements!');
        }
    });
</script>

<jsp:include page="/includes/footer.jsp" />