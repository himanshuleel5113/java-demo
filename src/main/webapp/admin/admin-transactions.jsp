<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.acebank.lite.service.BankService" %>
<%@ page import="com.acebank.lite.service.BankServiceImpl" %>
<%@ page import="com.acebank.lite.models.Transaction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    BankService bankService = new BankServiceImpl();
    List<Transaction> txns = bankService.getRecentTransactions(200);
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
    request.setAttribute("active", "transactions");
    request.setAttribute("pageTitle", "Transactions");
%>
<jsp:include page="/admin/admin-header.jsp" />

<div class="admin-card p-6">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-6">
        <div>
            <h3 class="text-lg font-bold text-slate-900 dark:text-white">Transaction Ledger</h3>
            <p class="text-sm text-slate-500">Showing latest <%= txns.size() %> transaction<%= txns.size() == 1 ? "" : "s" %> across all accounts</p>
        </div>
        <div class="relative">
            <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-sm"></i>
            <input id="txnSearch" onkeyup="filterTxn()" type="text" placeholder="Search reference, account, type..." class="pl-9 pr-4 py-2.5 w-full sm:w-80 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/30 focus:border-blue-500">
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left">
            <thead>
                <tr class="border-b border-slate-200 dark:border-slate-700 text-[11px] uppercase tracking-wider text-slate-500">
                    <th class="pb-3 pr-4 font-semibold">Reference</th>
                    <th class="pb-3 pr-4 font-semibold">From</th>
                    <th class="pb-3 pr-4 font-semibold">To</th>
                    <th class="pb-3 pr-4 font-semibold">Type</th>
                    <th class="pb-3 pr-4 font-semibold">Amount</th>
                    <th class="pb-3 pr-4 font-semibold">Status</th>
                    <th class="pb-3 pr-4 font-semibold">Date</th>
                </tr>
            </thead>
            <tbody id="txnBody" class="divide-y divide-slate-100 dark:divide-slate-800/60">
            <% if (txns.isEmpty()) { %>
                <tr><td colspan="7" class="py-12 text-center text-slate-400"><i class="fas fa-inbox text-2xl mb-2 block"></i>No transactions recorded yet</td></tr>
            <% } else { for (Transaction t : txns) {
                    String type = t.txType();
                    String typeClass = "DEPOSIT".equals(type) ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                            : "WITHDRAWAL".equals(type) ? "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400"
                            : "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400";
                    String st = t.status();
                    String stClass = "COMPLETED".equals(st) ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                            : "FAILED".equals(st) ? "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400"
                            : "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400";
            %>
                <tr class="text-sm searchable hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                    <td class="py-3.5 pr-4 font-mono text-xs text-slate-500"><%= t.referenceNo() != null ? t.referenceNo() : ("#" + t.id()) %></td>
                    <td class="py-3.5 pr-4 font-mono text-slate-700 dark:text-slate-300"><%= t.senderAccount() != null ? t.senderAccount() : "&mdash;" %></td>
                    <td class="py-3.5 pr-4 font-mono text-slate-700 dark:text-slate-300"><%= t.receiverAccount() != null ? t.receiverAccount() : "&mdash;" %></td>
                    <td class="py-3.5 pr-4"><span class="pill <%= typeClass %>"><%= type %></span></td>
                    <td class="py-3.5 pr-4 font-semibold text-slate-900 dark:text-white">&#8377;<%= String.format("%,.2f", t.amount()) %></td>
                    <td class="py-3.5 pr-4"><span class="pill <%= stClass %>"><%= st %></span></td>
                    <td class="py-3.5 pr-4 text-slate-500 whitespace-nowrap"><%= t.createdAt() != null ? t.createdAt().format(dtf) : "-" %></td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function filterTxn() {
        const q = document.getElementById('txnSearch').value.toLowerCase();
        document.querySelectorAll('#txnBody tr.searchable').forEach(function(row) {
            row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    }
</script>

<jsp:include page="/admin/admin-footer.jsp" />
