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
        <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Deposit Money</h1>
        <p class="text-slate-500 dark:text-slate-400 mt-1">Add funds to your account securely</p>
    </div>

    <div class="glass-panel rounded-3xl p-8 shadow-xl relative overflow-hidden">
        <!-- decorative bg -->
        <div class="absolute top-0 right-0 w-64 h-64 bg-emerald-500/10 rounded-full blur-3xl transform translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>
        
        <div class="relative z-10">
            <!-- Quick Amount Selection -->
            <div class="mb-8">
                <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-3">Quick Amount</label>
                <div class="grid grid-cols-3 gap-3">
                    <button type="button" onclick="setAmount(1000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 hover:text-emerald-700 dark:hover:text-emerald-400 font-medium transition-all duration-300">₹1,000</button>
                    <button type="button" onclick="setAmount(5000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 hover:text-emerald-700 dark:hover:text-emerald-400 font-medium transition-all duration-300">₹5,000</button>
                    <button type="button" onclick="setAmount(10000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 hover:text-emerald-700 dark:hover:text-emerald-400 font-medium transition-all duration-300">₹10,000</button>
                    <button type="button" onclick="setAmount(25000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 hover:text-emerald-700 dark:hover:text-emerald-400 font-medium transition-all duration-300">₹25,000</button>
                    <button type="button" onclick="setAmount(50000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 hover:text-emerald-700 dark:hover:text-emerald-400 font-medium transition-all duration-300">₹50,000</button>
                    <button type="button" onclick="setAmount(100000)" class="px-4 py-3 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800/50 hover:border-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 hover:text-emerald-700 dark:hover:text-emerald-400 font-medium transition-all duration-300">₹1,00,000</button>
                </div>
            </div>

            <!-- Deposit Form -->
            <form action="<%= request.getContextPath() %>/home" method="POST" onsubmit="return validateForm()">
                <div class="mb-8">
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-3">Amount to Deposit (₹)</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 text-2xl">
                            ₹
                        </div>
                        <input type="number" name="deposit" id="amount" step="0.01" min="1" required
                               class="w-full pl-12 pr-4 py-4 bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-2xl text-3xl font-brand font-bold text-slate-900 dark:text-white focus:ring-4 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all text-right"
                               placeholder="0.00">
                    </div>
                </div>

                <div class="mb-8 p-4 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800/50 flex gap-4">
                    <div class="mt-0.5 flex-shrink-0 flex items-center justify-center w-8 h-8 rounded-full bg-emerald-100 dark:bg-emerald-800 text-emerald-600 dark:text-emerald-300">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <div>
                        <p class="font-semibold text-emerald-800 dark:text-emerald-400 text-sm">Instant Credit</p>
                        <p class="text-emerald-600 dark:text-emerald-500 text-xs mt-1">Funds will be credited to your account immediately</p>
                    </div>
                </div>

                <div class="flex flex-col sm:flex-row gap-4">
                    <button type="submit" class="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white py-4 rounded-xl font-semibold text-lg transition-colors flex items-center justify-center gap-2 shadow-lg shadow-emerald-600/30">
                        <i class="fas fa-arrow-down text-sm"></i> Deposit Now
                    </button>
                    <a href="home" class="sm:flex-none sm:w-32 btn-secondary py-4 flex items-center justify-center text-center">
                        Cancel
                    </a>
                </div>
            </form>

            <!-- Security Note -->
            <div class="mt-8 flex items-center justify-center gap-2 text-xs font-medium text-slate-500 dark:text-slate-400 bg-slate-50 dark:bg-slate-800/50 py-3 rounded-lg">
                <i class="fas fa-shield-check text-emerald-500"></i>
                Your transaction is secure with 256-bit encryption
            </div>
        </div>
    </div>
</div>

<script>
    function setAmount(amount) {
        document.getElementById('amount').value = amount;
    }

    function validateForm() {
        const amount = document.getElementById('amount').value;
        if(amount <= 0) {
            if(window.AceBank) AceBank.showToast('Please enter a valid amount greater than 0', 'error');
            else alert('Please enter a valid amount greater than 0');
            return false;
        }
        return confirm('Confirm deposit of ₹' + parseFloat(amount).toFixed(2) + '?');
    }
</script>

<jsp:include page="/includes/footer.jsp" />