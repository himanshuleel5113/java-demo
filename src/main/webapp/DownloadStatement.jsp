<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-2xl mx-auto px-4 py-8 page-enter">
    <div class="mb-8">
        <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Download Statement</h1>
        <p class="text-slate-500 dark:text-slate-400 mt-1">Generate official account statements</p>
    </div>

    <div class="glass-panel rounded-3xl p-8 shadow-xl relative overflow-hidden">
        <div class="absolute top-0 right-0 w-64 h-64 bg-blue-500/10 rounded-full blur-3xl transform translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>
        
        <form class="relative z-10 space-y-6">
            <div>
                <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Select Duration</label>
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
                    <label class="cursor-pointer">
                        <input type="radio" name="duration" class="peer sr-only" checked>
                        <div class="p-3 text-center text-sm font-semibold rounded-xl border-2 border-slate-200 dark:border-slate-700 peer-checked:border-blue-500 peer-checked:bg-blue-50 dark:peer-checked:bg-blue-900/20 peer-checked:text-blue-600 dark:peer-checked:text-blue-400 transition-all">Last 1 Month</div>
                    </label>
                    <label class="cursor-pointer">
                        <input type="radio" name="duration" class="peer sr-only">
                        <div class="p-3 text-center text-sm font-semibold rounded-xl border-2 border-slate-200 dark:border-slate-700 peer-checked:border-blue-500 peer-checked:bg-blue-50 dark:peer-checked:bg-blue-900/20 peer-checked:text-blue-600 dark:peer-checked:text-blue-400 transition-all">Last 3 Months</div>
                    </label>
                    <label class="cursor-pointer">
                        <input type="radio" name="duration" class="peer sr-only">
                        <div class="p-3 text-center text-sm font-semibold rounded-xl border-2 border-slate-200 dark:border-slate-700 peer-checked:border-blue-500 peer-checked:bg-blue-50 dark:peer-checked:bg-blue-900/20 peer-checked:text-blue-600 dark:peer-checked:text-blue-400 transition-all">Last 6 Months</div>
                    </label>
                    <label class="cursor-pointer">
                        <input type="radio" name="duration" class="peer sr-only">
                        <div class="p-3 text-center text-sm font-semibold rounded-xl border-2 border-slate-200 dark:border-slate-700 peer-checked:border-blue-500 peer-checked:bg-blue-50 dark:peer-checked:bg-blue-900/20 peer-checked:text-blue-600 dark:peer-checked:text-blue-400 transition-all">Custom Range</div>
                    </label>
                </div>
            </div>

            <div>
                <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Format</label>
                <div class="flex gap-4">
                    <label class="cursor-pointer flex-1">
                        <input type="radio" name="format" class="peer sr-only" checked>
                        <div class="p-4 flex items-center justify-center gap-2 text-sm font-semibold rounded-xl border-2 border-slate-200 dark:border-slate-700 peer-checked:border-red-500 peer-checked:bg-red-50 dark:peer-checked:bg-red-900/20 peer-checked:text-red-600 dark:peer-checked:text-red-400 transition-all">
                            <i class="fas fa-file-pdf text-lg"></i> PDF Document
                        </div>
                    </label>
                    <label class="cursor-pointer flex-1">
                        <input type="radio" name="format" class="peer sr-only">
                        <div class="p-4 flex items-center justify-center gap-2 text-sm font-semibold rounded-xl border-2 border-slate-200 dark:border-slate-700 peer-checked:border-emerald-500 peer-checked:bg-emerald-50 dark:peer-checked:bg-emerald-900/20 peer-checked:text-emerald-600 dark:peer-checked:text-emerald-400 transition-all">
                            <i class="fas fa-file-excel text-lg"></i> Excel Spreadsheet
                        </div>
                    </label>
                </div>
            </div>

            <div class="pt-4 flex flex-col sm:flex-row gap-4">
                <button type="button" class="flex-1 btn-primary py-4 text-lg flex items-center justify-center gap-2 shadow-lg shadow-blue-600/30">
                    <i class="fas fa-download text-sm"></i> Download Now
                </button>
                <button type="button" class="flex-1 btn-secondary py-4 text-lg flex items-center justify-center gap-2 border border-slate-200 dark:border-slate-700">
                    <i class="fas fa-envelope text-sm"></i> Send to Email
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
