<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.acebank.lite.models.BillPayment" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    List<BillPayment> billsList = (List<BillPayment>) request.getAttribute("billsList");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-6xl mx-auto px-4 py-8 page-enter" x-data="{ selectedCategory: 'Electricity', amount: 0, 
    showPaymentModal: false, billerName: '', consumerNumber: '',
    fetchBill() {
        if(!this.billerName || !this.consumerNumber) {
            alert('Please enter bill details');
            return;
        }
        // Mock fetching bill
        this.amount = Math.floor(Math.random() * 3000) + 500;
        this.showPaymentModal = true;
    }
}">
    <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Bill Payments</h1>
            <p class="text-slate-500 dark:text-slate-400 mt-1">Pay your utility bills instantly</p>
        </div>
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

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-12">
        <div class="lg:col-span-2 space-y-8">
            <!-- Categories -->
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                <div @click="selectedCategory = 'Mobile'" :class="selectedCategory === 'Mobile' ? 'border-blue-500 bg-blue-50/50 dark:bg-blue-900/10' : 'border-transparent bg-white dark:bg-slate-800'" class="glass-panel p-4 rounded-2xl flex flex-col items-center justify-center gap-3 cursor-pointer hover:border-blue-500 transition-colors border-2">
                    <div class="w-12 h-12 rounded-full bg-blue-50 dark:bg-blue-900/30 text-blue-500 flex items-center justify-center text-xl">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <span class="text-sm font-semibold" :class="selectedCategory === 'Mobile' ? 'text-blue-700 dark:text-blue-400' : 'text-slate-700 dark:text-slate-300'">Mobile</span>
                </div>
                <div @click="selectedCategory = 'Electricity'" :class="selectedCategory === 'Electricity' ? 'border-yellow-500 bg-yellow-50/50 dark:bg-yellow-900/10' : 'border-transparent bg-white dark:bg-slate-800'" class="glass-panel p-4 rounded-2xl flex flex-col items-center justify-center gap-3 cursor-pointer hover:border-yellow-500 transition-colors border-2">
                    <div class="w-12 h-12 rounded-full bg-yellow-100 dark:bg-yellow-900/40 text-yellow-600 flex items-center justify-center text-xl">
                        <i class="fas fa-lightbulb"></i>
                    </div>
                    <span class="text-sm font-semibold" :class="selectedCategory === 'Electricity' ? 'text-yellow-700 dark:text-yellow-400' : 'text-slate-700 dark:text-slate-300'">Electricity</span>
                </div>
                <div @click="selectedCategory = 'Water'" :class="selectedCategory === 'Water' ? 'border-cyan-500 bg-cyan-50/50 dark:bg-cyan-900/10' : 'border-transparent bg-white dark:bg-slate-800'" class="glass-panel p-4 rounded-2xl flex flex-col items-center justify-center gap-3 cursor-pointer hover:border-cyan-500 transition-colors border-2">
                    <div class="w-12 h-12 rounded-full bg-cyan-50 dark:bg-cyan-900/30 text-cyan-500 flex items-center justify-center text-xl">
                        <i class="fas fa-tint"></i>
                    </div>
                    <span class="text-sm font-semibold" :class="selectedCategory === 'Water' ? 'text-cyan-700 dark:text-cyan-400' : 'text-slate-700 dark:text-slate-300'">Water</span>
                </div>
                <div @click="selectedCategory = 'Gas'" :class="selectedCategory === 'Gas' ? 'border-red-500 bg-red-50/50 dark:bg-red-900/10' : 'border-transparent bg-white dark:bg-slate-800'" class="glass-panel p-4 rounded-2xl flex flex-col items-center justify-center gap-3 cursor-pointer hover:border-red-500 transition-colors border-2">
                    <div class="w-12 h-12 rounded-full bg-red-50 dark:bg-red-900/30 text-red-500 flex items-center justify-center text-xl">
                        <i class="fas fa-fire"></i>
                    </div>
                    <span class="text-sm font-semibold" :class="selectedCategory === 'Gas' ? 'text-red-700 dark:text-red-400' : 'text-slate-700 dark:text-slate-300'">Gas</span>
                </div>
                <div @click="selectedCategory = 'Broadband'" :class="selectedCategory === 'Broadband' ? 'border-purple-500 bg-purple-50/50 dark:bg-purple-900/10' : 'border-transparent bg-white dark:bg-slate-800'" class="glass-panel p-4 rounded-2xl flex flex-col items-center justify-center gap-3 cursor-pointer hover:border-purple-500 transition-colors border-2">
                    <div class="w-12 h-12 rounded-full bg-purple-50 dark:bg-purple-900/30 text-purple-500 flex items-center justify-center text-xl">
                        <i class="fas fa-wifi"></i>
                    </div>
                    <span class="text-sm font-semibold" :class="selectedCategory === 'Broadband' ? 'text-purple-700 dark:text-purple-400' : 'text-slate-700 dark:text-slate-300'">Broadband</span>
                </div>
                <div @click="selectedCategory = 'Credit Card'" :class="selectedCategory === 'Credit Card' ? 'border-emerald-500 bg-emerald-50/50 dark:bg-emerald-900/10' : 'border-transparent bg-white dark:bg-slate-800'" class="glass-panel p-4 rounded-2xl flex flex-col items-center justify-center gap-3 cursor-pointer hover:border-emerald-500 transition-colors border-2">
                    <div class="w-12 h-12 rounded-full bg-emerald-50 dark:bg-emerald-900/30 text-emerald-500 flex items-center justify-center text-xl">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <span class="text-sm font-semibold" :class="selectedCategory === 'Credit Card' ? 'text-emerald-700 dark:text-emerald-400' : 'text-slate-700 dark:text-slate-300'">Credit Card</span>
                </div>
            </div>
            
            <!-- Selected Category Form -->
            <div class="glass-panel rounded-3xl p-8 shadow-xl relative overflow-hidden border-t-4 border-slate-300 dark:border-slate-600">
                <div class="absolute top-0 right-0 w-64 h-64 bg-slate-500/10 rounded-full blur-3xl transform translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>

                <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6 border-b border-slate-200 dark:border-slate-700/50 pb-4">Pay <span x-text="selectedCategory"></span> Bill</h3>

                <form class="space-y-6" @submit.prevent="fetchBill">
                    <div>
                        <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Select Biller / Provider</label>
                        <select class="input-field" x-model="billerName" required>
                            <option value="">Select Provider</option>
                            <option value="Provider A">Provider A</option>
                            <option value="Provider B">Provider B</option>
                            <option value="Provider C">Provider C</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Consumer / Account Number</label>
                        <input type="text" x-model="consumerNumber" class="input-field" placeholder="Enter your consumer number" required>
                    </div>

                    <button type="submit" class="w-full btn-primary py-4 text-lg flex items-center justify-center gap-2 shadow-lg shadow-blue-600/30">
                        Fetch Bill <i class="fas fa-file-invoice-dollar text-sm"></i>
                    </button>
                </form>
            </div>
        </div>

        <!-- Recent Payments -->
        <div>
            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6">Recent Payments</h3>
            <div class="space-y-4">
                <% if (billsList != null && !billsList.isEmpty()) { 
                    for (BillPayment bill : billsList) {
                        String iconClass = "fa-file-invoice-dollar";
                        String colorClass = "text-blue-500 bg-blue-100 dark:bg-blue-900/40";
                        
                        if ("Electricity".equals(bill.billerCategory())) { iconClass = "fa-lightbulb"; colorClass = "text-yellow-600 bg-yellow-100 dark:bg-yellow-900/40"; }
                        else if ("Mobile".equals(bill.billerCategory())) { iconClass = "fa-mobile-alt"; colorClass = "text-blue-500 bg-blue-100 dark:bg-blue-900/40"; }
                        else if ("Water".equals(bill.billerCategory())) { iconClass = "fa-tint"; colorClass = "text-cyan-500 bg-cyan-100 dark:bg-cyan-900/40"; }
                        else if ("Gas".equals(bill.billerCategory())) { iconClass = "fa-fire"; colorClass = "text-red-500 bg-red-100 dark:bg-red-900/40"; }
                        else if ("Broadband".equals(bill.billerCategory())) { iconClass = "fa-wifi"; colorClass = "text-purple-500 bg-purple-100 dark:bg-purple-900/40"; }
                        else if ("Credit Card".equals(bill.billerCategory())) { iconClass = "fa-credit-card"; colorClass = "text-emerald-500 bg-emerald-100 dark:bg-emerald-900/40"; }
                %>
                <div class="glass-panel p-4 rounded-2xl flex items-center gap-4">
                    <div class="w-12 h-12 rounded-xl flex items-center justify-center <%= colorClass %>">
                        <i class="fas <%= iconClass %>"></i>
                    </div>
                    <div class="flex-1">
                        <p class="font-bold text-slate-900 dark:text-white"><%= bill.billerName() %></p>
                        <p class="text-xs text-slate-500"><%= bill.createdAt().format(dtf) %></p>
                    </div>
                    <div class="text-right">
                        <p class="font-bold text-slate-900 dark:text-white">₹ <%= String.format("%,.2f", bill.amount()) %></p>
                        <p class="text-[10px] font-bold uppercase text-emerald-500">SUCCESS</p>
                    </div>
                </div>
                <%  }
                } else { %>
                    <p class="text-slate-500 text-sm">No recent payments found.</p>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Payment Confirmation Modal -->
    <div x-show="showPaymentModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm" style="display: none;">
        <div @click.away="showPaymentModal = false" class="glass-panel rounded-3xl w-full max-w-md p-8 shadow-2xl relative">
            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6 border-b border-slate-200 dark:border-slate-700/50 pb-4">Confirm Payment</h3>

            <form action="<%= request.getContextPath() %>/BillPayments" method="POST" class="space-y-6">
                <input type="hidden" name="action" value="pay">
                <input type="hidden" name="category" x-model="selectedCategory">
                <input type="hidden" name="billerName" x-model="billerName">
                <input type="hidden" name="consumerNumber" x-model="consumerNumber">
                <input type="hidden" name="amount" x-model="amount">
                
                <div class="bg-slate-50 dark:bg-slate-800/50 rounded-2xl p-5 border border-slate-200 dark:border-slate-700">
                    <div class="flex justify-between items-end mb-4">
                        <div>
                            <p class="text-xs text-slate-500 font-semibold mb-1" x-text="billerName"></p>
                            <p class="font-bold text-slate-900 dark:text-white" x-text="'A/C: ' + consumerNumber"></p>
                        </div>
                        <div class="text-right">
                            <p class="text-xs text-slate-500 font-semibold mb-1">Due Amount</p>
                            <p class="text-2xl font-bold text-slate-900 dark:text-white font-brand tracking-tight">₹ <span x-text="amount"></span></p>
                        </div>
                    </div>
                </div>

                <div class="pt-2 flex gap-3">
                    <button type="button" @click="showPaymentModal = false" class="flex-1 btn-secondary py-3 text-sm">Cancel</button>
                    <button type="submit" class="flex-1 btn-primary py-3 text-sm flex justify-center items-center gap-2">Pay Now</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
