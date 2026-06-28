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

<div class="max-w-4xl mx-auto px-4 py-8 page-enter">
    <!-- Page Header -->
    <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Fund Transfer</h1>
            <p class="text-slate-500 dark:text-slate-400 mt-1">Send money securely to any bank account</p>
        </div>
        <div class="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-400 font-semibold border border-blue-200 dark:border-blue-800/30">
            <i class="fas fa-wallet text-sm"></i> ₹ <%= balance != null ? String.format("%,.2f", balance) : "0.00" %> Available
        </div>
    </div>

    <div class="glass-panel rounded-3xl p-8 shadow-xl relative overflow-hidden">
        <!-- Background accents -->
        <div class="absolute top-0 right-0 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl transform translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>
        <div class="absolute bottom-0 left-0 w-64 h-64 bg-indigo-500/5 rounded-full blur-3xl transform -translate-x-1/3 translate-y-1/3 pointer-events-none"></div>
        
        <div class="relative z-10 grid lg:grid-cols-5 gap-12">
            
            <!-- Left side: Quick Beneficiaries & Info -->
            <div class="lg:col-span-2 space-y-8">
                <div>
                    <h3 class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-4">Quick Send</h3>
                    <div class="grid grid-cols-4 gap-4">
                        <div class="flex flex-col items-center gap-2 cursor-pointer group">
                            <div class="w-12 h-12 rounded-2xl bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-400 flex items-center justify-center text-xl shadow-sm border border-blue-200 dark:border-blue-800/30 group-hover:-translate-y-1 transition-transform">
                                <i class="fas fa-user"></i>
                            </div>
                            <span class="text-xs font-medium text-slate-600 dark:text-slate-300">John</span>
                        </div>
                        <div class="flex flex-col items-center gap-2 cursor-pointer group">
                            <div class="w-12 h-12 rounded-2xl bg-emerald-100 dark:bg-emerald-900/40 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-xl shadow-sm border border-emerald-200 dark:border-emerald-800/30 group-hover:-translate-y-1 transition-transform">
                                <i class="fas fa-user"></i>
                            </div>
                            <span class="text-xs font-medium text-slate-600 dark:text-slate-300">Priya</span>
                        </div>
                        <div class="flex flex-col items-center gap-2 cursor-pointer group">
                            <div class="w-12 h-12 rounded-2xl bg-purple-100 dark:bg-purple-900/40 text-purple-600 dark:text-purple-400 flex items-center justify-center text-xl shadow-sm border border-purple-200 dark:border-purple-800/30 group-hover:-translate-y-1 transition-transform">
                                <i class="fas fa-user"></i>
                            </div>
                            <span class="text-xs font-medium text-slate-600 dark:text-slate-300">Rahul</span>
                        </div>
                        <div class="flex flex-col items-center gap-2 cursor-pointer group">
                            <div class="w-12 h-12 rounded-2xl bg-slate-100 dark:bg-slate-800 border border-dashed border-slate-300 dark:border-slate-600 text-slate-400 dark:text-slate-500 flex items-center justify-center text-xl group-hover:bg-slate-200 dark:group-hover:bg-slate-700 transition-colors">
                                <i class="fas fa-plus"></i>
                            </div>
                            <span class="text-xs font-medium text-slate-600 dark:text-slate-300">New</span>
                        </div>
                    </div>
                </div>

                <div class="p-5 rounded-2xl bg-gradient-to-br from-slate-50 to-slate-100 dark:from-slate-800/50 dark:to-slate-800 border border-slate-200 dark:border-slate-700">
                    <div class="flex items-start gap-4">
                        <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-400 flex items-center justify-center flex-shrink-0">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <div>
                            <h4 class="font-semibold text-slate-900 dark:text-white">Zero Fees Transfer</h4>
                            <p class="text-sm text-slate-500 dark:text-slate-400 mt-1">IMPS, NEFT, and RTGS transfers are completely free of charge.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right side: Transfer Form -->
            <div class="lg:col-span-3">
                <form action="<%= request.getContextPath() %>/home" method="POST" onsubmit="return validateTransfer()" class="space-y-6">
                    
                    <div class="p-4 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50">
                        <label class="block text-xs font-medium uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1">From Account</label>
                        <p class="font-semibold text-slate-900 dark:text-white flex items-center gap-2">
                            <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                            Savings Account <span class="text-slate-400 font-mono text-sm ml-1">• <%= String.valueOf(accountNumber).substring(Math.max(0, String.valueOf(accountNumber).length()-4)) %></span>
                        </p>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Transfer To (Account Number)</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                                <i class="fas fa-university"></i>
                            </div>
                            <input type="number" name="toAccount" id="toAccount" required
                                   class="input-field pl-11"
                                   placeholder="Enter beneficiary account number">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Amount</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 text-lg">
                                ₹
                            </div>
                            <input type="number" name="toAmount" id="amount" step="0.01" min="1" required
                                   class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border-2 border-slate-200 dark:border-slate-700 rounded-xl text-xl font-brand font-bold text-slate-900 dark:text-white focus:ring-4 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-right"
                                   placeholder="0.00">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Remarks (Optional)</label>
                        <input type="text" name="remarks" class="input-field" placeholder="What is this for?">
                    </div>

                    <div class="pt-4 flex flex-col sm:flex-row gap-4">
                        <button type="submit" class="flex-1 btn-primary py-4 text-lg flex items-center justify-center gap-2 shadow-lg shadow-blue-600/30">
                            Send Money <i class="fas fa-paper-plane text-sm"></i>
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<script>
    function validateTransfer() {
        const toAccount = document.getElementById('toAccount').value;
        const amount = parseFloat(document.getElementById('amount').value);
        const balance = <%= balance != null ? balance : 0 %>;

        if(!toAccount || toAccount.length < 8) {
            if(window.AceBank) AceBank.showToast('Please enter a valid account number', 'error');
            else alert('Please enter a valid account number');
            return false;
        }
        if(toAccount === '<%= accountNumber %>') {
            if(window.AceBank) AceBank.showToast('You cannot transfer money to your own account', 'error');
            else alert('You cannot transfer money to your own account');
            return false;
        }
        if(amount <= 0) {
            if(window.AceBank) AceBank.showToast('Please enter a valid amount', 'error');
            else alert('Please enter a valid amount');
            return false;
        }
        if(amount > balance) {
            if(window.AceBank) AceBank.showToast('Insufficient balance for this transfer', 'error');
            else alert('Insufficient balance for this transfer');
            return false;
        }
        return confirm('Transfer ₹' + amount.toFixed(2) + ' to account ' + toAccount + '?');
    }
</script>

<jsp:include page="/includes/footer.jsp" />