<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String email = (String) session.getAttribute("resetEmail");
    String firstName = (String) session.getAttribute("resetFirstName");

    if (email == null) {
        response.sendRedirect("ForgotPassword.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="relative min-h-[85vh] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div class="absolute top-0 left-1/4 w-96 h-96 bg-blue-400/10 rounded-full blur-3xl animate-pulse-slow"></div>
    </div>

    <div class="relative z-10 w-full max-w-md page-enter">
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-br from-indigo-100 to-purple-100 dark:from-indigo-900/40 dark:to-purple-900/40 text-indigo-600 dark:text-indigo-400 shadow-inner mb-4">
                <i class="fas fa-lock-open text-2xl"></i>
            </div>
            <h2 class="text-3xl font-brand font-bold text-gray-900 dark:text-white mb-2">Verify OTP</h2>
            <p class="text-gray-500 dark:text-gray-400">We've sent a 6-digit code to</p>
            <p class="font-semibold text-blue-600 dark:text-blue-400"><%= email %></p>
            <% if(firstName != null) { %>
                <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Hello, <%= firstName %>!</p>
            <% } %>
        </div>

        <% if(request.getParameter("error") != null) { %>
            <div class="mb-6 p-4 rounded-xl bg-red-50/80 dark:bg-red-900/20 border border-red-200 dark:border-red-800/30 flex items-start gap-3">
                <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
                <p class="text-sm font-medium text-red-700 dark:text-red-400"><%= request.getParameter("error").replace("+", " ") %></p>
            </div>
        <% } %>

        <div class="glass-panel rounded-3xl p-8 shadow-2xl relative overflow-hidden">
            <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-indigo-400 to-purple-600"></div>

            <form action="VerifyOTP" method="POST" id="otpForm" class="space-y-6">
                <div>
                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-4 text-center">
                        Enter 6-digit OTP
                    </label>
                    <div class="flex justify-center gap-2 mb-2">
                        <input type="text" name="otp1" id="otp1" maxlength="1" class="w-12 h-14 text-center text-2xl font-bold bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-xl focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all text-slate-900 dark:text-white" onkeyup="moveToNext(this, 'otp2')" onkeypress="return onlyNumbers(event)" oninput="combineOTP()" autofocus>
                        <input type="text" name="otp2" id="otp2" maxlength="1" class="w-12 h-14 text-center text-2xl font-bold bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-xl focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all text-slate-900 dark:text-white" onkeyup="moveToNext(this, 'otp3')" onkeypress="return onlyNumbers(event)" oninput="combineOTP()">
                        <input type="text" name="otp3" id="otp3" maxlength="1" class="w-12 h-14 text-center text-2xl font-bold bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-xl focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all text-slate-900 dark:text-white" onkeyup="moveToNext(this, 'otp4')" onkeypress="return onlyNumbers(event)" oninput="combineOTP()">
                        <input type="text" name="otp4" id="otp4" maxlength="1" class="w-12 h-14 text-center text-2xl font-bold bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-xl focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all text-slate-900 dark:text-white" onkeyup="moveToNext(this, 'otp5')" onkeypress="return onlyNumbers(event)" oninput="combineOTP()">
                        <input type="text" name="otp5" id="otp5" maxlength="1" class="w-12 h-14 text-center text-2xl font-bold bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-xl focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all text-slate-900 dark:text-white" onkeyup="moveToNext(this, 'otp6')" onkeypress="return onlyNumbers(event)" oninput="combineOTP()">
                        <input type="text" name="otp6" id="otp6" maxlength="1" class="w-12 h-14 text-center text-2xl font-bold bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-xl focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 transition-all text-slate-900 dark:text-white" onkeyup="moveToNext(this, '')" onkeypress="return onlyNumbers(event)" oninput="combineOTP()">
                    </div>
                    <input type="hidden" name="otp" id="otp">
                </div>

                <div class="text-center">
                    <span class="text-sm font-medium text-slate-500 dark:text-slate-400" id="timer">OTP expires in 10:00</span>
                </div>

                <button type="submit" id="submitBtn" class="btn-primary w-full flex items-center justify-center gap-2 py-3.5 text-lg">
                    Verify OTP <i class="fas fa-check-circle text-sm"></i>
                </button>
            </form>

            <div class="mt-6 flex items-center justify-center gap-4 text-sm">
                <form action="VerifyOTP" method="POST" class="inline">
                    <input type="hidden" name="action" value="resend">
                    <button type="submit" class="font-semibold text-blue-600 dark:text-blue-400 hover:underline flex items-center gap-1">
                        <i class="fas fa-redo-alt text-[10px]"></i> Resend
                    </button>
                </form>
                <span class="text-slate-300 dark:text-slate-700">|</span>
                <a href="ForgotPassword.jsp" class="font-semibold text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white transition-colors">
                    Cancel
                </a>
            </div>

            <div class="mt-6 p-3 bg-slate-50 dark:bg-slate-800/50 rounded-xl text-center">
                <p class="text-xs text-slate-500 dark:text-slate-400 flex items-center justify-center gap-2">
                    <i class="fas fa-info-circle text-blue-500"></i>
                    Check server console logs for the OTP in demo mode.
                </p>
            </div>
        </div>
    </div>
</div>

<script>
    let timeLeft = 600;
    let timerInterval;

    function updateTimer() {
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;
        const timerElement = document.getElementById('timer');

        if (timeLeft <= 0) {
            timerElement.innerHTML = 'OTP expired';
            timerElement.className = 'text-sm font-medium text-red-500';
            clearInterval(timerInterval);
            document.getElementById('submitBtn').disabled = true;
            document.getElementById('submitBtn').classList.add('opacity-50', 'cursor-not-allowed');
            return;
        }

        timerElement.innerHTML = `OTP expires in ${minutes}:${seconds.toString().padStart(2, '0')}`;
        timeLeft--;
    }

    timerInterval = setInterval(updateTimer, 1000);

    function onlyNumbers(e) {
        const charCode = e.which ? e.which : e.keyCode;
        if (charCode < 48 || charCode > 57) {
            e.preventDefault();
            return false;
        }
        return true;
    }

    function moveToNext(current, nextId) {
        if (current.value.length === 1 && nextId) {
            document.getElementById(nextId)?.focus();
        }
    }

    function combineOTP() {
        const otp = Array.from({length: 6}, (_, i) => document.getElementById(`otp${i+1}`).value).join('');
        document.getElementById('otp').value = otp;
        if (otp.length === 6) {
            setTimeout(() => document.getElementById('otpForm').submit(), 100);
        }
    }

    document.querySelectorAll('input[id^="otp"]').forEach((input, index) => {
        input.addEventListener('keydown', function(e) {
            if (e.key === 'Backspace' && this.value.length === 0 && index > 0) {
                document.getElementById(`otp${index}`).focus();
            }
        });
    });

    document.addEventListener('paste', function(e) {
        e.preventDefault();
        const paste = (e.clipboardData || window.clipboardData).getData('text').trim();
        if (paste.length === 6 && /^\d+$/.test(paste)) {
            for (let i = 0; i < 6; i++) {
                document.getElementById(`otp${i+1}`).value = paste[i];
            }
            combineOTP();
        } else {
            if(window.AceBank) AceBank.showToast('Please paste a valid 6-digit OTP', 'error');
            else alert('Please paste a valid 6-digit OTP');
        }
    });

    document.getElementById('otpForm').addEventListener('submit', function(e) {
        if (document.getElementById('otp').value.length !== 6) {
            e.preventDefault();
            if(window.AceBank) AceBank.showToast('Please enter the complete 6-digit OTP', 'error');
            else alert('Please enter complete 6-digit OTP');
        }
    });
</script>

<jsp:include page="/includes/footer.jsp" />