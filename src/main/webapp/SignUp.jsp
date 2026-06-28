<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="includes/header.jsp" />

<div class="relative min-h-[85vh] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 overflow-hidden">
    <!-- Animated background elements -->
    <div class="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-secondary/10 rounded-full blur-3xl animate-pulse-slow"></div>
        <div class="absolute bottom-0 left-0 w-[600px] h-[600px] bg-primary/5 rounded-full blur-3xl animate-float"></div>
    </div>

    <div class="relative z-10 w-full max-w-4xl page-enter">
        
        <div class="text-center mb-10">
            <h2 class="text-3xl md:text-5xl font-brand font-bold text-gray-900 dark:text-white mb-3">Join AceBank Today</h2>
            <p class="text-lg text-gray-500 dark:text-gray-400">Experience the future of digital banking.</p>
        </div>

        <!-- Error Message -->
        <% if(request.getParameter("error") != null) { %>
            <div class="mb-8 max-w-2xl mx-auto p-4 rounded-xl bg-red-50/80 dark:bg-red-900/20 border border-red-200 dark:border-red-800/30 flex items-start gap-3">
                <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
                <p class="text-sm font-medium text-red-700 dark:text-red-400"><%= request.getParameter("error").replace("+", " ") %></p>
            </div>
        <% } %>

        <div class="glass-panel rounded-3xl overflow-hidden shadow-2xl flex flex-col lg:flex-row relative">
            
            <!-- Left Info Panel -->
            <div class="lg:w-2/5 bg-gradient-to-br from-primary to-blue-900 p-10 text-white relative overflow-hidden flex flex-col justify-center">
                <div class="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full blur-2xl transform translate-x-1/2 -translate-y-1/2"></div>
                <div class="absolute bottom-0 left-0 w-40 h-40 bg-secondary/20 rounded-full blur-2xl transform -translate-x-1/2 translate-y-1/2"></div>
                
                <div class="relative z-10">
                    <div class="w-16 h-16 bg-white/10 backdrop-blur-md rounded-2xl flex items-center justify-center text-secondary text-2xl mb-8">
                        <i class="fas fa-star"></i>
                    </div>
                    
                    <h3 class="text-2xl font-brand font-bold mb-6">Why open an account with us?</h3>
                    
                    <ul class="space-y-6">
                        <li class="flex items-start gap-4">
                            <div class="mt-1 w-6 h-6 rounded-full bg-blue-500/30 flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-check text-[10px] text-blue-200"></i>
                            </div>
                            <div>
                                <h4 class="font-semibold text-blue-50">Zero Balance Required</h4>
                                <p class="text-sm text-blue-200/70 mt-1">No minimum balance penalties ever.</p>
                            </div>
                        </li>
                        <li class="flex items-start gap-4">
                            <div class="mt-1 w-6 h-6 rounded-full bg-blue-500/30 flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-check text-[10px] text-blue-200"></i>
                            </div>
                            <div>
                                <h4 class="font-semibold text-blue-50">Instant Activation</h4>
                                <p class="text-sm text-blue-200/70 mt-1">Start banking immediately after signup.</p>
                            </div>
                        </li>
                        <li class="flex items-start gap-4">
                            <div class="mt-1 w-6 h-6 rounded-full bg-blue-500/30 flex items-center justify-center flex-shrink-0">
                                <i class="fas fa-check text-[10px] text-blue-200"></i>
                            </div>
                            <div>
                                <h4 class="font-semibold text-blue-50">High Interest Rates</h4>
                                <p class="text-sm text-blue-200/70 mt-1">Earn up to 7% p.a. on your savings.</p>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Right Form Panel -->
            <div class="lg:w-3/5 p-8 lg:p-12">
                <form action="${pageContext.request.contextPath}/signup" method="POST" id="signupForm" class="space-y-6">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">First Name</label>
                            <input type="text" name="firstName" id="firstName" required class="input-field" placeholder="John">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Last Name</label>
                            <input type="text" name="lastName" id="lastName" required class="input-field" placeholder="Doe">
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Aadhar Number</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                                    <i class="fas fa-id-card"></i>
                                </div>
                                <input type="text" name="aadharNumber" id="aadharNumber" maxlength="12" pattern="[0-9]{12}" required class="input-field pl-11" placeholder="123456789012">
                            </div>
                            <p class="mt-1.5 text-[11px] text-slate-500">12-digit number without spaces</p>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Email Address</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <input type="email" name="email" id="email" required class="input-field pl-11" placeholder="john@example.com">
                            </div>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Password</label>
                        <div class="relative" x-data="{ show: false }">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                                <i class="fas fa-lock"></i>
                            </div>
                            <input :type="show ? 'text' : 'password'" name="password" id="password" minlength="8" required class="input-field pl-11 pr-11" placeholder="Create a strong password">
                            <button type="button" @click="show = !show" class="absolute inset-y-0 right-0 pr-4 flex items-center text-slate-400 hover:text-slate-600 focus:outline-none">
                                <i class="fas" :class="show ? 'fa-eye-slash' : 'fa-eye'"></i>
                            </button>
                        </div>
                        
                        <div class="mt-3 flex gap-2" id="password-strength">
                            <div class="h-1.5 w-full rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden"><div class="h-full bg-red-500 w-0 transition-all duration-300"></div></div>
                            <div class="h-1.5 w-full rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden"><div class="h-full bg-yellow-500 w-0 transition-all duration-300"></div></div>
                            <div class="h-1.5 w-full rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden"><div class="h-full bg-green-500 w-0 transition-all duration-300"></div></div>
                        </div>
                        <p class="mt-1.5 text-[11px] text-slate-500" id="password-hint">Min 8 chars, 1 uppercase, 1 number</p>
                    </div>

                    <div class="p-4 rounded-xl bg-slate-50 dark:bg-slate-800/50 border border-slate-100 dark:border-slate-700/50">
                        <label class="flex items-start cursor-pointer group">
                            <div class="relative flex items-center justify-center w-5 h-5 mr-3 mt-0.5 flex-shrink-0">
                                <input type="checkbox" name="terms" required class="peer appearance-none w-5 h-5 rounded border border-slate-300 dark:border-slate-600 checked:bg-blue-600 checked:border-blue-600 transition-colors cursor-pointer">
                                <i class="fas fa-check absolute text-white text-xs opacity-0 peer-checked:opacity-100 pointer-events-none transition-opacity"></i>
                            </div>
                            <span class="text-sm text-slate-600 dark:text-slate-400">
                                I agree to the <a href="#" class="text-blue-600 dark:text-blue-400 font-semibold hover:underline">Terms & Conditions</a> and
                                <a href="#" class="text-blue-600 dark:text-blue-400 font-semibold hover:underline">Privacy Policy</a>. I confirm that I'm 18 years or older.
                            </span>
                        </label>
                    </div>

                    <button type="submit" class="btn-primary w-full py-4 text-lg mt-6 flex justify-center items-center gap-2">
                        Create Account <i class="fas fa-arrow-right text-sm"></i>
                    </button>
                </form>
                
                <p class="mt-8 text-center text-sm text-slate-600 dark:text-slate-400">
                    Already have an account?
                    <a href="Login.jsp" class="font-semibold text-blue-600 dark:text-blue-400 hover:underline">Sign In</a>
                </p>
            </div>
        </div>
    </div>
