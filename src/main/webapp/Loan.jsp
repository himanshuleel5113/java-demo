<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    String email = (String) session.getAttribute("email");

    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-7xl mx-auto px-4 py-8 page-enter">
    <!-- Page Header -->
    <div class="mb-8 text-center md:text-left">
        <h1 class="text-3xl md:text-4xl font-brand font-bold text-slate-900 dark:text-white">Loan Services</h1>
        <p class="text-slate-500 dark:text-slate-400 mt-2">Achieve your dreams with our tailored financial solutions.</p>
    </div>

    <!-- Pre-approved Offer -->
    <div class="glass-panel border-0 bg-gradient-to-r from-emerald-600 to-emerald-900 rounded-3xl p-8 mb-10 text-white shadow-xl relative overflow-hidden">
        <div class="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl transform translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>
        <div class="relative z-10 flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
            <div>
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-400/20 text-emerald-100 text-xs font-bold uppercase tracking-wider mb-4 border border-emerald-400/30 backdrop-blur-md">
                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-300 animate-pulse"></span> Pre-approved
                </span>
                <h2 class="text-3xl font-brand font-bold mb-2">You're eligible for ₹5,00,000</h2>
                <p class="text-emerald-100 text-lg flex items-center gap-2">
                    <i class="fas fa-check-circle text-emerald-300"></i> Instant personal loan at 10.5% p.a.
                </p>
            </div>
            <button onclick="selectLoan('PERSONAL')" class="px-8 py-4 bg-white text-emerald-700 hover:bg-emerald-50 rounded-xl font-bold transition-colors shadow-lg whitespace-nowrap transform hover:-translate-y-1 duration-300">
                Claim Offer Now
            </button>
        </div>
    </div>

    <!-- Loan Products Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
        <!-- Home Loan -->
        <div onclick="selectLoan('HOME')" id="card-HOME" class="glass-panel p-6 rounded-3xl text-center cursor-pointer border-2 border-transparent hover:border-blue-500 transition-all duration-300 transform hover:-translate-y-1 group">
            <div class="w-16 h-16 rounded-2xl bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-400 flex items-center justify-center text-2xl mx-auto mb-4 group-hover:scale-110 transition-transform">
                <i class="fas fa-home"></i>
            </div>
            <h3 class="text-xl font-bold text-slate-900 dark:text-white">Home Loan</h3>
            <p class="text-3xl font-brand font-bold text-blue-600 dark:text-blue-400 mt-3 mb-1">8.40%</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">p.a. onwards</p>
            <div class="mt-4 pt-4 border-t border-slate-100 dark:border-slate-700/50">
                <span class="text-xs font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">Up to ₹5 Crore</span>
            </div>
        </div>

        <!-- Personal Loan -->
        <div onclick="selectLoan('PERSONAL')" id="card-PERSONAL" class="glass-panel p-6 rounded-3xl text-center cursor-pointer border-2 border-transparent hover:border-emerald-500 transition-all duration-300 transform hover:-translate-y-1 group">
            <div class="w-16 h-16 rounded-2xl bg-emerald-100 dark:bg-emerald-900/40 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-2xl mx-auto mb-4 group-hover:scale-110 transition-transform">
                <i class="fas fa-user"></i>
            </div>
            <h3 class="text-xl font-bold text-slate-900 dark:text-white">Personal</h3>
            <p class="text-3xl font-brand font-bold text-emerald-600 dark:text-emerald-400 mt-3 mb-1">10.50%</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">p.a. onwards</p>
            <div class="mt-4 pt-4 border-t border-slate-100 dark:border-slate-700/50">
                <span class="text-xs font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">Up to ₹15 Lakh</span>
            </div>
        </div>

        <!-- Car Loan -->
        <div onclick="selectLoan('CAR')" id="card-CAR" class="glass-panel p-6 rounded-3xl text-center cursor-pointer border-2 border-transparent hover:border-amber-500 transition-all duration-300 transform hover:-translate-y-1 group">
            <div class="w-16 h-16 rounded-2xl bg-amber-100 dark:bg-amber-900/40 text-amber-600 dark:text-amber-400 flex items-center justify-center text-2xl mx-auto mb-4 group-hover:scale-110 transition-transform">
                <i class="fas fa-car"></i>
            </div>
            <h3 class="text-xl font-bold text-slate-900 dark:text-white">Car Loan</h3>
            <p class="text-3xl font-brand font-bold text-amber-600 dark:text-amber-400 mt-3 mb-1">8.75%</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">p.a. onwards</p>
            <div class="mt-4 pt-4 border-t border-slate-100 dark:border-slate-700/50">
                <span class="text-xs font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">Up to ₹15 Lakh</span>
            </div>
        </div>

        <!-- Education Loan -->
        <div onclick="selectLoan('EDUCATION')" id="card-EDUCATION" class="glass-panel p-6 rounded-3xl text-center cursor-pointer border-2 border-transparent hover:border-purple-500 transition-all duration-300 transform hover:-translate-y-1 group">
            <div class="w-16 h-16 rounded-2xl bg-purple-100 dark:bg-purple-900/40 text-purple-600 dark:text-purple-400 flex items-center justify-center text-2xl mx-auto mb-4 group-hover:scale-110 transition-transform">
                <i class="fas fa-graduation-cap"></i>
            </div>
            <h3 class="text-xl font-bold text-slate-900 dark:text-white">Education</h3>
            <p class="text-3xl font-brand font-bold text-purple-600 dark:text-purple-400 mt-3 mb-1">8.00%</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">p.a. onwards</p>
            <div class="mt-4 pt-4 border-t border-slate-100 dark:border-slate-700/50">
                <span class="text-xs font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">Up to ₹50 Lakh</span>
            </div>
        </div>
    </div>

    <!-- Application Form -->
    <div id="applicationForm" style="display: none;" class="glass-panel rounded-3xl p-8 shadow-xl max-w-4xl mx-auto border-t-4 border-blue-500 transition-all duration-500 origin-top transform scale-y-100">
        <div class="mb-8 border-b border-slate-200 dark:border-slate-700 pb-6">
            <h3 class="text-2xl font-brand font-bold text-slate-900 dark:text-white">Apply for <span id="selectedLoanName" class="text-blue-600 dark:text-blue-400">Loan</span></h3>
            <p class="text-slate-500 dark:text-slate-400 mt-2">Complete the form below and receive conditional approval within minutes.</p>
        </div>

        <form action="<%= request.getContextPath() %>/Loan" method="POST" onsubmit="return validateLoanForm()" class="space-y-6">
            <input type="hidden" name="loanType" id="loanType">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Applicant Name</label>
                    <input type="text" value="<%= firstName %>" class="input-field bg-slate-100 dark:bg-slate-800/80 cursor-not-allowed" readonly>
                </div>
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Email Address</label>
                    <input type="email" value="<%= email %>" class="input-field bg-slate-100 dark:bg-slate-800/80 cursor-not-allowed" readonly>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Loan Amount Required</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">₹</div>
                        <input type="number" name="amount" id="amount" required class="input-field pl-8 font-semibold text-lg" placeholder="0">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Repayment Tenure</label>
                    <div class="relative">
                        <select name="tenure" class="input-field appearance-none cursor-pointer">
                            <option>1 Year</option>
                            <option>2 Years</option>
                            <option>3 Years</option>
                            <option>5 Years</option>
                            <option>10 Years</option>
                            <option>15 Years</option>
                            <option>20 Years</option>
                        </select>
                        <div class="absolute inset-y-0 right-0 pr-4 flex items-center pointer-events-none text-slate-500">
                            <i class="fas fa-chevron-down text-sm"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Purpose of Loan</label>
                <textarea name="purpose" rows="3" class="input-field resize-none" placeholder="Briefly describe what these funds will be used for..."></textarea>
            </div>
            
            <div class="p-4 rounded-xl bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800/30 text-sm text-blue-800 dark:text-blue-300">
                <i class="fas fa-info-circle mr-2"></i> By submitting this application, you consent to AceBank verifying your credit profile.
            </div>

            <button type="submit" class="btn-primary w-full py-4 text-lg flex items-center justify-center gap-2 mt-4 shadow-lg shadow-blue-600/30">
                Submit Application <i class="fas fa-paper-plane text-sm"></i>
            </button>
        </form>
    </div>
