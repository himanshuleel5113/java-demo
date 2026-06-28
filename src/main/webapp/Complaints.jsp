<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-4xl mx-auto px-4 py-8 page-enter">
    <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Help & Support</h1>
            <p class="text-slate-500 dark:text-slate-400 mt-1">Raise a ticket or track your previous complaints</p>
        </div>
        <button class="btn-primary py-2.5 px-5 flex items-center gap-2 bg-rose-600 hover:bg-rose-700 shadow-rose-600/30">
            <i class="fas fa-plus"></i> Raise New Ticket
        </button>
    </div>

    <!-- Active Tickets -->
    <div class="glass-panel rounded-3xl p-8 shadow-xl relative overflow-hidden mb-8 border-t-4 border-amber-500">
        <div class="flex justify-between items-start mb-4">
            <div>
                <h3 class="font-bold text-slate-900 dark:text-white text-lg">Transaction Failed but amount deducted</h3>
                <p class="text-xs text-slate-500 font-mono mt-1">Ticket #TKT-892100</p>
            </div>
            <span class="px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400">
                In Progress
            </span>
        </div>

        <p class="text-sm text-slate-600 dark:text-slate-400 mb-6">I tried to transfer ₹5000 to John Doe yesterday. The transaction failed due to timeout but the amount was deducted from my account.</p>

        <div class="flex justify-between items-center pt-4 border-t border-slate-200 dark:border-slate-700/50">
            <p class="text-xs text-slate-500">Raised on: 24 Jun 2024</p>
            <button class="text-sm font-semibold text-blue-600 dark:text-blue-400 hover:underline">View Details</button>
        </div>
    </div>
    
    <!-- Resolved Tickets -->
    <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-4">Resolved Tickets</h3>
    <div class="glass-panel rounded-3xl p-8 shadow-sm border border-slate-200 dark:border-slate-800 opacity-75">
        <div class="flex justify-between items-start mb-4">
            <div>
                <h3 class="font-bold text-slate-900 dark:text-white text-lg line-through decoration-slate-400">Debit card delivery delayed</h3>
                <p class="text-xs text-slate-500 font-mono mt-1">Ticket #TKT-891055</p>
            </div>
            <span class="px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-slate-200 text-slate-600 dark:bg-slate-700 dark:text-slate-400">
                Resolved
            </span>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
