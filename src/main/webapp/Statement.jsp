<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.acebank.lite.models.Transaction" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    List<Transaction> transactions = (List<Transaction>) session.getAttribute("transactionDetailsList");
    BigDecimal balance = (BigDecimal) session.getAttribute("balance");

    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    BigDecimal totalCredits = BigDecimal.ZERO;
    BigDecimal totalDebits = BigDecimal.ZERO;
    if(transactions != null) {
        for(Transaction t : transactions) {
            if(t.senderAccount() != null && t.senderAccount().equals(accountNumber)) {
                totalDebits = totalDebits.add(t.amount());
            } else {
                totalCredits = totalCredits.add(t.amount());
            }
        }
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-7xl mx-auto px-4 py-8 page-enter">
    <!-- Page Header -->
    <div class="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-8">
        <div>
            <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Account Statement</h1>
            <p class="text-slate-500 dark:text-slate-400 mt-1 flex items-center gap-2">
                <span class="inline-flex items-center justify-center w-6 h-6 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 text-xs"><i class="fas fa-hashtag"></i></span>
                XXXX<%= String.valueOf(accountNumber).substring(Math.max(0, String.valueOf(accountNumber).length()-4)) %>
            </p>
        </div>
        <button onclick="window.print()" class="btn-secondary whitespace-nowrap hidden sm:flex items-center gap-2">
            <i class="fas fa-print"></i> Print Statement
        </button>
    </div>

    <!-- Summary Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div class="glass-panel rounded-2xl p-6 shadow-md">
            <div class="flex items-center gap-4 mb-4">
                <div class="w-10 h-10 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-slate-500 dark:text-slate-400">
                    <i class="fas fa-history"></i>
                </div>
                <p class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">Opening</p>
            </div>
            <p class="text-2xl font-brand font-bold text-slate-900 dark:text-white">₹ 0.00</p>
        </div>

        <div class="glass-panel rounded-2xl p-6 shadow-md border-b-4 border-b-emerald-500">
            <div class="flex items-center gap-4 mb-4">
                <div class="w-10 h-10 rounded-full bg-emerald-100 dark:bg-emerald-900/40 flex items-center justify-center text-emerald-600 dark:text-emerald-400">
                    <i class="fas fa-arrow-down"></i>
                </div>
                <p class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">Total In</p>
            </div>
            <p class="text-2xl font-brand font-bold text-emerald-600 dark:text-emerald-400">₹ <%= String.format("%,.2f", totalCredits) %></p>
        </div>

        <div class="glass-panel rounded-2xl p-6 shadow-md border-b-4 border-b-rose-500">
            <div class="flex items-center gap-4 mb-4">
                <div class="w-10 h-10 rounded-full bg-rose-100 dark:bg-rose-900/40 flex items-center justify-center text-rose-600 dark:text-rose-400">
                    <i class="fas fa-arrow-up"></i>
                </div>
                <p class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">Total Out</p>
            </div>
            <p class="text-2xl font-brand font-bold text-rose-600 dark:text-rose-400">₹ <%= String.format("%,.2f", totalDebits) %></p>
        </div>

        <div class="glass-panel rounded-2xl p-6 shadow-md border-b-4 border-b-blue-500">
            <div class="flex items-center gap-4 mb-4">
                <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/40 flex items-center justify-center text-blue-600 dark:text-blue-400">
                    <i class="fas fa-wallet"></i>
                </div>
                <p class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">Closing</p>
            </div>
            <p class="text-2xl font-brand font-bold text-blue-600 dark:text-blue-400">₹ <%= balance != null ? String.format("%,.2f", balance) : "0.00" %></p>
        </div>
    </div>

    <!-- Filters -->
    <div class="glass-panel rounded-2xl p-6 mb-8 shadow-sm">
        <div class="flex flex-col lg:flex-row gap-4 items-center justify-between">
            <div class="flex flex-wrap items-center gap-4 w-full lg:w-auto">
                <select class="input-field max-w-[200px] text-sm py-2 px-3">
                    <option>Last 30 days</option>
                    <option>Last 3 months</option>
                    <option>Last 6 months</option>
                    <option>This year</option>
                </select>
                <div class="flex items-center gap-2">
                    <input type="date" class="input-field text-sm py-2 px-3 w-[140px]">
                    <span class="text-slate-400 text-sm">to</span>
                    <input type="date" class="input-field text-sm py-2 px-3 w-[140px]">
                </div>
                <button class="btn-primary py-2 px-4 text-sm whitespace-nowrap">
                    Apply Filter
                </button>
            </div>
            <div class="w-full lg:w-auto flex justify-end">
                <button class="text-sm font-semibold text-blue-600 dark:text-blue-400 hover:underline flex items-center gap-2">
                    <i class="fas fa-download"></i> Download PDF
                </button>
            </div>
        </div>
    </div>

    <!-- Transactions Table -->
    <div class="glass-panel rounded-3xl overflow-hidden shadow-lg border border-slate-200 dark:border-slate-800">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-slate-50 dark:bg-slate-800/80 border-b border-slate-200 dark:border-slate-700">
                        <th class="px-6 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">Date & Time</th>
                        <th class="px-6 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">Transaction ID</th>
                        <th class="px-6 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">Description</th>
                        <th class="px-6 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">Type</th>
                        <th class="px-6 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 text-right">Amount</th>
                        <th class="px-6 py-4 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 text-right">Balance</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                    <% if(transactions != null && !transactions.isEmpty()) {
                        BigDecimal runningBalance = balance;
                        for(Transaction t : transactions) {
                            boolean isDebit = (t.senderAccount() != null && t.senderAccount().equals(accountNumber));
                            String typeColor = "bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300";
                            if("DEPOSIT".equals(t.txType())) typeColor = "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/50 dark:text-emerald-400";
                            else if("WITHDRAWAL".equals(t.txType())) typeColor = "bg-rose-100 text-rose-700 dark:bg-rose-900/50 dark:text-rose-400";
                            else if("TRANSFER".equals(t.txType())) typeColor = "bg-blue-100 text-blue-700 dark:bg-blue-900/50 dark:text-blue-400";
                            else if("LOAN".equals(t.txType())) typeColor = "bg-purple-100 text-purple-700 dark:bg-purple-900/50 dark:text-purple-400";
                    %>
                        <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/30 transition-colors">
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-600 dark:text-slate-400"><%= t.createdAt() != null ? t.createdAt().format(formatter) : "-" %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-xs font-mono text-slate-500 dark:text-slate-500">TXN<%= String.format("%08d", t.id()) %></td>
                            <td class="px-6 py-4">
                                <p class="text-sm font-semibold text-slate-900 dark:text-white">
                                    <% if("TRANSFER".equals(t.txType())) { %>
                                        <%= isDebit ? "To: A/C " + t.receiverAccount() : "From: A/C " + t.senderAccount() %>
                                    <% } else if("DEPOSIT".equals(t.txType())) { %>
                                        Cash Deposit
                                    <% } else if("LOAN".equals(t.txType())) { %>
                                        Loan Disbursement
                                    <% } else { %>
                                        Cash Withdrawal
                                    <% } %>
                                </p>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= typeColor %>">
                                    <%= t.txType() %>
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-semibold <%= isDebit ? "text-rose-600 dark:text-rose-400" : "text-emerald-600 dark:text-emerald-400" %>">
                                <%= isDebit ? "-" : "+" %> ₹ <%= String.format("%,.2f", t.amount()) %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-semibold text-slate-900 dark:text-white">
                                ₹ <%= String.format("%,.2f", runningBalance) %>
                            </td>
                        </tr>
                    <%
                            if(isDebit) {
                                runningBalance = runningBalance.add(t.amount());
                            } else {
                                runningBalance = runningBalance.subtract(t.amount());
                            }
                        }
                    } else { %>
                        <tr>
                            <td colspan="6" class="px-6 py-16 text-center text-slate-500 dark:text-slate-400">
                                <div class="w-16 h-16 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center mx-auto mb-4 text-2xl">
                                    <i class="fas fa-receipt"></i>
                                </div>
                                <p class="text-lg font-semibold text-slate-900 dark:text-white">No transactions found</p>
                                <p class="text-sm mt-1">Your account statement is currently empty.</p>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<style>
    @media print {
        body { background: white; }
        .btn-secondary, nav, footer { display: none !important; }
        .glass-panel { box-shadow: none !important; border: 1px solid #e5e7eb !important; background: white !important; }
        * { color: black !important; }
    }
</style>

<jsp:include page="/includes/footer.jsp" />