</div>

<script>
    // Aadhar formatting and validation
    document.getElementById('aadharNumber').addEventListener('input', function(e) {
        this.value = this.value.replace(/[^0-9]/g, '').slice(0, 12);
    });

    // Password strength meter
    document.getElementById('password').addEventListener('input', function(e) {
        const password = this.value;
        const bars = document.querySelectorAll('#password-strength > div > div');
        const hint = document.getElementById('password-hint');
        
        let strength = 0;
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;

        // Reset all
        bars.forEach(bar => bar.style.width = '0%');
        
        if (password.length > 0) {
            bars[0].style.width = '100%';
            hint.textContent = 'Weak';
            hint.className = 'mt-1.5 text-[11px] font-medium text-red-500';
            
            if (strength >= 2) {
                bars[1].style.width = '100%';
                hint.textContent = 'Medium';
                hint.className = 'mt-1.5 text-[11px] font-medium text-yellow-500';
            }
            
            if (strength >= 3) {
                bars[2].style.width = '100%';
                hint.textContent = 'Strong';
                hint.className = 'mt-1.5 text-[11px] font-medium text-green-500';
            }
        } else {
            hint.textContent = 'Min 8 chars, 1 uppercase, 1 number';
            hint.className = 'mt-1.5 text-[11px] text-slate-500';
        }
    });

    document.getElementById('signupForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const aadhar = document.getElementById('aadharNumber').value;

        if(aadhar.length !== 12) {
            e.preventDefault();
            if(window.AceBank) AceBank.showToast('Please enter a valid 12-digit Aadhar number', 'error');
            else alert('Please enter a valid 12-digit Aadhar number');
            return;
        }

        if(password.length < 8 || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
            e.preventDefault();
            if(window.AceBank) AceBank.showToast('Password must be at least 8 chars with 1 uppercase and 1 number', 'error');
            else alert('Password must be at least 8 characters with 1 uppercase and 1 number');
        }
    });
</script>

<jsp:include page="includes/footer.jsp" />