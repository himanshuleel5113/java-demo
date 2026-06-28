<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.acebank.lite.models.FixedDeposit" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    List<FixedDeposit> fdList = (List<FixedDeposit>) request.getAttribute("fdList");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy");
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-6xl mx-auto px-4 py-8 page-enter" x-data="{ showOpenModal: false, amount: 100000, tenure: 12, rate: 7.30, 
    calculateMaturity() {
        const ratePerQuarter = (this.rate / 100) / 4;
        const quarters = this.tenure / 3;
        return Math.round(this.amount * Math.pow(1 + ratePerQuarter, quarters));
    },
    updateRate() {
        if(this.tenure < 12) this.rate = 7.10;
        else if(this.tenure < 36) this.rate = 7.30;
        else this.rate = 7.50;
    }
}">
    <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Fixed Deposits</h1>
            <p class="text-slate-500 dark:text-slate-400 mt-1">Grow your savings with guaranteed returns</p>
        </div>
        <button @click="showOpenModal = true" class="btn-primary py-2.5 px-5 flex items-center gap-2">
            <i class="fas fa-plus"></i> Open New FD
        </button>
    </div>

    <% if(session.getAttribute("successMessage") != null) { %>
        <div class="mb-6 p-4 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800/30 flex items-start gap-3">
            <i class="fas fa-check-circle text-emerald-500 mt-0.5"></i>
            <p class="text-sm font-medium text-emerald-700 dark:text-emerald-400"><%= session.getAttribute("successMessage") %></p>
        </div>
        <% session.removeAttribute("successMessage"); %>
    <% } %>

    <% if(session.getAttribute("errorMessage") != null) { %>
        <div class="mb-6 p-4 rounded-xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800/30 flex items-start gap-3">
            <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
            <p class="text-sm font-medium text-red-700 dark:text-red-400"><%= session.getAttribute("errorMessage") %></p>
        </div>
        <% session.removeAttribute("errorMessage"); %>
    <% } %>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        
        <% if (fdList != null && !fdList.isEmpty()) {
            for (FixedDeposit fd : fdList) {
        %>
        <!-- Active FD Card -->
        <div class="glass-panel rounded-3xl p-6 shadow-md border-t-4 border-emerald-500 relative overflow-hidden">
            <div class="flex justify-between items-start mb-6">
                <div>
                    <h3 class="font-bold text-slate-900 dark:text-white text-lg">FD Investment</h3>
                    <p class="text-xs text-slate-500 font-mono mt-1">FD-<%= String.format("%08d", fd.id()) %></p>
                </div>
                <span class="px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400">
                    <%= fd.status() %>
                </span>
            </div>

            <div class="mb-6">
                <p class="text-xs uppercase tracking-wider text-slate-500 font-semibold mb-1">Principal Amount</p>
                <p class="text-3xl font-brand font-bold text-slate-900 dark:text-white">₹ <%= String.format("%,.0f", fd.amount()) %></p>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-6 p-4 rounded-xl bg-slate-50 dark:bg-slate-800/50">
                <div>
                    <p class="text-[10px] uppercase tracking-wider text-slate-500 font-semibold mb-1">Interest Rate</p>
                    <p class="font-semibold text-emerald-600 dark:text-emerald-400"><%= String.format("%.2f", fd.interestRate()) %>% p.a.</p>
                </div>
                <div>
                    <p class="text-[10px] uppercase tracking-wider text-slate-500 font-semibold mb-1">Maturity Date</p>
                    <p class="font-semibold text-slate-700 dark:text-slate-300"><%= fd.maturityDate().format(dtf) %></p>
                </div>
                <div class="col-span-2">
                    <p class="text-[10px] uppercase tracking-wider text-slate-500 font-semibold mb-1">Maturity Amount</p>
                    <p class="font-semibold text-slate-900 dark:text-white text-lg">₹ <%= String.format("%,.0f", fd.maturityAmount()) %></p>
                </div>
            </div>
            
            <button class="w-full btn-secondary py-2 text-sm flex justify-center items-center gap-2">
                Download Receipt <i class="fas fa-download"></i>
            </button>
        </div>
        <% 
            }
        } %>

        <!-- Create FD CTA -->
        <div @click="showOpenModal = true" class="glass-panel rounded-3xl p-6 shadow-sm border-2 border-dashed border-slate-300 dark:border-slate-700 hover:border-emerald-500 dark:hover:border-emerald-500 transition-all flex flex-col items-center justify-center cursor-pointer min-h-[350px] group">
            <div class="w-16 h-16 rounded-full bg-emerald-50 dark:bg-emerald-900/20 text-emerald-500 flex items-center justify-center text-2xl mb-4 group-hover:scale-110 transition-transform">
                <i class="fas fa-piggy-bank"></i>
            </div>
            <h3 class="font-bold text-slate-700 dark:text-slate-300">Open Fixed Deposit</h3>
            <p class="text-sm text-slate-500 mt-1 text-center max-w-[200px]">Earn up to 7.50% p.a. on your savings with flexible tenures.</p>
        </div>
    </div>

    <!-- Open FD Modal -->
    <div x-show="showOpenModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm" style="display: none;">
        <div @click.away="showOpenModal = false" class="glass-panel rounded-3xl w-full max-w-lg p-8 shadow-2xl relative">
            <div class="flex justify-between items-center mb-6 border-b border-slate-200 dark:border-slate-700/50 pb-4">
                <h3 class="text-xl font-bold text-slate-900 dark:text-white">Open New Fixed Deposit</h3>
                <button @click="showOpenModal = false" class="w-8 h-8 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-500 hover:text-red-500 flex items-center justify-center transition-colors">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <form action="<%= request.getContextPath() %>/FixedDeposits" method="POST" class="space-y-6">
                <input type="hidden" name="action" value="open">
                
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Deposit Amount</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 font-semibold">₹</div>
                        <input type="number" name="amount" x-model.number="amount" min="1000" required class="input-field pl-8 font-semibold text-lg">
                    </div>
                    <p class="text-[10px] text-slate-500 mt-1">Minimum amount is ₹1,000</p>
                </div>
                
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Tenure (Months)</label>
                    <input type="range" name="tenure" x-model.number="tenure" @input="updateRate()" min="6" max="120" step="1" class="w-full h-2 bg-slate-200 rounded-lg appearance-none cursor-pointer accent-emerald-600">
                    <div class="flex justify-between mt-2 text-sm font-bold text-slate-700 dark:text-slate-300">
                        <span x-text="tenure + ' Months'"></span>
                    </div>
                </div>

                <!-- Live Preview -->
                <div class="bg-emerald-50 dark:bg-emerald-900/20 rounded-2xl p-5 border border-emerald-200 dark:border-emerald-800/30">
                    <div class="flex justify-between items-end mb-4">
                        <div>
                            <p class="text-[10px] uppercase tracking-wider text-emerald-600 dark:text-emerald-400 font-bold mb-1">Applicable Rate</p>
                            <p class="text-xl font-bold text-slate-900 dark:text-white"><span x-text="rate.toFixed(2)"></span>% <span class="text-xs text-slate-500 font-normal">p.a.</span></p>
                        </div>
                        <div class="text-right">
                            <p class="text-[10px] uppercase tracking-wider text-emerald-600 dark:text-emerald-400 font-bold mb-1">Maturity Amount</p>
                            <p class="text-2xl font-bold text-emerald-600 dark:text-emerald-400 font-brand tracking-tight">₹ <span x-text="calculateMaturity().toLocaleString('en-IN')"></span></p>
                        </div>
                    </div>
                </div>

                <div class="pt-2 flex gap-3">
                    <button type="button" @click="showOpenModal = false" class="flex-1 btn-secondary py-3 text-sm">Cancel</button>
                    <button type="submit" class="flex-1 btn-primary py-3 text-sm flex justify-center items-center gap-2">Open FD</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
