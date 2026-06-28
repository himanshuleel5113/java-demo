<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.acebank.lite.service.BankService" %>
<%@ page import="com.acebank.lite.service.BankServiceImpl" %>
<%@ page import="com.acebank.lite.models.AdminLoanView" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Integer _acc = (Integer) session.getAttribute("accountNumber");
    String _role = (String) session.getAttribute("role");
    if (_acc == null || !"ADMIN".equals(_role)) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    BankService bankService = new BankServiceImpl();
    String flash = null;
    boolean flashOk = false;

    // Handle approve / reject before rendering.
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String idStr = request.getParameter("loanId");
        String decision = request.getParameter("decision");
        try {
            int loanId = Integer.parseInt(idStr);
            boolean done = bankService.reviewLoan(loanId, decision, _acc);
            flashOk = done;
            flash = done ? ("Loan #" + loanId + " marked " + decision)
                         : "Could not update loan. Please try again.";
        } catch (Exception e) {
            flash = "Invalid request.";
        }
    }

    List<AdminLoanView> loans = bankService.listLoanApplications();
    DateTimeFormatter df = DateTimeFormatter.ofPattern("dd MMM yyyy");
    request.setAttribute("active", "loans");
    request.setAttribute("pageTitle", "Loan Approvals");
%>
<jsp:include page="/admin/admin-header.jsp" />

<% if (flash != null) { %>
<div class="mb-5 px-4 py-3 rounded-xl text-sm font-medium flex items-center gap-2 <%= flashOk ? "bg-emerald-50 text-emerald-700 border border-emerald-200 dark:bg-emerald-900/20 dark:text-emerald-400 dark:border-emerald-800" : "bg-rose-50 text-rose-700 border border-rose-200 dark:bg-rose-900/20 dark:text-rose-400 dark:border-rose-800" %>">
    <i class="fas <%= flashOk ? "fa-check-circle" : "fa-exclamation-circle" %>"></i> <%= flash %>
</div>
<% } %>

<div class="admin-card p-6">
    <div class="mb-6">
        <h3 class="text-lg font-bold text-slate-900 dark:text-white">Loan Applications</h3>
        <p class="text-sm text-slate-500"><%= loans.size() %> application<%= loans.size() == 1 ? "" : "s" %> total</p>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left">
            <thead>
                <tr class="border-b border-slate-200 dark:border-slate-700 text-[11px] uppercase tracking-wider text-slate-500">
                    <th class="pb-3 pr-4 font-semibold">Applicant</th>
                    <th class="pb-3 pr-4 font-semibold">Type</th>
                    <th class="pb-3 pr-4 font-semibold">Amount</th>
                    <th class="pb-3 pr-4 font-semibold">Tenure</th>
                    <th class="pb-3 pr-4 font-semibold">Applied</th>
                    <th class="pb-3 pr-4 font-semibold">Status</th>
                    <th class="pb-3 pr-4 font-semibold text-right">Action</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100 dark:divide-slate-800/60">
            <% if (loans.isEmpty()) { %>
                <tr><td colspan="7" class="py-12 text-center text-slate-400"><i class="fas fa-folder-open text-2xl mb-2 block"></i>No loan applications yet</td></tr>
            <% } else { for (AdminLoanView l : loans) {
                    String st = l.status();
                    String stClass = "APPROVED".equals(st) ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                            : "REJECTED".equals(st) ? "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400"
                            : "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400";
                    boolean pending = "PENDING".equals(st);
            %>
                <tr class="text-sm align-top hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                    <td class="py-4 pr-4">
                        <p class="font-semibold text-slate-900 dark:text-white"><%= l.applicantName() %></p>
                        <p class="text-xs text-slate-500"><%= l.email() %> &middot; A/C <%= l.accountNo() %></p>
                    </td>
                    <td class="py-4 pr-4"><span class="pill bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400"><%= l.loanType() %></span></td>
                    <td class="py-4 pr-4 font-semibold text-slate-900 dark:text-white">&#8377;<%= String.format("%,.2f", l.amount()) %></td>
                    <td class="py-4 pr-4 text-slate-600 dark:text-slate-300"><%= l.tenure() %> mo</td>
                    <td class="py-4 pr-4 text-slate-500"><%= l.appliedAt() != null ? l.appliedAt().format(df) : "-" %></td>
                    <td class="py-4 pr-4"><span class="pill <%= stClass %>"><%= st %></span></td>
                    <td class="py-4 pr-4">
                        <% if (pending) { %>
                        <div class="flex gap-2 justify-end">
                            <form method="POST" onsubmit="return confirm('Approve loan #<%= l.id() %>?');">
                                <input type="hidden" name="loanId" value="<%= l.id() %>">
                                <input type="hidden" name="decision" value="APPROVED">
                                <button type="submit" class="px-3 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-semibold transition-colors"><i class="fas fa-check mr-1"></i>Approve</button>
                            </form>
                            <form method="POST" onsubmit="return confirm('Reject loan #<%= l.id() %>?');">
                                <input type="hidden" name="loanId" value="<%= l.id() %>">
                                <input type="hidden" name="decision" value="REJECTED">
                                <button type="submit" class="px-3 py-1.5 rounded-lg bg-rose-600 hover:bg-rose-700 text-white text-xs font-semibold transition-colors"><i class="fas fa-times mr-1"></i>Reject</button>
                            </form>
                        </div>
                        <% } else { %>
                        <p class="text-xs text-slate-400 text-right italic">Reviewed</p>
                        <% } %>
                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/admin/admin-footer.jsp" />
