<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-4xl mx-auto px-4 py-8 page-enter">
    <div class="mb-8">
        <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Interest Calculator</h1>
        <p class="text-slate-500 dark:text-slate-400 mt-1">Plan your investments and loans with precision</p>
    </div>

    <!-- Calculator Type Tabs -->
    <div class="flex gap-2 mb-8 bg-slate-100 dark:bg-slate-800/50 p-1 rounded-2xl w-max">
        <button onclick="switchTab('fd')" id="tab-fd" class="px-6 py-2.5 rounded-xl font-semibold text-sm transition-all bg-white dark:bg-slate-700 text-blue-600 dark:text-blue-400 shadow-sm">
            Fixed Deposit
        </button>
        <button onclick="switchTab('loan')" id="tab-loan" class="px-6 py-2.5 rounded-xl font-semibold text-sm transition-all text-slate-500 hover:text-slate-700 dark:hover:text-slate-300">
            Loan EMI
        </button>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <!-- Input Section -->
        <div class="glass-panel rounded-3xl p-8 shadow-xl">
            <!-- FD Form -->
            <form id="form-fd" class="space-y-6">
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Deposit Amount</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">₹</div>
                        <input type="number" id="fdAmount" value="100000" class="input-field pl-8 font-semibold text-lg" oninput="calculateFD()">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Interest Rate (% p.a.)</label>
                    <div class="relative">
                        <input type="number" id="fdRate" value="6.5" step="0.1" class="input-field pr-8 font-semibold text-lg" oninput="calculateFD()">
                        <div class="absolute inset-y-0 right-0 pr-4 flex items-center pointer-events-none text-slate-400">%</div>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Tenure (Years)</label>
                    <input type="range" id="fdTenure" min="1" max="10" value="5" class="w-full h-2 bg-slate-200 rounded-lg appearance-none cursor-pointer accent-blue-600" oninput="document.getElementById('fdTenureVal').innerText=this.value+' Years'; calculateFD()">
                    <div class="flex justify-between mt-2 text-xs font-semibold text-slate-500">
                        <span>1 Year</span>
                        <span id="fdTenureVal" class="text-blue-600 dark:text-blue-400">5 Years</span>
                        <span>10 Years</span>
                    </div>
                </div>
            </form>

            <!-- Loan Form -->
            <form id="form-loan" class="space-y-6 hidden">
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Loan Amount</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">₹</div>
                        <input type="number" id="loanAmount" value="500000" class="input-field pl-8 font-semibold text-lg" oninput="calculateEMI()">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Interest Rate (% p.a.)</label>
                    <div class="relative">
                        <input type="number" id="loanRate" value="8.5" step="0.1" class="input-field pr-8 font-semibold text-lg" oninput="calculateEMI()">
                        <div class="absolute inset-y-0 right-0 pr-4 flex items-center pointer-events-none text-slate-400">%</div>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Tenure (Years)</label>
                    <input type="range" id="loanTenure" min="1" max="30" value="10" class="w-full h-2 bg-slate-200 rounded-lg appearance-none cursor-pointer accent-emerald-600" oninput="document.getElementById('loanTenureVal').innerText=this.value+' Years'; calculateEMI()">
                    <div class="flex justify-between mt-2 text-xs font-semibold text-slate-500">
                        <span>1 Year</span>
                        <span id="loanTenureVal" class="text-emerald-600 dark:text-emerald-400">10 Years</span>
                        <span>30 Years</span>
                    </div>
                </div>
            </form>
        </div>

        <!-- Results Section -->
        <div class="glass-panel rounded-3xl p-8 shadow-xl bg-gradient-to-br from-blue-600 to-indigo-800 text-white relative overflow-hidden" id="result-container">
            <div class="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl transform translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>
            
            <!-- FD Results -->
            <div id="result-fd" class="relative z-10 flex flex-col h-full justify-center">
                <p class="text-blue-200 font-semibold uppercase tracking-wider text-sm mb-2">Maturity Amount</p>
                <h2 class="text-5xl font-brand font-bold mb-8" id="fdMaturity">₹ 1,38,041</h2>
                
                <div class="space-y-4">
                    <div class="flex justify-between items-center pb-4 border-b border-white/20">
                        <span class="text-blue-100">Principal Amount</span>
                        <span class="font-semibold text-lg" id="fdPrincipalDisplay">₹ 1,00,000</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-blue-100">Total Interest Earned</span>
                        <span class="font-semibold text-lg text-emerald-300" id="fdInterestDisplay">+ ₹ 38,041</span>
                    </div>
                </div>
            </div>

            <!-- Loan Results -->
            <div id="result-loan" class="relative z-10 flex flex-col h-full justify-center hidden">
                <p class="text-emerald-200 font-semibold uppercase tracking-wider text-sm mb-2">Monthly EMI</p>
                <h2 class="text-5xl font-brand font-bold mb-8 text-emerald-100" id="loanEMI">₹ 6,199</h2>
                
                <div class="space-y-4">
                    <div class="flex justify-between items-center pb-4 border-b border-white/20">
                        <span class="text-emerald-100/80">Principal Amount</span>
                        <span class="font-semibold text-lg" id="loanPrincipalDisplay">₹ 5,00,000</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-emerald-100/80">Total Interest Payable</span>
                        <span class="font-semibold text-lg text-rose-300" id="loanInterestDisplay">₹ 2,43,912</span>
                    </div>
                    <div class="flex justify-between items-center pt-4 border-t border-white/20">
                        <span class="text-emerald-100 font-semibold">Total Amount Payable</span>
                        <span class="font-semibold text-lg" id="loanTotalDisplay">₹ 7,43,912</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function formatCurrency(num) {
        return '₹ ' + Math.round(num).toLocaleString('en-IN');
    }

    function calculateFD() {
        const P = parseFloat(document.getElementById('fdAmount').value) || 0;
        const R = parseFloat(document.getElementById('fdRate').value) || 0;
        const T = parseFloat(document.getElementById('fdTenure').value) || 0;
        
        // Compound quarterly formula: A = P(1 + r/n)^(nt)
        const n = 4; // Quarterly compounding
        const A = P * Math.pow((1 + (R/100)/n), n * T);
        const I = A - P;

        document.getElementById('fdMaturity').innerText = formatCurrency(A);
        document.getElementById('fdPrincipalDisplay').innerText = formatCurrency(P);
        document.getElementById('fdInterestDisplay').innerText = '+ ' + formatCurrency(I);
    }

    function calculateEMI() {
        const P = parseFloat(document.getElementById('loanAmount').value) || 0;
        const R = parseFloat(document.getElementById('loanRate').value) || 0;
        const T = parseFloat(document.getElementById('loanTenure').value) || 0;
        
        // EMI formula: [P x R x (1+R)^N]/[(1+R)^N-1]
        const r = R / (12 * 100); // monthly interest
        const n = T * 12; // number of months
        
        let emi = 0;
        if(r > 0) {
            emi = (P * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
        } else {
            emi = P / n;
        }

        const totalPayable = emi * n;
        const totalInterest = totalPayable - P;

        document.getElementById('loanEMI').innerText = formatCurrency(emi);
        document.getElementById('loanPrincipalDisplay').innerText = formatCurrency(P);
        document.getElementById('loanInterestDisplay').innerText = formatCurrency(totalInterest);
        document.getElementById('loanTotalDisplay').innerText = formatCurrency(totalPayable);
    }

    function switchTab(tab) {
        const bgFd = 'bg-gradient-to-br from-blue-600 to-indigo-800';
        const bgLoan = 'bg-gradient-to-br from-emerald-600 to-teal-800';
        const container = document.getElementById('result-container');

        if(tab === 'fd') {
            document.getElementById('form-fd').classList.remove('hidden');
            document.getElementById('result-fd').classList.remove('hidden');
            document.getElementById('form-loan').classList.add('hidden');
            document.getElementById('result-loan').classList.add('hidden');
            
            document.getElementById('tab-fd').className = 'px-6 py-2.5 rounded-xl font-semibold text-sm transition-all bg-white dark:bg-slate-700 text-blue-600 dark:text-blue-400 shadow-sm';
            document.getElementById('tab-loan').className = 'px-6 py-2.5 rounded-xl font-semibold text-sm transition-all text-slate-500 hover:text-slate-700 dark:hover:text-slate-300';
            
            container.className = `glass-panel rounded-3xl p-8 shadow-xl ${bgFd} text-white relative overflow-hidden transition-colors duration-500`;
            calculateFD();
        } else {
            document.getElementById('form-fd').classList.add('hidden');
            document.getElementById('result-fd').classList.add('hidden');
            document.getElementById('form-loan').classList.remove('hidden');
            document.getElementById('result-loan').classList.remove('hidden');
            
            document.getElementById('tab-loan').className = 'px-6 py-2.5 rounded-xl font-semibold text-sm transition-all bg-white dark:bg-slate-700 text-emerald-600 dark:text-emerald-400 shadow-sm';
            document.getElementById('tab-fd').className = 'px-6 py-2.5 rounded-xl font-semibold text-sm transition-all text-slate-500 hover:text-slate-700 dark:hover:text-slate-300';
            
            container.className = `glass-panel rounded-3xl p-8 shadow-xl ${bgLoan} text-white relative overflow-hidden transition-colors duration-500`;
            calculateEMI();
        }
    }

    // Init
    calculateFD();
</script>

<jsp:include page="/includes/footer.jsp" />
