<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    BigDecimal balance = (BigDecimal) session.getAttribute("balance");

    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-3xl mx-auto px-4 py-8 page-enter">
    <!-- Page Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Withdraw Money</h1>
        <p class="text-slate-500 dark:text-slate-400 mt-1">Withdraw cash from your account</p>
    </div>

    <!-- Balance Card -->
    <div class="glass-panel border-0 bg-gradient-to-r from-rose-600 to-rose-900 rounded-3xl p-6 mb-8 text-white shadow-lg relative overflow-hidden">
        <div class="absolute top-0 right-0 w-48 h-48 bg-white/10 rounded-full blur-2xl transform translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>
        <div class="relative z-10 flex justify-between items-center">
            <div>
                <p class="text-sm text-rose-200/80 uppercase tracking-wider font-semibold mb-1">Available Balance</p>
                <p class="text-4xl font-brand font-bold">₹ <%= balance != null ? String.format("%,.2f", balance) : "0.00" %></p>
            </div>
            <div class="w-16 h-16 rounded-2xl bg-white/10 backdrop-blur flex items-center justify-center text-rose-200 text-3xl">
                <i class="fas fa-wallet"></i>
            </div>
        </div>
    </div>

    <div class="glass-panel rounded-3xl p-8 shadow-xl relative overflow-hidden">
        <div class="relative z-10">
            <!-- Quick Amount Selection -->
            <div class="mb-8">
                <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-3">Quick Amount</label>
                <div class="grid grid-cols-3 gap-3">
                    <button type="button" onclick="setAmount(1000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-rose-500 hover:bg-rose-50 dark:hover:bg-rose-900/20 hover:text-rose-700 dark:hover:text-rose-400 font-medium transition-all duration-300">₹1,000</button>
                    <button type="button" onclick="setAmount(2000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-rose-500 hover:bg-rose-50 dark:hover:bg-rose-900/20 hover:text-rose-700 dark:hover:text-rose-400 font-medium transition-all duration-300">₹2,000</button>
                    <button type="button" onclick="setAmount(5000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-rose-500 hover:bg-rose-50 dark:hover:bg-rose-900/20 hover:text-rose-700 dark:hover:text-rose-400 font-medium transition-all duration-300">₹5,000</button>
                    <button type="button" onclick="setAmount(10000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-rose-500 hover:bg-rose-50 dark:hover:bg-rose-900/20 hover:text-rose-700 dark:hover:text-rose-400 font-medium transition-all duration-300">₹10,000</button>
                    <button type="button" onclick="setAmount(20000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-rose-500 hover:bg-rose-50 dark:hover:bg-rose-900/20 hover:text-rose-700 dark:hover:text-rose-400 font-medium transition-all duration-300">₹20,000</button>
                    <button type="button" onclick="setAmount(50000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-rose-500 hover:bg-rose-50 dark:hover:bg-rose-900/20 hover:text-rose-700 dark:hover:text-rose-400 font-medium transition-all duration-300">₹50,000</button>
                </div>
            </div>

            <!-- Daily Limit Info -->
            <div class="mb-8 p-4 rounded-xl bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800/50 flex gap-4">
                <div class="mt-0.5 flex-shrink-0 flex items-center justify-center w-8 h-8 rounded-full bg-amber-100 dark:bg-amber-800 text-amber-600 dark:text-amber-300">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div>
                    <p class="font-semibold text-amber-800 dark:text-amber-400 text-sm">Daily Withdrawal Limit: ₹50,000</p>
                    <p class="text-amber-700 dark:text-amber-500 text-xs mt-1">You can withdraw up to ₹50,000 per day</p>
                </div>
            </div>

            <!-- Withdrawal Form -->
            <form action="<%= request.getContextPath() %>/home" method="POST" onsubmit="return validateWithdraw()">
                <input type="hidden" name="withdraw" value="true">

                <div class="mb-8">
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-3">Amount to Withdraw (₹)</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 text-2xl">
                            ₹
                        </div>
                        <input type="number" name="withdrawAmount" id="amount" step="0.01" min="1" max="50000" required
                               class="w-full pl-12 pr-4 py-4 bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-2xl text-3xl font-brand font-bold text-slate-900 dark:text-white focus:ring-4 focus:ring-rose-500/20 focus:border-rose-500 transition-all text-right"
                               placeholder="0.00">
                    </div>
                </div>

                <div class="flex flex-col sm:flex-row gap-4">
                    <button type="submit" class="flex-1 bg-rose-600 hover:bg-rose-700 text-white py-4 rounded-xl font-semibold text-lg transition-colors flex items-center justify-center gap-2 shadow-lg shadow-rose-600/30">
                        <i class="fas fa-arrow-up text-sm"></i> Withdraw Now
                    </button>
                    <a href="home" class="sm:flex-none sm:w-32 btn-secondary py-4 flex items-center justify-center text-center">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function setAmount(amount) {
        document.getElementById('amount').value = amount;
    }

    function validateWithdraw() {
        const amount = parseFloat(document.getElementById('amount').value);
        const balance = <%= balance != null ? balance : 0 %>;

        if(amount <= 0) {
            if(window.AceBank) AceBank.showToast('Please enter a valid amount', 'error');
            else alert('Please enter a valid amount');
            return false;
        }
        if(amount > 50000) {
            if(window.AceBank) AceBank.showToast('Daily withdrawal limit is ₹50,000', 'error');
            else alert('Daily withdrawal limit is ₹50,000');
            return false;
        }
        if(amount > balance) {
            if(window.AceBank) AceBank.showToast('Insufficient balance. Your available balance is ₹' + balance.toFixed(2), 'error');
            else alert('Insufficient balance. Your available balance is ₹' + balance.toFixed(2));
            return false;
        }
        return confirm('Please confirm withdrawal of ₹' + amount.toFixed(2) + ' from your account?');
    }
</script>

<jsp:include page="/includes/footer.jsp" />