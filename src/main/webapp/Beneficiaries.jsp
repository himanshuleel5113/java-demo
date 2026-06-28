<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.acebank.lite.models.Beneficiary" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    List<Beneficiary> beneficiaries = (List<Beneficiary>) request.getAttribute("beneficiariesList");
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-6xl mx-auto px-4 py-8 page-enter" x-data="{ showAddModal: false }">
    <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Beneficiaries</h1>
            <p class="text-slate-500 dark:text-slate-400 mt-1">Manage your saved accounts for quick transfers</p>
        </div>
        <button @click="showAddModal = true" class="btn-primary py-2.5 px-5 flex items-center gap-2">
            <i class="fas fa-plus"></i> Add Beneficiary
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

    <!-- Search and Filter -->
    <div class="glass-panel rounded-2xl p-4 mb-8 flex flex-col sm:flex-row gap-4 items-center shadow-sm">
        <div class="relative flex-1 w-full">
            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                <i class="fas fa-search"></i>
            </div>
            <input type="text" class="input-field pl-11" placeholder="Search by name, account, or bank...">
        </div>
        <div class="flex gap-2 w-full sm:w-auto">
            <select class="input-field text-sm">
                <option>All Types</option>
                <option>Same Bank</option>
                <option>Other Banks</option>
            </select>
        </div>
    </div>

    <!-- Beneficiaries Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        
        <% if (beneficiaries != null && !beneficiaries.isEmpty()) {
            for (Beneficiary b : beneficiaries) { 
                boolean isSameBank = "AceBank".equalsIgnoreCase(b.bankName());
        %>
        <!-- Beneficiary Card -->
        <div class="glass-panel rounded-3xl p-6 shadow-md border border-slate-200 dark:border-slate-800 hover:border-<%= isSameBank ? "blue" : "emerald" %>-500 dark:hover:border-<%= isSameBank ? "blue" : "emerald" %>-500 transition-colors group relative overflow-hidden">
            <div class="absolute top-4 right-4 flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <form action="<%= request.getContextPath() %>/Beneficiaries" method="POST" class="inline" onsubmit="return confirm('Remove beneficiary <%= b.nickname() %>?');">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= b.id() %>">
                    <button type="submit" class="w-8 h-8 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-500 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/30 flex items-center justify-center transition-colors">
                        <i class="fas fa-trash text-xs"></i>
                    </button>
                </form>
            </div>

            <div class="flex items-center gap-4 mb-4">
                <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-<%= isSameBank ? "indigo" : "emerald" %>-100 to-<%= isSameBank ? "purple" : "teal" %>-100 dark:from-<%= isSameBank ? "indigo" : "emerald" %>-900/40 dark:to-<%= isSameBank ? "purple" : "teal" %>-900/40 text-<%= isSameBank ? "indigo" : "emerald" %>-600 dark:text-<%= isSameBank ? "indigo" : "emerald" %>-400 flex items-center justify-center text-xl font-bold font-brand shadow-sm">
                    <%= b.nickname().substring(0, 1).toUpperCase() %>
                </div>
                <div>
                    <h3 class="font-bold text-slate-900 dark:text-white text-lg"><%= b.nickname() %></h3>
                    <span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-<%= isSameBank ? "slate" : "orange" %>-100 dark:bg-<%= isSameBank ? "slate" : "orange" %>-800 text-<%= isSameBank ? "slate" : "orange" %>-500">
                        <%= isSameBank ? "Same Bank" : "Other Bank" %>
                    </span>
                </div>
            </div>

            <div class="space-y-2 mb-6">
                <div class="flex items-center justify-between text-sm">
                    <span class="text-slate-500 dark:text-slate-400">Account No.</span>
                    <span class="font-mono font-medium text-slate-900 dark:text-white"><%= b.beneficiaryAccount() %></span>
                </div>
                <div class="flex items-center justify-between text-sm">
                    <span class="text-slate-500 dark:text-slate-400"><%= isSameBank ? "Bank" : "IFSC Code" %></span>
                    <span class="font-medium text-slate-900 dark:text-white"><%= isSameBank ? b.bankName() : b.ifscCode() %></span>
                </div>
            </div>

            <a href="<%= request.getContextPath() %>/Transfer.jsp?to=<%= b.beneficiaryAccount() %>" class="w-full btn-secondary py-2.5 text-sm flex items-center justify-center gap-2 hover:bg-<%= isSameBank ? "blue" : "emerald" %>-600 hover:text-white hover:border-<%= isSameBank ? "blue" : "emerald" %>-600 transition-colors">
                Transfer Money <i class="fas fa-paper-plane text-[10px]"></i>
            </a>
        </div>
        <% 
            }
        } %>
        
        <!-- Add New Placeholder -->
        <div @click="showAddModal = true" class="glass-panel rounded-3xl p-6 shadow-sm border-2 border-dashed border-slate-300 dark:border-slate-700 hover:border-blue-500 dark:hover:border-blue-500 hover:bg-slate-50 dark:hover:bg-slate-800/30 transition-all flex flex-col items-center justify-center cursor-pointer min-h-[250px]">
            <div class="w-16 h-16 rounded-full bg-blue-50 dark:bg-blue-900/20 text-blue-500 flex items-center justify-center text-2xl mb-4">
                <i class="fas fa-plus"></i>
            </div>
            <h3 class="font-bold text-slate-700 dark:text-slate-300">Add New Beneficiary</h3>
            <p class="text-sm text-slate-500 mt-1 text-center">Add accounts for quick NEFT/RTGS transfers</p>
        </div>
    </div>

    <!-- Add Beneficiary Modal -->
    <div x-show="showAddModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm" style="display: none;">
        <div @click.away="showAddModal = false" class="glass-panel rounded-3xl w-full max-w-md p-6 shadow-2xl relative">
            <div class="flex justify-between items-center mb-6">
                <h3 class="text-xl font-bold text-slate-900 dark:text-white">Add Beneficiary</h3>
                <button @click="showAddModal = false" class="w-8 h-8 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-500 hover:text-red-500 flex items-center justify-center transition-colors">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <form action="<%= request.getContextPath() %>/Beneficiaries" method="POST" class="space-y-4">
                <input type="hidden" name="action" value="add">
                
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1">Account Number</label>
                    <input type="text" name="accountNumber" required class="input-field py-2" placeholder="Enter Account Number">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1">Beneficiary Name</label>
                    <input type="text" name="name" required class="input-field py-2" placeholder="Full Name as per Bank">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1">Nickname (Optional)</label>
                    <input type="text" name="nickname" class="input-field py-2" placeholder="e.g. Landlord">
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1">Bank Name</label>
                        <input type="text" name="bankName" value="AceBank" required class="input-field py-2">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1">IFSC Code</label>
                        <input type="text" name="ifscCode" value="ACEB0000001" required class="input-field py-2">
                    </div>
                </div>

                <div class="pt-4 flex gap-3">
                    <button type="button" @click="showAddModal = false" class="flex-1 btn-secondary py-3 text-sm">Cancel</button>
                    <button type="submit" class="flex-1 btn-primary py-3 text-sm flex justify-center items-center gap-2">Save Beneficiary</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