</div>

<style>
    .selected-card-HOME { border-color: #3b82f6 !important; background-color: #eff6ff !important; }
    .dark .selected-card-HOME { background-color: rgba(59, 130, 246, 0.1) !important; }
    
    .selected-card-PERSONAL { border-color: #10b981 !important; background-color: #f0fdf4 !important; }
    .dark .selected-card-PERSONAL { background-color: rgba(16, 185, 129, 0.1) !important; }
    
    .selected-card-CAR { border-color: #f59e0b !important; background-color: #fffbeb !important; }
    .dark .selected-card-CAR { background-color: rgba(245, 158, 11, 0.1) !important; }
    
    .selected-card-EDUCATION { border-color: #a855f7 !important; background-color: #faf5ff !important; }
    .dark .selected-card-EDUCATION { background-color: rgba(168, 85, 247, 0.1) !important; }
</style>

<script>
    function selectLoan(type) {
        // Remove selection from all cards
        document.querySelectorAll('[id^="card-"]').forEach(card => {
            card.className = card.className.replace(/selected-card-[A-Z]+/g, '').trim();
        });

        // Add selection to clicked card
        const card = document.getElementById('card-' + type);
        card.classList.add('selected-card-' + type);

        document.getElementById('loanType').value = type;

        const loanNames = {
            'HOME': 'Home Loan',
            'PERSONAL': 'Personal Loan',
            'CAR': 'Car Loan',
            'EDUCATION': 'Education Loan'
        };
        document.getElementById('selectedLoanName').textContent = loanNames[type];

        // Ensure border color of the form matches the loan type
        const formDiv = document.getElementById('applicationForm');
        formDiv.className = formDiv.className.replace(/border-t-(blue|emerald|amber|purple)-500/, '');
        
        if(type === 'HOME') formDiv.classList.add('border-t-blue-500');
        else if(type === 'PERSONAL') formDiv.classList.add('border-t-emerald-500');
        else if(type === 'CAR') formDiv.classList.add('border-t-amber-500');
        else if(type === 'EDUCATION') formDiv.classList.add('border-t-purple-500');

        formDiv.style.display = 'block';
        formDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    function validateLoanForm() {
        const loanType = document.getElementById('loanType').value;
        const amount = document.getElementById('amount').value;

        if(!loanType) {
            if(window.AceBank) AceBank.showToast('Please select a loan type first', 'error');
            else alert('Please select a loan type first');
            return false;
        }
        if(amount < 10000) {
            if(window.AceBank) AceBank.showToast('Minimum loan amount is ₹10,000', 'error');
            else alert('Minimum loan amount is ₹10,000');
            return false;
        }
        return confirm('Submit loan application?');
    }
</script>

<jsp:include page="/includes/footer.jsp" />