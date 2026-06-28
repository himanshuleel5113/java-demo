<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.acebank.lite.models.RecurringDeposit" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    List<RecurringDeposit> rdList = (List<RecurringDeposit>) request.getAttribute("rdList");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy");
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-6xl mx-auto px-4 py-8 page-enter" x-data="{ showOpenModal: false, amount: 5000, tenure: 12, rate: 7.00, 
    calculateMaturity() {
        const totalDeposited = this.amount * this.tenure;
        return Math.round(totalDeposited + (totalDeposited * (this.rate/100) * (this.tenure/12.0) / 2));
    }
}">
    <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Recurring Deposits</h1>
            <p class="text-slate-500 dark:text-slate-400 mt-1">Build wealth systematically with monthly savings</p>
        </div>
        <button @click="showOpenModal = true" class="btn-primary py-2.5 px-5 flex items-center gap-2 bg-purple-600 hover:bg-purple-700 shadow-purple-600/30 border-purple-600">
            <i class="fas fa-plus"></i> Start New RD
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

    <% if (rdList != null && !rdList.isEmpty()) { %>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <% for (RecurringDeposit rd : rdList) { %>
            <!-- Active RD Card -->
            <div class="glass-panel rounded-3xl p-6 shadow-md border-t-4 border-purple-500 relative overflow-hidden">
                <div class="flex justify-between items-start mb-6">
                    <div>
                        <h3 class="font-bold text-slate-900 dark:text-white text-lg">RD Goal</h3>
                        <p class="text-xs text-slate-500 font-mono mt-1">RD-<%= String.format("%08d", rd.id()) %></p>
                    </div>
                    <span class="px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400">
                        <%= rd.status() %>
                    </span>
                </div>

                <div class="mb-6">
                    <p class="text-xs uppercase tracking-wider text-slate-500 font-semibold mb-1">Monthly Deposit</p>
                    <p class="text-3xl font-brand font-bold text-slate-900 dark:text-white">₹ <%= String.format("%,.0f", rd.monthlyAmount()) %></p>
                </div>

                <div class="grid grid-cols-2 gap-4 mb-6 p-4 rounded-xl bg-slate-50 dark:bg-slate-800/50">
                    <div>
                        <p class="text-[10px] uppercase tracking-wider text-slate-500 font-semibold mb-1">Total Deposited</p>
                        <p class="font-semibold text-purple-600 dark:text-purple-400">₹ <%= String.format("%,.0f", rd.totalDeposited()) %></p>
                    </div>
                    <div>
                        <p class="text-[10px] uppercase tracking-wider text-slate-500 font-semibold mb-1">Next Debit</p>
                        <p class="font-semibold text-slate-700 dark:text-slate-300"><%= rd.nextDebitDate().format(dtf) %></p>
                    </div>
                    <div class="col-span-2">
                        <p class="text-[10px] uppercase tracking-wider text-slate-500 font-semibold mb-1">Expected Maturity</p>
                        <p class="font-semibold text-slate-900 dark:text-white text-lg">₹ <%= String.format("%,.0f", rd.maturityAmount()) %></p>
                    </div>
                </div>
            </div>
        <% } %>
        </div>
    <% } else { %>
        <!-- Create RD CTA if no active RD -->
        <div class="glass-panel rounded-3xl p-8 shadow-xl text-center flex flex-col items-center justify-center min-h-[400px]">
            <div class="w-24 h-24 rounded-full bg-purple-50 dark:bg-purple-900/20 text-purple-600 flex items-center justify-center text-4xl mb-6">
                <i class="fas fa-coins"></i>
            </div>
            <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-2">You don't have any active RDs</h2>
            <p class="text-slate-500 dark:text-slate-400 max-w-md mb-8">Start saving as little as ₹500 every month and earn up to 7.00% p.a. on your deposits.</p>
            
            <button @click="showOpenModal = true" class="px-8 py-4 bg-purple-600 hover:bg-purple-700 text-white rounded-xl font-bold transition-colors shadow-lg shadow-purple-600/30 flex items-center gap-2">
                Calculate RD Returns <i class="fas fa-calculator text-sm"></i>
            </button>
        </div>
    <% } %>

    <!-- Open RD Modal -->
    <div x-show="showOpenModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm" style="display: none;">
        <div @click.away="showOpenModal = false" class="glass-panel rounded-3xl w-full max-w-lg p-8 shadow-2xl relative border-purple-500/30">
            <div class="flex justify-between items-center mb-6 border-b border-slate-200 dark:border-slate-700/50 pb-4">
                <h3 class="text-xl font-bold text-slate-900 dark:text-white">Start Recurring Deposit</h3>
                <button @click="showOpenModal = false" class="w-8 h-8 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-500 hover:text-red-500 flex items-center justify-center transition-colors">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <form action="<%= request.getContextPath() %>/RecurringDeposits" method="POST" class="space-y-6">
                <input type="hidden" name="action" value="open">
                
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Monthly Installment</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 font-semibold">₹</div>
                        <input type="number" name="monthlyAmount" x-model.number="amount" min="500" required class="input-field pl-8 font-semibold text-lg focus:border-purple-500 focus:ring-purple-500/20">
                    </div>
                    <p class="text-[10px] text-slate-500 mt-1">Minimum installment is ₹500/month</p>
                </div>
                
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Tenure (Months)</label>
                    <input type="range" name="tenure" x-model.number="tenure" min="6" max="60" step="1" class="w-full h-2 bg-slate-200 rounded-lg appearance-none cursor-pointer accent-purple-600">
                    <div class="flex justify-between mt-2 text-sm font-bold text-slate-700 dark:text-slate-300">
                        <span x-text="tenure + ' Months'"></span>
                    </div>
                </div>

                <!-- Live Preview -->
                <div class="bg-purple-50 dark:bg-purple-900/20 rounded-2xl p-5 border border-purple-200 dark:border-purple-800/30">
                    <div class="flex justify-between items-end mb-4">
                        <div>
                            <p class="text-[10px] uppercase tracking-wider text-purple-600 dark:text-purple-400 font-bold mb-1">Interest Rate</p>
                            <p class="text-xl font-bold text-slate-900 dark:text-white"><span x-text="rate.toFixed(2)"></span>% <span class="text-xs text-slate-500 font-normal">p.a.</span></p>
                        </div>
                        <div class="text-right">
                            <p class="text-[10px] uppercase tracking-wider text-purple-600 dark:text-purple-400 font-bold mb-1">Maturity Amount</p>
                            <p class="text-2xl font-bold text-purple-600 dark:text-purple-400 font-brand tracking-tight">₹ <span x-text="calculateMaturity().toLocaleString('en-IN')"></span></p>
                        </div>
                    </div>
                </div>

                <div class="pt-2 flex gap-3">
                    <button type="button" @click="showOpenModal = false" class="flex-1 btn-secondary py-3 text-sm">Cancel</button>
                    <button type="submit" class="flex-1 bg-purple-600 hover:bg-purple-700 text-white rounded-xl font-bold py-3 text-sm flex justify-center items-center gap-2 shadow-lg shadow-purple-600/30 transition-all border border-purple-600">Confirm RD</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
