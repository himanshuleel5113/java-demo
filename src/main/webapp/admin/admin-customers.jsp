<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.acebank.lite.service.BankService" %>
<%@ page import="com.acebank.lite.service.BankServiceImpl" %>
<%@ page import="com.acebank.lite.models.AdminCustomerView" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    BankService bankService = new BankServiceImpl();
    List<AdminCustomerView> customers = bankService.listCustomers();
    DateTimeFormatter df = DateTimeFormatter.ofPattern("dd MMM yyyy");
    request.setAttribute("active", "customers");
    request.setAttribute("pageTitle", "Customers");
%>
<jsp:include page="/admin/admin-header.jsp" />

<div class="admin-card p-6">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-6">
        <div>
            <h3 class="text-lg font-bold text-slate-900 dark:text-white">All Customers</h3>
            <p class="text-sm text-slate-500"><%= customers.size() %> registered account holder<%= customers.size() == 1 ? "" : "s" %></p>
        </div>
        <div class="relative">
            <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-sm"></i>
            <input id="custSearch" onkeyup="filterRows()" type="text" placeholder="Search name, email, A/C..." class="pl-9 pr-4 py-2.5 w-full sm:w-72 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/30 focus:border-blue-500">
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left">
            <thead>
                <tr class="border-b border-slate-200 dark:border-slate-700 text-[11px] uppercase tracking-wider text-slate-500">
                    <th class="pb-3 pr-4 font-semibold">Customer</th>
                    <th class="pb-3 pr-4 font-semibold">Account</th>
                    <th class="pb-3 pr-4 font-semibold">Balance</th>
                    <th class="pb-3 pr-4 font-semibold">Status</th>
                    <th class="pb-3 pr-4 font-semibold">Joined</th>
                </tr>
            </thead>
            <tbody id="custBody" class="divide-y divide-slate-100 dark:divide-slate-800/60">
            <% if (customers.isEmpty()) { %>
                <tr><td colspan="5" class="py-12 text-center text-slate-400"><i class="fas fa-user-slash text-2xl mb-2 block"></i>No customers registered yet</td></tr>
            <% } else { for (AdminCustomerView c : customers) {
                    String initials = (c.firstName() != null && !c.firstName().isEmpty() ? c.firstName().substring(0,1) : "U").toUpperCase();
                    boolean active = "ACTIVE".equalsIgnoreCase(c.accountStatus());
                    String stClass = active ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                            : "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400";
            %>
                <tr class="text-sm searchable hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                    <td class="py-3.5 pr-4">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-full bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center text-white text-xs font-bold"><%= initials %></div>
                            <div>
                                <p class="font-semibold text-slate-900 dark:text-white"><%= c.firstName() %> <%= c.lastName() %></p>
                                <p class="text-xs text-slate-500"><%= c.email() %><%= c.phone() != null ? " &middot; " + c.phone() : "" %></p>
                            </div>
                        </div>
                    </td>
                    <td class="py-3.5 pr-4 font-mono text-slate-700 dark:text-slate-300"><%= c.accountNo() %></td>
                    <td class="py-3.5 pr-4 font-semibold text-slate-900 dark:text-white">&#8377;<%= String.format("%,.2f", c.balance()) %></td>
                    <td class="py-3.5 pr-4"><span class="pill <%= stClass %>"><%= c.accountStatus() %></span></td>
                    <td class="py-3.5 pr-4 text-slate-500"><%= c.createdAt() != null ? c.createdAt().format(df) : "-" %></td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function filterRows() {
        const q = document.getElementById('custSearch').value.toLowerCase();
        document.querySelectorAll('#custBody tr.searchable').forEach(function(row) {
            row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    }
</script>

<jsp:include page="/admin/admin-footer.jsp" />
