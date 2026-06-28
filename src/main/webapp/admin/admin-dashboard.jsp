<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.acebank.lite.service.BankService" %>
<%@ page import="com.acebank.lite.service.BankServiceImpl" %>
<%@ page import="com.acebank.lite.models.AdminDashboardStats" %>
<%@ page import="com.acebank.lite.models.Transaction" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // Auth is enforced inside admin-header.jsp; fetch data here.
    BankService bankService = new BankServiceImpl();
    AdminDashboardStats stats = bankService.getAdminStats();
    List<Transaction> recent = bankService.getRecentTransactions(8);
    BigDecimal totalDeposits = stats.totalDeposits() != null ? stats.totalDeposits() : BigDecimal.ZERO;
    BigDecimal pendingLoanAmt = stats.totalLoans() != null ? stats.totalLoans() : BigDecimal.ZERO;
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
    request.setAttribute("active", "overview");
    request.setAttribute("pageTitle", "Dashboard Overview");
%>
<jsp:include page="/admin/admin-header.jsp" />

<!-- Stat cards -->
<div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 mb-8">
    <div class="admin-card p-6">
        <div class="flex justify-between items-start mb-4">
            <div class="w-12 h-12 rounded-2xl bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-400 flex items-center justify-center text-xl"><i class="fas fa-users"></i></div>
        </div>
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Total Customers</p>
        <h3 class="text-3xl font-brand font-bold text-slate-900 dark:text-white"><%= String.format("%,d", stats.totalUsers()) %></h3>
    </div>
    <div class="admin-card p-6">
        <div class="flex justify-between items-start mb-4">
            <div class="w-12 h-12 rounded-2xl bg-emerald-100 dark:bg-emerald-900/40 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-xl"><i class="fas fa-rupee-sign"></i></div>
        </div>
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Total Deposits</p>
        <h3 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">&#8377;<%= String.format("%,.2f", totalDeposits) %></h3>
    </div>
    <div class="admin-card p-6">
        <div class="flex justify-between items-start mb-4">
            <div class="w-12 h-12 rounded-2xl bg-amber-100 dark:bg-amber-900/40 text-amber-600 dark:text-amber-400 flex items-center justify-center text-xl"><i class="fas fa-wallet"></i></div>
        </div>
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Total Accounts</p>
        <h3 class="text-3xl font-brand font-bold text-slate-900 dark:text-white"><%= String.format("%,d", stats.totalAccounts()) %></h3>
    </div>
    <div class="admin-card p-6">
        <div class="flex justify-between items-start mb-4">
            <div class="w-12 h-12 rounded-2xl bg-rose-100 dark:bg-rose-900/40 text-rose-600 dark:text-rose-400 flex items-center justify-center text-xl"><i class="fas fa-hand-holding-usd"></i></div>
        </div>
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Pending Loans</p>
        <h3 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">&#8377;<%= String.format("%,.2f", pendingLoanAmt) %></h3>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Recent transactions -->
    <div class="lg:col-span-2 admin-card p-6">
        <div class="flex justify-between items-center mb-5">
            <h3 class="text-lg font-bold text-slate-900 dark:text-white">Recent Transactions</h3>
            <a href="<%= request.getContextPath() %>/admin/admin-transactions.jsp" class="text-sm font-semibold text-blue-600 dark:text-blue-400 hover:underline">View all</a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead>
                    <tr class="border-b border-slate-200 dark:border-slate-700 text-[11px] uppercase tracking-wider text-slate-500">
                        <th class="pb-3 font-semibold">Reference</th>
                        <th class="pb-3 font-semibold">Type</th>
                        <th class="pb-3 font-semibold">Amount</th>
                        <th class="pb-3 font-semibold">Status</th>
                        <th class="pb-3 font-semibold">Date</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 dark:divide-slate-800/60">
                <% if (recent.isEmpty()) { %>
                    <tr><td colspan="5" class="py-10 text-center text-slate-400"><i class="fas fa-inbox text-2xl mb-2 block"></i>No transactions yet</td></tr>
                <% } else { for (Transaction t : recent) {
                        String type = t.txType();
                        String typeClass = "DEPOSIT".equals(type) ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                                : "WITHDRAWAL".equals(type) ? "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400"
                                : "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400";
                        String st = t.status();
                        String stClass = "COMPLETED".equals(st) ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                                : "FAILED".equals(st) ? "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400"
                                : "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400";
                %>
                    <tr class="text-sm">
                        <td class="py-3.5 font-mono text-xs text-slate-500"><%= t.referenceNo() != null ? t.referenceNo().substring(0, Math.min(8, t.referenceNo().length())) : ("#" + t.id()) %></td>
                        <td class="py-3.5"><span class="pill <%= typeClass %>"><%= type %></span></td>
                        <td class="py-3.5 font-semibold text-slate-900 dark:text-white">&#8377;<%= String.format("%,.2f", t.amount()) %></td>
                        <td class="py-3.5"><span class="pill <%= stClass %>"><%= st %></span></td>
                        <td class="py-3.5 text-slate-500"><%= t.createdAt() != null ? t.createdAt().format(dtf) : "-" %></td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Quick actions -->
    <div class="admin-card p-6">
        <h3 class="text-lg font-bold text-slate-900 dark:text-white mb-5">Quick Actions</h3>
        <div class="space-y-3">
            <a href="<%= request.getContextPath() %>/admin/admin-customers.jsp" class="flex items-center justify-between p-4 rounded-xl border border-slate-200 dark:border-slate-700 hover:border-blue-400 hover:bg-blue-50/50 dark:hover:bg-blue-900/10 transition-colors">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/40 text-blue-600 flex items-center justify-center"><i class="fas fa-users"></i></div>
                    <div><p class="font-semibold text-slate-900 dark:text-white text-sm">Manage Customers</p><p class="text-xs text-slate-500"><%= stats.totalUsers() %> registered</p></div>
                </div>
                <i class="fas fa-chevron-right text-xs text-slate-400"></i>
            </a>
            <a href="<%= request.getContextPath() %>/admin/admin-loans.jsp" class="flex items-center justify-between p-4 rounded-xl border border-slate-200 dark:border-slate-700 hover:border-amber-400 hover:bg-amber-50/50 dark:hover:bg-amber-900/10 transition-colors">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-amber-100 dark:bg-amber-900/40 text-amber-600 flex items-center justify-center"><i class="fas fa-hand-holding-usd"></i></div>
                    <div><p class="font-semibold text-slate-900 dark:text-white text-sm">Loan Approvals</p><p class="text-xs text-slate-500">Review pending applications</p></div>
                </div>
                <i class="fas fa-chevron-right text-xs text-slate-400"></i>
            </a>
            <a href="<%= request.getContextPath() %>/admin/admin-transactions.jsp" class="flex items-center justify-between p-4 rounded-xl border border-slate-200 dark:border-slate-700 hover:border-emerald-400 hover:bg-emerald-50/50 dark:hover:bg-emerald-900/10 transition-colors">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-emerald-100 dark:bg-emerald-900/40 text-emerald-600 flex items-center justify-center"><i class="fas fa-exchange-alt"></i></div>
                    <div><p class="font-semibold text-slate-900 dark:text-white text-sm">Transaction Monitor</p><p class="text-xs text-slate-500">Full ledger</p></div>
                </div>
                <i class="fas fa-chevron-right text-xs text-slate-400"></i>
            </a>
        </div>
    </div>
</div>

<jsp:include page="/admin/admin-footer.jsp" />
